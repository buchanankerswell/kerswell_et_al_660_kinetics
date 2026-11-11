import argparse
from dataclasses import dataclass
from pathlib import Path

import matplotlib.colors as mcolors
import matplotlib.pyplot as plt
import numpy as np
from utils.logging import log_artifact
from matplotlib.axes import Axes
from matplotlib.collections import QuadMesh

@dataclass(frozen=True)
class AnomalyParams:
    x0: float
    y0: float
    dx: float
    dy: float
    L: float
    W: float
    dT: float
    A: float

    @classmethod
    def from_args(cls, args, prefix: str, dT: float, s: float = 1e-3):
        x0 = getattr(args, f"x0_{prefix}")
        y0 = getattr(args, f"y0_{prefix}")
        x1 = getattr(args, f"x1_{prefix}")
        y1 = getattr(args, f"y1_{prefix}")

        return cls(
            x0=x0 * s,
            y0=y0 * s,
            dx=(x1 - x0) * s,
            dy=(y1 - y0) * s,
            L=getattr(args, f"l_{prefix}") * s,
            W=getattr(args, f"w_{prefix}") * s,
            A=getattr(args, f"a_{prefix}") * s,
            dT=dT,
        )

@dataclass(frozen=True)
class InitialSetupConfig:
    x_extent: float
    y_extent: float
    phase_y: tuple = (640.8, 493.85, 400.27)
    plot_width: float = 5.0
    plot_height: float = 6.5

    @classmethod
    def from_args(cls, args, s: float = 1e-3):
        return cls(x_extent=args.width * s, y_extent=args.height * s)

def parse_arguments():
    parser = argparse.ArgumentParser(description="Visualize ASPECT initial conditions.")
    parser.add_argument("--width", type=float, default=1500e3)
    parser.add_argument("--height", type=float, default=1000e3)
    parser.add_argument("--out-fig-dir", type=str, default="./figures")

    for suffix in ["x0", "y0", "x1", "y1", "dx", "dy", "w", "l", "a"]:
        parser.add_argument(f"--{suffix}-slab", type=float)

    return parser.parse_args()

def compute_thermal_anomaly(X: np.ndarray, Y: np.ndarray, p: AnomalyParams) -> np.ndarray:
    """Calculates anomaly using tanh."""
    x_shifted = X - p.x0
    y_shifted = Y - p.y0

    perp_dist = x_shifted * (-p.dy) + y_shifted * p.dx
    parallel_dist = x_shifted * p.dx + y_shifted * p.dy

    gaussian_term = np.exp(-(perp_dist**2) / (2 * p.W**2 * p.L**2))
    tanh1 = 1 + np.tanh((parallel_dist / p.L) / p.A)
    tanh2 = 1 + np.tanh((p.L - parallel_dist / p.L) / p.A)

    return p.dT * gaussian_term * 0.25 * tanh1 * tanh2

def draw_initial_conditions(
    ax: Axes,
    X: np.ndarray,
    Y: np.ndarray,
    T: np.ndarray,
    cmap: mcolors.Colormap,
    config: InitialSetupConfig,
    bc_labels: dict,
    title: str,
    text_offset: float = 45.0,
    show_xlabel: bool = False,
    slab_only: bool = False,
) -> QuadMesh:

    contour = ax.pcolormesh(X, Y, T, cmap=cmap, shading="gouraud", rasterized=True, vmin=-500, vmax=500)

    for _, y in enumerate(config.phase_y):
        ax.hlines(
            y=config.y_extent - y,
            xmin=0,
            xmax=config.x_extent,
            color="black",
            alpha=0.1,
            linewidth=5,
            zorder=1,
        )

    ax.set_xlim(0, config.x_extent)
    ax.set_ylim(0, config.y_extent)
    ax.set_aspect("equal")

    is_slab = "Slab" in title

    if slab_only:
        # All BC labels sit outside the domain (or clear of the anomaly and
        # transition bands) with no background boxes and no panel title. The
        # two top BCs sit above the axes where the title was; a single lateral
        # label sits outside the right edge (left and right BCs are identical);
        # the bottom BC stays centered near the bottom boundary.
        ax.text(
            0.0, 1.02,
            bc_labels["top2"],
            transform=ax.transAxes, ha="left", va="bottom",
            fontsize=14, clip_on=False,
        )
        ax.text(
            1.0, 1.02,
            bc_labels["top1"],
            transform=ax.transAxes, ha="right", va="bottom",
            fontsize=14, clip_on=False,
        )
        right = ax.text(
            1.07, 0.5,
            bc_labels["right"],
            transform=ax.transAxes, ha="center", va="center",
            fontsize=14, clip_on=False,
        )
        right.set_rotation(90)
        ax.text(
            config.x_extent / 2, text_offset,
            bc_labels["bottom1"],
            ha="center", va="bottom", fontsize=14,
        )
        for name, band_y in zip(
            ("410", "520", "660"),
            sorted((config.y_extent - y for y in config.phase_y), reverse=True),
        ):
            ax.text(
                30.0, band_y - 18.0, name,
                ha="left", va="top", fontsize=13, color="#4D4D4D", zorder=5,
            )
    else:
        def add_label(text, x, y, ha, va):
            if text:
                bbox_props = dict(boxstyle="square,pad=0.0", facecolor="0.9", edgecolor="none", alpha=0.7)
                ax.text(x, y, text, ha=ha, va=va, fontsize=14, bbox=bbox_props)

        add_label(
            bc_labels["top1"],
            config.x_extent - text_offset if is_slab else config.x_extent / 2,
            config.y_extent - text_offset,
            "right" if is_slab else "center",
            "top",
        )

        add_label(
            bc_labels["top2"], text_offset if is_slab else config.x_extent / 2, config.y_extent - text_offset, "left" if is_slab else "center", "top"
        )

        add_label(bc_labels["bottom1"], config.x_extent / 2 if is_slab else text_offset, text_offset, "center" if is_slab else "left", "bottom")

        add_label(
            bc_labels["bottom2"],
            config.x_extent / 2 if is_slab else config.x_extent - text_offset,
            text_offset,
            "center" if is_slab else "right",
            "bottom",
        )

        add_label(bc_labels["left"], text_offset * 2.6, config.y_extent / 2, "center", "center")
        ax.texts[-1].set_rotation(90)

        add_label(bc_labels["right"], config.x_extent - text_offset * 2.6, config.y_extent / 2, "center", "center")
        ax.texts[-1].set_rotation(90)

    if is_slab and not show_xlabel:
        ax.set_xticks([])
    else:
        ax.set_xlabel("X (km)")

    ax.set_ylabel("Y (km)")
    if not slab_only:
        ax.set_title(title, fontsize=20)
    ax.tick_params(axis="both", which="both", length=0)

    return contour

def main():
    args = parse_arguments()
    out_dir = Path(args.out_fig_dir) if args.out_fig_dir else Path("./figures")
    out_path = out_dir / "initial-setup-diagram.png"

    if out_path.exists():
        return

    out_path.parent.mkdir(parents=True, exist_ok=True)

    config = InitialSetupConfig.from_args(args)
    slab = AnomalyParams.from_args(args, "slab", dT=-500)

    plt.rcParams.update(
        {
            "figure.dpi": 300,
            "savefig.bbox": "tight",
            "axes.facecolor": "0.9",
            "axes.edgecolor": "#4D4D4D",
            "legend.frameon": False,
            "legend.facecolor": "0.9",
            "legend.loc": "upper left",
            "legend.fontsize": "small",
            "figure.autolayout": True,
            "axes.labelsize": 18,
            "xtick.labelsize": 14,
            "ytick.labelsize": 14,
            "xtick.color": "#4D4D4D",
            "ytick.color": "#4D4D4D",
        }
    )

    x = np.linspace(0, config.x_extent, 900)
    y = np.linspace(0, config.y_extent, 600)
    X, Y = np.meshgrid(x, y)

    T_slab = compute_thermal_anomaly(X, Y, slab)

    original_cmap = plt.get_cmap("seismic")
    cmap_colors = original_cmap(np.linspace(0, 1, 13))
    cmap_colors[6] = mcolors.to_rgba("#E6E6E6")
    cmap_modified = mcolors.LinearSegmentedColormap.from_list("bright_smooth_seismic", cmap_colors)

    bc_slab = {
        "top1": "$\\vec{u}_x$=$f(x)$, $\\vec{u}_y$=$f(x)$",
        "top2": "Fixed $T$",
        "right": "$\\sigma_{xx}$ = $d\\bar{P}/dy$\n $\\vec{u}_x$=0",
        "left": "$\\sigma_{xx}$ = $d\\bar{P}/dy$\n $\\vec{u}_x$=0",
        "bottom1": "$\\sigma_{yy}$ = $\\bar{P}(bottom)$, $\\vec{u}_x$=0",
        "bottom2": None,
    }

    fig = plt.figure(figsize=(config.plot_width + 0.8, 3.6), constrained_layout=True)
    gs = fig.add_gridspec(1, 1)
    ax_s = fig.add_subplot(gs[0, 0])
    cs = draw_initial_conditions(ax_s, X, Y, T_slab, cmap_modified, config, bc_slab, "Slab Setup", show_xlabel=True, slab_only=True)
    cax = fig.add_axes([0.25, -0.08, 0.55, 0.05])  # pyright: ignore

    ticks = [-500, -250, 0, 250, 500]
    cbar = fig.colorbar(cs, cax=cax, ticks=ticks, orientation="horizontal")
    cbar.set_label("Thermal Anomaly (K)", fontsize=15)
    plt.setp(cbar.outline, visible=True, linewidth=1.2, edgecolor="#4D4D4D")
    cbar.ax.tick_params(axis="x", colors="#4D4D4D", labelsize=14, length=0, pad=5)

    plt.savefig(out_path, bbox_inches="tight", pad_inches=0.05)
    log_artifact(out_path)

if __name__ == "__main__":
    main()
