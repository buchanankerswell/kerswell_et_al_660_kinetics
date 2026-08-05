#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import matplotlib

#######################################################
## .1. Field Defaults Table                      !!! ##
#######################################################
# Single source of truth for all per-field display configuration
# Columns: file_id, cmap, clim, label, fmt, scaling, edges, transition_contours, representative_trace
_FIELD_DEFAULTS: dict[str, tuple] = {
    # fmt: off
    "T":                        ("temperature-full",         "magma",    "auto",      "$T$ (K)",                           "%.0f", 1,        False, False, False, ),
    "nonadiabatic_temperature": ("temperature-nonadiabatic", "seismic",  "auto",      "$\\hat{T}$ (K)",                    "%.0f", 1,        True,  True,  True,  ),
    "p":                        ("pressure-full",            "Oranges",  "auto",      "$P$ (GPa)",                         "%.0f", 1e-9,     False, False, False, ),
    "nonadiabatic_pressure":    ("pressure-nonadiabatic",    "PuOr_r",   "auto",      "$\\hat{P}$ (MPa)",                  "%.0f", 1e-6,     False, False, False, ),
    "density":                  ("density-full",             "Purples",  "auto",      "$\\rho$ (g/cm$^3$)",                "%.1f", 1e-3,     False, False, False, ),
    "nonadiabatic_density":     ("density-nonadiabatic",     "BrBG",     "auto",      "$\\hat{\\rho}$ (g/cm$^3$)",         "%.1f", 1e-3,     True,  False, False, ),
    "seismic_Vp":               ("vp",                       "copper_r", "auto",      "$V_p$ (km/s)",                      "%.1f", 1e-3,     False, False, False, ),
    "seismic_Vs":               ("vs",                       "copper_r", "auto",      "$V_s$ (km/s)",                      "%.1f", 1e-3,     False, False, False, ),
    "velocity":                 ("velocity-cart",            "PiYG",     "auto",      "$\\vec{u}$ (cm/yr)",                "%.1f", 1e2,      False, False, False, ),
    "velocity_vertical":        ("velocity-vertical",        "PiYG",     "auto",      "$\\vec{u}_y$ (cm/yr)",              "%.1f", 1e2,      True,  False, False, ),
    "viscosity":                ("viscosity",                "bone_r",   (19, 24),    "Log $\\eta$ (Pa s)",                "%.0f", 1,        True,  True,  True,  ),
    "stress_second_invariant":  ("sigma-ii",                 "Reds",     "auto",      "$\\sigma_{II}$ (MPa)",              "%.0f", 1e-6,     False, False, False, ),
    "strain_rate":              ("strain-rate",              "BuPu_r",   "auto",      "Log $\\dot{\\epsilon}_{II}$ (1/s)", "%.1f", 3.154e13, False, False, False, ),
    "X_ol":                     ("X-ol",                     "GnBu",     (0.0, 1.0),  "X ol",                              "%.1f", 1,        True,  True,  True,  ),
    "X_wd":                     ("X-wd",                     "GnBu",     (0.0, 1.0),  "X wd",                              "%.1f", 1,        True,  True,  True,  ),
    "X_ri":                     ("X-ri",                     "GnBu",     (0.0, 1.0),  "X ri",                              "%.1f", 1,        True,  True,  True,  ),
    "X_ps":                     ("X-ps",                     "GnBu",     (0.0, 1.0),  "X ps",                              "%.1f", 1,        True,  True,  True,  ),
    "xi_ol_wd":                 ("xi-ol-wd",                 "GnBu",     (0.0, 1.0),  "$\\xi$ ol-wd",                      "%.1f", 1,        False, True,  True,  ),
    "xi_wd_ri":                 ("xi-wd-ri",                 "GnBu",     (0.0, 1.0),  "$\\xi$ wd-ri",                      "%.1f", 1,        False, True,  True,  ),
    "xi_ri_ps":                 ("xi-ri-ps",                 "GnBu",     (0.0, 1.0),  "$\\xi$ ri-ps",                      "%.1f", 1,        False, True,  True,  ),
    "arrhenius_ol_wd":          ("arrhenius-ol-wd",          "bone_r",   "auto",      "Log Arrhenius term ol-wd",          "%.1f", 1,        False, False, False, ),
    "arrhenius_wd_ri":          ("arrhenius-wd-ri",          "bone_r",   "auto",      "Log Arrhenius term wd-ri",          "%.1f", 1,        False, False, False, ),
    "arrhenius_ri_ps":          ("arrhenius-ri-ps",          "bone_r",   "auto",      "Log Arrhenius term ri-ps",          "%.1f", 1,        False, False, False, ),
    "thermodynamic_ol_wd":      ("thermodynamic-ol-wd",      "PRGn_r",   (-1.0, 1.0), "Thermodynamic term ol-wd",          "%.1f", 1,        False, False, False, ),
    "thermodynamic_wd_ri":      ("thermodynamic-wd-ri",      "PRGn_r",   (-1.0, 1.0), "Thermodynamic term wd-ri",          "%.1f", 1,        False, False, False, ),
    "thermodynamic_ri_ps":      ("thermodynamic-ri-ps",      "PRGn_r",   "auto",      "Thermodynamic term ri-ps",          "%.0e", 1,        False, False, False, ),
    "reaction_rate_C0":         ("reaction-rate-ol-wd",      "RdGy_r",   "auto",      "Log $\\dot{X}$ ol-wd (1/Ma)",       "%.2f", 3.154e13, True,  True,  True,  ),
    "reaction_rate_C1":         ("reaction-rate-wd-ri",      "RdGy_r",   "auto",      "Log $\\dot{X}$ wd-ri (1/Ma)",       "%.2f", 3.154e13, True,  True,  True,  ),
    "reaction_rate_C2":         ("reaction-rate-ri-ps",      "RdGy_r",   "auto",      "Log $\\dot{X}$ ri-ps (1/Ma)",       "%.2f", 3.154e13, True,  True,  True,  ),
    # fmt: on
}


#######################################################
## .2. MeshConfig                                !!! ##
#######################################################
@dataclass
class MeshConfig:
    """Configuration for mesh plotting and post-processing pipelines.

    Per-field display settings (colormap, limits, labels, scaling) are
    populated from _FIELD_DEFAULTS in __post_init__ unless overridden at
    construction time. All six field maps share identical keys, derived from
    the same source table.

    Plotting flags (draw_X_*_contours) are read by MeshPlotter via
    _PHASE_CONTOUR_MAP. The scale_bar_enabled flag is checked by plot_mesh
    before calling _add_scale_bar.

    plot_rcParams is applied to matplotlib.rcParams in __post_init__ so all
    figures produced in the session inherit the configured style.
    """

    # Phase contour toggles (read by MeshPlotter._PHASE_CONTOUR_MAP)
    draw_X_ol_contours: bool = True
    draw_X_wd_contours: bool = False
    draw_X_ri_contours: bool = False
    draw_X_ps_contours: bool = True
    transition_contour_color: str = "black"

    # Per-field display maps (populated from _FIELD_DEFAULTS if empty)
    file_map: dict[str, str] = field(default_factory=dict)
    cmap_map: dict[str, str] = field(default_factory=dict)
    clim_map: dict[str, tuple[float, float] | str] = field(default_factory=dict)
    label_map: dict[str, str] = field(default_factory=dict)
    format_map: dict[str, str] = field(default_factory=dict)
    scaling_map: dict[str, float] = field(default_factory=dict)
    edges_map: dict[str, bool] = field(default_factory=dict)
    transition_contours_map: dict[str, bool] = field(default_factory=dict)
    trace_map: dict[str, bool] = field(default_factory=dict)

    # Colormap / colorbar settings
    n_colors: int = 11
    cbar_vertical: bool = False
    cbar_title_font_size: int = 115
    cbar_label_font_size: int = 115
    cbar_width: float = 0.6
    cbar_height: float = 0.13
    cbar_n_labels: int = 3
    cbar_position: list[float] = field(default_factory=lambda: [0.20, 0.12])

    # Output / render settings
    default_fig_dir: Path = Path("figs/simulation")
    plotter_window_size: list[int] = field(default_factory=lambda: [1920, 1920])
    screenshot_dpi: tuple[int, int] = field(default_factory=lambda: (330, 330))  # passed to PIL Image.save

    # Camera settings
    camera_y_shift_factor: float = -0.15
    camera_zoom_factor: float = 1.95

    # Scale bar settings
    scale_bar_enabled: bool = True
    scale_bar_color: str = "black"
    scale_bar_thickness: float = 30
    scale_bar_length_fraction: float = 0.25
    scale_bar_position: tuple = (0.05, 0.08)
    scale_bar_label_font_size: int = 115
    scale_bar_label_shift_factor: float = 0.01

    # Trace and arrow indicators
    trace_line_color: str = "white"
    v_arrow_color: str = "white"
    v_arrow_alpha: float = 1.0
    v_arrow_length: float = 60e3
    v_arrow_tip_length: float = 0.35
    v_arrow_tip_radius: float = 0.22
    v_arrow_shaft_radius: float = 0.08

    # Matplotlib rcParams applied globally on init
    plot_rcParams: dict[str, Any] = field(
        default_factory=lambda: {
            "figure.dpi": 300,
            "savefig.bbox": "tight",
            "axes.facecolor": "0.9",
            "legend.frameon": False,
            "legend.facecolor": "0.9",
            "legend.loc": "upper left",
            "legend.fontsize": "small",
            "figure.autolayout": True,
            "font.size": 14,
        }
    )

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def __post_init__(self) -> None:
        """Populate per-field maps from _FIELD_DEFAULTS and apply rcParams."""
        if not self.file_map:
            self.file_map = {f: v[0] for f, v in _FIELD_DEFAULTS.items()}
        if not self.cmap_map:
            self.cmap_map = {f: v[1] for f, v in _FIELD_DEFAULTS.items()}
        if not self.clim_map:
            self.clim_map = {f: v[2] for f, v in _FIELD_DEFAULTS.items()}
        if not self.label_map:
            self.label_map = {f: v[3] for f, v in _FIELD_DEFAULTS.items()}
        if not self.format_map:
            self.format_map = {f: v[4] for f, v in _FIELD_DEFAULTS.items()}
        if not self.scaling_map:
            self.scaling_map = {f: v[5] for f, v in _FIELD_DEFAULTS.items()}
        if not self.edges_map:
            self.edges_map = {f: v[6] for f, v in _FIELD_DEFAULTS.items()}
        if not self.transition_contours_map:
            self.transition_contours_map = {f: v[7] for f, v in _FIELD_DEFAULTS.items()}
        if not self.trace_map:
            self.trace_map = {f: v[8] for f, v in _FIELD_DEFAULTS.items()}

        if self.plot_rcParams:
            matplotlib.rcParams.update(self.plot_rcParams)
