#######################################################
## .0. Load Libraries                                ##
#######################################################
import argparse
from dataclasses import dataclass
from pathlib import Path

import matplotlib.colors as mcolors
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.axes import Axes
from matplotlib.collections import QuadMesh


#######################################################
## .1. Dataclasses                                   ##
#######################################################
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


#######################################################
## .2. Helpers                                       ##
#######################################################
def parse_arguments():
    parser = argparse.ArgumentParser(description="Visualize ASPECT initial conditions.")
    parser.add_argument("--width", type=float, default=1500e3)
    parser.add_argument("--height", type=float, default=1000e3)
    parser.add_argument("--out-fig-dir", type=str, default="./figures")

    for p in ["slab", "plume"]:
        for suffix in ["x0", "y0", "x1", "y1", "dx", "dy", "w", "l", "a"]:
            parser.add_argument(f"--{suffix}-{p}", type=float)

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
) -> QuadMesh:

    contour = ax.pcolormesh(X, Y, T, cmap=cmap, shading="gouraud", rasterized=True, vmin=-500, vmax=500)

    for _, y in enumerate(config.phase_y):
        ax.hlines(y=config.y_extent - y, xmin=0, xmax=config.x_extent, color="black", alpha=0.1, linewidth=5)
        # ax.text(config.x_extent / 2, config.y_extent - y + 5, labels[i], ha="center", fontsize=12, verticalalignment="bottom")

    ax.set_xlim(0, config.x_extent)
    ax.set_ylim(0, config.y_extent)
    ax.set_aspect("equal")

    is_slab = "Slab" in title

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

    if is_slab:
        ax.set_xticks([])
    else:
        ax.set_xlabel("X (km)")

    ax.set_ylabel("Y (km)")
    ax.set_title(title, fontsize=20)
    ax.tick_params(axis="both", which="both", length=0)

    return contour


#######################################################
## .3. Main                                          ##
#######################################################
def main():
    args = parse_arguments()
    out_dir = Path(args.out_fig_dir) if args.out_fig_dir else Path("./figures")
    out_path = out_dir / "initial-setup-diagram.png"

    if out_path.exists():
        return

    out_path.parent.mkdir(parents=True, exist_ok=True)

    config = InitialSetupConfig.from_args(args)
    slab = AnomalyParams.from_args(args, "slab", dT=-500)
    plume = AnomalyParams.from_args(args, "plume", dT=500)

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
            "xtick.labelsize": 15,
            "ytick.labelsize": 15,
            "xtick.color": "#4D4D4D",
            "ytick.color": "#4D4D4D",
        }
    )

    x = np.linspace(0, config.x_extent, 900)
    y = np.linspace(0, config.y_extent, 600)
    X, Y = np.meshgrid(x, y)

    T_slab = compute_thermal_anomaly(X, Y, slab)
    T_plume = compute_thermal_anomaly(X, Y, plume)

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

    bc_plume = {
        "top1": "$\\sigma_{yy}$ = $\\bar{P}(top)$, $\\vec{u}_x$=0",
        "top2": None,
        "right": "$\\sigma_{xx}$ = $d\\bar{P}/dy$\n $\\vec{u}_x$=0",
        "left": "$\\sigma_{xx}$ = $d\\bar{P}/dy$\n $\\vec{u}_x$=0",
        "bottom1": "Fixed $T$",
        "bottom2": "$\\vec{u}_x$=0, $\\vec{u}_y$=$f(x)$",
    }

    fig = plt.figure(figsize=(config.plot_width, config.plot_height), constrained_layout=True)
    gs = fig.add_gridspec(2, 1)

    ax_s = fig.add_subplot(gs[0, 0])
    ax_p = fig.add_subplot(gs[1, 0])

    cs = draw_initial_conditions(ax_s, X, Y, T_slab, cmap_modified, config, bc_slab, "Slab Setup")
    _ = draw_initial_conditions(ax_p, X, Y, T_plume, cmap_modified, config, bc_plume, "Plume Setup")

    ticks = [-500, -250, 0, 250, 500]
    cax = fig.add_axes([0.28, -0.04, 0.55, 0.028])  # pyright: ignore
    cbar = fig.colorbar(cs, cax=cax, ticks=ticks, orientation="horizontal")
    cbar.set_label("Thermal Anomaly (K)")
    plt.setp(cbar.outline, visible=True, linewidth=1.2, edgecolor="#4D4D4D")
    cbar.ax.tick_params(axis="x", colors="#4D4D4D", labelsize=13, length=0, pad=5)

    plt.savefig(out_path, bbox_inches="tight", pad_inches=0.05)
    print(f" -> {out_path}")


if __name__ == "__main__":
    main()
