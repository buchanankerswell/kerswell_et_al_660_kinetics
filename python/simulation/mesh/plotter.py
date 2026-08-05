#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import gc
from dataclasses import dataclass
from pathlib import Path
from typing import ClassVar

import matplotlib.colors as mcolors
import matplotlib.pyplot as plt
import numpy as np
import pyvista as pv
import vtk
from config import MeshConfig
from PIL import Image
from pyvista import Color
from vtkmodules.vtkCommonCore import vtkLogger

vtkLogger.SetStderrVerbosity(vtkLogger.VERBOSITY_ERROR)


#######################################################
## .1. MeshPlotter                               !!! ##
#######################################################
@dataclass
class MeshPlotter:
    """
    Renders scalar field plots of simulation meshes to PNG files.

    Handles colormap configuration, phase fraction contours, annotation lines, scale bars, and camera setup. Skips files that already exist on disk.
    """

    config: MeshConfig
    trans_info: dict
    verbosity: int = 0

    # Phase fraction fields and the config flag that enables their contours.
    # Add entries here to include additional phase contours without changing logic.
    _PHASE_CONTOUR_MAP: ClassVar[dict[str, str]] = {
        "X_ol": "draw_X_ol_contours",
        "X_wd": "draw_X_wd_contours",
        "X_ri": "draw_X_ri_contours",
        "X_ps": "draw_X_ps_contours",
    }

    # Colormap classification sets for O(1) lookup.
    _DIVERGING_CMAPS: ClassVar[set[str]] = {
        name + suffix
        for name in ["PiYG", "PRGn", "BrBG", "PuOr", "RdBu", "RdGy", "RdYlBu", "RdYlGn", "Spectral", "coolwarm", "bwr", "seismic"]
        for suffix in ("", "_r")
    }
    _SEQUENTIAL_CMAPS: ClassVar[set[str]] = {
        name + suffix
        for name in [
            "viridis",
            "plasma",
            "inferno",
            "magma",
            "cividis",
            "gist_heat",
            "pink",
            "bone",
            "afmhot",
            "copper",
            "Greys",
            "Purples",
            "Blues",
            "Greens",
            "Oranges",
            "Reds",
            "YlOrBr",
            "YlOrRd",
            "OrRd",
            "PuRd",
            "RdPu",
            "BuPu",
            "GnBu",
            "PuBu",
            "YlGnBu",
            "PuBuGn",
            "BuGn",
            "YlGn",
        ]
        for suffix in ("", "_r")
    }

    # Sequential colormaps where the first (low) color is replaced rather than the last.
    _SEQ_REPLACE_FIRST: ClassVar[set[str]] = {
        "gist_heat_r",
        "pink_r",
        "bone_r",
        "afmhot_r",
        "copper_r",
        "Purples",
        "BuPu",
        "Reds",
        "Oranges",
        "YlOrBr",
        "GnBu",
    }

    # Fields whose scalars are log-transformed before display
    _LOG_FIELDS: ClassVar[set[str]] = {"viscosity", "strain_rate", "arrhenius_ol_wd", "arrhenius_wd_ri", "arrhenius_ri_ps"}

    # Fields whose scalars use signed-log transformation before display
    _SIGNED_LOG_FIELDS: ClassVar[set[str]] = {"reaction_rate_C0", "reaction_rate_C1", "reaction_rate_C2"}

    # Phase fraction fields for which the sequential colormap end-color is modified
    _MODIFIED_SEQ_FIELDS: ClassVar[set[str]] = {"stress_second_invariant", "X_ol", "X_wd", "X_ri", "X_ps"}

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def plot_mesh(
        self,
        mesh: pv.UnstructuredGrid,
        field: str,
        out_path: Path,
        annotations: list[dict] | None = None,
        contour_color: str = "black",
    ) -> None:
        """
        Render a scalar field plot of the mesh and save it to out_path.

        Skips rendering if the output file already exists. Optionally draws a vertical profile line and horizontal depth-bound lines as annotations.

        Args:
            mesh:                    Mesh to render. Must contain the requested field.
            field:                   Name of the scalar field to display.
            out_path:                Destination PNG file path.
            profile_x_pos:           x-coordinate (m) of the vertical annotation line. Skipped if nan.
            profile_x_depth_bounds:  (lower, upper) depth coordinates (m) for horizontal annotation lines. Each is skipped if nan.
            contour_color:           Color for phase fraction contour lines.
        """
        if out_path.exists():
            return

        print(f" -> {out_path.name}")
        cfg = self.config
        annotations = annotations or []

        viz_scalars, cmap, clim = self._configure_cmap(mesh, field)

        sargs = dict(
            title=cfg.label_map.get(field, field),
            vertical=cfg.cbar_vertical,
            title_font_size=cfg.cbar_title_font_size,
            label_font_size=cfg.cbar_label_font_size,
            fmt=cfg.format_map.get(field, "%.1f"),
            width=cfg.cbar_width,
            height=cfg.cbar_height,
            n_labels=cfg.cbar_n_labels,
            position_x=cfg.cbar_position[0],
            position_y=cfg.cbar_position[1],
        )

        pl: pv.Plotter = pv.Plotter(off_screen=True, window_size=cfg.plotter_window_size, lighting="none")
        pl.background_color = Color("#FFFFFF")
        edges = cfg.edges_map.get(field, False)
        pl.add_mesh(mesh, scalars=viz_scalars, cmap=cmap, clim=clim, scalar_bar_args=sargs, nan_color="#FEFEFE", show_edges=edges, edge_opacity=0.5)  # type: ignore

        if cfg.transition_contours_map.get(field, False):
            self._add_phase_contours(pl, mesh, contour_color)

            if field in self.trans_info:
                transition_data = self.trans_info.get(field)
                if transition_data:
                    rxn_y = transition_data[-2]
                    self._add_horizontal_line(pl, mesh, rxn_y, cfg.transition_contour_color)

        for ann in annotations:
            ann_type = ann.get("type", "arrows")

            if ann_type == "trace":
                self._add_trace_line(pl, ann["depths"], ann["x_positions"], ann["y_max"])
                continue

            x_pos = ann.get("x", np.nan)
            bounds = ann.get("bounds", (np.nan, np.nan))
            lower_bound, upper_bound = bounds

            if np.isnan(x_pos) or np.isnan(lower_bound) or np.isnan(upper_bound):
                continue

            self._add_vertical_arrows(
                pl,
                mesh,
                x_pos,
                lower_bound,
                upper_bound,
                arrow_length=cfg.v_arrow_length,
                tip_length=cfg.v_arrow_tip_length,
                tip_radius=cfg.v_arrow_tip_radius,
                shaft_radius=cfg.v_arrow_shaft_radius,
                color=cfg.v_arrow_color,
                alpha=cfg.v_arrow_alpha,
            )

        pl.camera_position = self._compute_camera_settings(mesh)
        pl.enable_parallel_projection()  # type: ignore
        self._add_scale_bar(mesh, pl)

        pl.screenshot(out_path)
        pl.close()
        pv.close_all()
        gc.collect()

        try:
            img = Image.open(out_path)
            img.save(out_path, dpi=cfg.screenshot_dpi)
        except Exception as e:
            if self.verbosity >= 1:
                print(f" !! Warning: PIL failed to resave {out_path.name} with new DPI:\n    {e}")

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _add_phase_contours(self, pl: pv.Plotter, mesh: pv.UnstructuredGrid, color: str = "black", alpha: float = 1.0, line_width: int = 7) -> None:
        """
        Draw X=0.1 and X=0.9 contours for each enabled phase fraction field.

        Which fields are drawn is controlled by _PHASE_CONTOUR_MAP and the corresponding boolean flags in MeshConfig.
        """
        for phase_field, config_flag in self._PHASE_CONTOUR_MAP.items():
            if not getattr(self.config, config_flag, False):
                continue
            if phase_field not in mesh.point_data:
                continue
            try:
                contour = mesh.contour(isosurfaces=[0.1, 0.9], scalars=phase_field)
                pl.add_mesh(contour, color=color, opacity=alpha, line_width=line_width, render_lines_as_tubes=True)
            except Exception as e:
                if self.verbosity >= 1:
                    print(f" !! Warning: failed generating {phase_field} contours:\n    {e}")

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _add_trace_line(
        self,
        pl: pv.Plotter,
        depths: np.ndarray,
        x_positions: np.ndarray,
        y_max: float,
        color: str | None = None,
        line_width: int = 7,
        alpha: float = 0.85,
    ) -> None:
        """
        Draw the representative trace profile as a smooth polyline.

        Converts the depth/x-position arrays that come from _extract_representative_profile into 3-D points in mesh coordinates (y = y_max - depth)
        and renders them as a connected tube.

        Args:
            pl:          Active PyVista plotter.
            depths:      Depth coordinate array (m).
            x_positions: x-coordinate of the maximum-anomaly point at each depth (m).
            y_max:       Mesh upper-boundary y-coordinate, used to convert depth to y.
            color:       Line colour.  Defaults to config.trace_line_color if available, otherwise 'white'.
            line_width:  Rendered line width in pixels.
            alpha:       Line opacity.
        """
        color = color or getattr(self.config, "trace_line_color", "white")

        valid = ~(np.isnan(depths) | np.isnan(x_positions))
        if valid.sum() < 2:
            return

        pts = np.column_stack([x_positions[valid], y_max - depths[valid], np.zeros(valid.sum())])

        sort_idx = np.argsort(pts[:, 1])
        polyline = pv.lines_from_points(pts[sort_idx], close=False)
        pl.add_mesh(polyline, color=color, line_width=line_width, opacity=alpha, render_lines_as_tubes=True)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _add_vertical_line(
        self,
        pl: pv.Plotter,
        mesh: pv.UnstructuredGrid,
        x_pos: float,
        color: str = "black",
        alpha: float = 1.0,
        line_width: int = 5,
    ) -> None:
        """
        Draw a smooth vertical annotation line by slicing the mesh at x = x_pos.

        The slice interpolates point positions within cells, avoiding the staircase artifact from connecting raw grid nodes.

        Args:
            pl:            Active PyVista plotter.
            mesh:          Source mesh used to find point coordinates.
            x_pos:         x-coordinate of the line (m).
            color:         Line color.
            alpha:         Line opacity.
            line_width:    Rendered line width in pixels.
        """
        try:
            slc = mesh.slice(normal=[1.0, 0.0, 0.0], origin=[x_pos, 0.0, 0.0])
        except Exception:
            return
        if slc.n_points < 2:
            return

        pts = slc.points
        sort_idx = np.argsort(pts[:, 1])
        polyline = pv.lines_from_points(pts[sort_idx], close=False)
        pl.add_mesh(polyline, color=color, line_width=line_width, opacity=alpha, render_lines_as_tubes=True)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _add_horizontal_line(
        self,
        pl: pv.Plotter,
        mesh: pv.UnstructuredGrid,
        depth: float,
        color: str = "black",
        alpha: float = 1.0,
        line_width: int = 5,
    ) -> None:
        """
        Draw a horizontal line at the given mesh-relative depth.

        Args:
            pl:            Active PyVista plotter.
            mesh:          Source mesh; must contain a 'depth' point data array.
            depth:         Mesh-relative depth coordinate of the line (m).
            color:         Line color.
            alpha:         Line opacity.
            line_width:    Rendered line width in pixels.
        """
        if "depth" not in mesh.point_data:
            if self.verbosity >= 1:
                print(" !! Warning: 'depth' field not found in mesh")
            return

        try:
            slc = mesh.slice(normal=[0.0, 1.0, 0.0], origin=[0.0, depth, 0.0])
        except Exception:
            return
        if slc.n_points < 2:
            return

        pts = slc.points
        sort_idx = np.argsort(pts[:, 0])
        polyline = pv.lines_from_points(pts[sort_idx], close=False)
        pl.add_mesh(polyline, color=color, line_width=line_width, opacity=alpha, render_lines_as_tubes=True)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _add_vertical_arrows(
        self,
        plotter: pv.Plotter,
        mesh: pv.UnstructuredGrid,
        x_pos: float,
        lower_depth: float,
        upper_depth: float,
        arrow_length: float = 15e3,
        tip_length: float = 0.25,
        tip_radius: float = 0.1,
        shaft_radius: float = 0.05,
        color: str = "black",
        alpha: float = 1.0,
        tolerance_m: float = 5e3,
    ) -> None:
        """
        Adds two arrows at x_pos pointing towards the upper and lower depth boundaries.
        The arrow tips will touch the y-coordinates corresponding to the depths.
        """

        def depth_to_y(target_depth: float) -> float | None:
            """Helper to find y-coordinate for a specific depth value."""
            if "depth" not in mesh.point_data:
                return None
            mask = np.isclose(mesh.point_data["depth"], target_depth, atol=tolerance_m)
            pts = mesh.points[mask]
            return float(np.mean(pts[:, 1])) if pts.shape[0] > 0 else None

        y_lower = depth_to_y(lower_depth)
        y_upper = depth_to_y(upper_depth)

        if y_lower is None or y_upper is None:
            print(f" !! Warning: Could not find depth boundaries at x={x_pos/1e3:.1f}km")
            return

        tip_point_lower = np.array([x_pos, y_upper, 0.0])
        tip_point_upper = np.array([x_pos, y_lower, 0.0])

        dir_upper = np.array([0, -1, 0])
        dir_lower = np.array([0, 1, 0])

        start_upper = tip_point_upper - (dir_upper * arrow_length)
        start_lower = tip_point_lower - (dir_lower * arrow_length)

        arrow_params = {
            "tip_length": tip_length,
            "tip_radius": tip_radius,
            "shaft_radius": shaft_radius,
            "scale": arrow_length,
            "tip_resolution": int(getattr(self.config, "v_arrow_tip_resolution", 20)),
            "shaft_resolution": int(getattr(self.config, "v_arrow_shaft_resolution", 20)),
        }

        arrow_up_indicator = pv.Arrow(start=start_upper, direction=dir_upper, **arrow_params)
        arrow_down_indicator = pv.Arrow(start=start_lower, direction=dir_lower, **arrow_params)

        plotter.add_mesh(arrow_up_indicator, color=color, opacity=alpha)
        plotter.add_mesh(arrow_down_indicator, color=color, opacity=alpha)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _configure_cmap(
        self, mesh: pv.UnstructuredGrid, field: str
    ) -> tuple[np.ndarray, mcolors.Colormap | mcolors.ListedColormap, tuple[float, float]]:
        """
        Compute display scalars, colormap, and color limits for a field.

        Applies log or signed-log transforms where appropriate, determines color limits from config or auto-ranging, and builds the final colormap
        with any center or end-color modifications.

        Does not mutate the mesh---returns the transformed scalars directly.

        Args:
            mesh:  Source mesh containing the field in point_data.
            field: Field name to configure.

        Returns:
            Tuple of (viz_scalars, colormap, (clim_min, clim_max)). viz_scalars is a numpy array ready to pass directly to add_mesh.
        """
        cfg = self.config
        cmap_name = cfg.cmap_map.get(field, "viridis")
        scalars = mesh.point_data[field] * cfg.scaling_map.get(field, 1.0)

        if field in self._LOG_FIELDS:
            scalars = np.log10(np.abs(np.maximum(scalars, 1e-30)))
        elif field in self._SIGNED_LOG_FIELDS:
            scalars = np.sign(scalars) * np.log10(1.0 + np.abs(scalars))

        clim_config = cfg.clim_map.get(field, None)
        if clim_config in (None, "auto"):
            finite = scalars[np.isfinite(scalars)]
            if finite.size > 0:
                lo, hi = float(np.min(finite)), float(np.max(finite))
                if lo == hi:
                    clim = (lo, hi)
                elif self._is_diverging_cmap(cmap_name):
                    abs_max = max(abs(lo), abs(hi))
                    clim = (-abs_max, abs_max)
                else:
                    clim = (lo, hi)
            else:
                clim = (0.0, 1.0)
            if self.verbosity >= 1:
                print(f" !! Warning: using auto CLIM for '{field}': {clim}")
        elif isinstance(clim_config, (tuple, list)) and len(clim_config) == 2:
            clim = (float(clim_config[0]), float(clim_config[1]))
        else:
            clim = (0.0, 1.0)

        if self._is_diverging_cmap(cmap_name):
            central_color = "#FFFFFF" if cmap_name in {"RdGy", "RdGy_r", "PRGn", "PRGn_r"} else "#E5E5E5"
            final_cmap = self._modify_diverging_cmap(cmap_name, central_color, cfg.n_colors)
        elif self._is_sequential_cmap(cmap_name) and field in self._MODIFIED_SEQ_FIELDS:
            final_cmap = self._modify_sequential_cmap(cmap_name, "#E5E5E5", cfg.n_colors)
        else:
            final_cmap = plt.get_cmap(cmap_name, cfg.n_colors)

        return scalars, final_cmap, clim

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _is_diverging_cmap(self, cmap_name: str) -> bool:
        """Return True if cmap_name is a recognised diverging colormap."""
        return cmap_name in self._DIVERGING_CMAPS

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _is_sequential_cmap(self, cmap_name: str) -> bool:
        """Return True if cmap_name is a recognised sequential colormap."""
        return cmap_name in self._SEQUENTIAL_CMAPS

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _modify_diverging_cmap(self, cmap_name: str, central_color_hex: str, n_colors: int = 11) -> mcolors.Colormap | mcolors.ListedColormap:
        """
        Return a diverging colormap with its central color replaced.

        Args:
            cmap_name:         Base colormap name.
            central_color_hex: Hex color to insert at the midpoint.
            n_colors:          Number of discrete color levels.

        Returns:
            Modified ListedColormap, or the unmodified colormap if the name is not recognised as diverging.
        """
        if not self._is_diverging_cmap(cmap_name):
            if self.verbosity >= 1:
                print(f" !! Warning: '{cmap_name}' is not a recognised diverging colormap.")
            return plt.get_cmap(cmap_name, n_colors)

        colors = plt.get_cmap(cmap_name)(np.linspace(0, 1, n_colors))
        colors[n_colors // 2] = mcolors.to_rgba(central_color_hex)
        return mcolors.ListedColormap(colors)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _modify_sequential_cmap(self, cmap_name: str, end_color_hex: str, n_colors: int = 11) -> mcolors.Colormap | mcolors.ListedColormap:
        """
        Return a sequential colormap with one end color replaced.

        For most sequential colormaps the last (high) color is replaced. Colormaps in _SEQ_REPLACE_FIRST have their first (low) color replaced
        instead, preserving the visually meaningful end of the ramp.

        Args:
            cmap_name:     Base colormap name.
            end_color_hex: Hex color to insert at the replaced end.
            n_colors:      Number of discrete color levels.

        Returns:
            Modified ListedColormap, or the unmodified colormap if the name is not recognised as sequential.
        """
        if not self._is_sequential_cmap(cmap_name):
            if self.verbosity >= 1:
                print(f" !! Warning: '{cmap_name}' is not a recognised sequential colormap.")
            return plt.get_cmap(cmap_name, n_colors)

        colors = plt.get_cmap(cmap_name)(np.linspace(0, 1, n_colors))
        idx = 0 if cmap_name in self._SEQ_REPLACE_FIRST else -1
        colors[idx] = mcolors.to_rgba(end_color_hex)
        return mcolors.ListedColormap(colors)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _compute_camera_settings(self, mesh: pv.UnstructuredGrid) -> list[tuple[float, ...]]:
        """
        Return PyVista camera position, focal point, and up-vector for the mesh.

        Centers the camera on the mesh bounding box and applies the zoom and vertical shift factors from MeshConfig.

        Args:
            mesh: Mesh whose bounds define the camera framing.

        Returns:
            List of three (x, y, z) tuples: [position, focal_point, up_vector].
        """
        bounds = mesh.bounds
        cx = (bounds[0] + bounds[1]) / 2
        cy = (bounds[2] + bounds[3]) / 2
        cz = (bounds[4] + bounds[5]) / 2

        max_span = max(bounds[1] - bounds[0], bounds[3] - bounds[2], 1e-6)
        y_shift = max_span * self.config.camera_y_shift_factor
        cam_dist = max(max_span * self.config.camera_zoom_factor, 1e3)

        return [
            (cx, cy, cam_dist),
            (cx, cy + y_shift, cz),
            (0.0, 1.0, 0.0),
        ]

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _add_scale_bar(self, mesh: pv.UnstructuredGrid, pl: pv.Plotter) -> None:
        """
        Draw a scale bar in the lower-left region of the plot.

        Bar length and position are determined by MeshConfig scale_bar_* fields.

        Args:
            mesh: Mesh whose bounding box defines the coordinate space.
            pl:   Active PyVista plotter to add the bar to.
        """
        cfg = self.config
        bounds = mesh.bounds
        x_range = bounds[1] - bounds[0]
        y_range = bounds[3] - bounds[2]

        bar_length = x_range * cfg.scale_bar_length_fraction
        bar_km = bar_length / 1e3

        x0 = bounds[0] + x_range * cfg.scale_bar_position[0]
        y0 = bounds[2] + y_range * cfg.scale_bar_position[1]

        line = pv.Line([x0, y0, 0.0], [x0 + bar_length, y0, 0.0])
        pl.add_mesh(line, color=cfg.scale_bar_color, line_width=cfg.scale_bar_thickness)

        label_pos = [x0 + cfg.scale_bar_label_shift_factor * x_range, y0 + 0.01 * x_range, 0.0]
        pl.add_point_labels(
            [label_pos],
            [f"{bar_km:.0f} km"],
            font_size=cfg.scale_bar_label_font_size,
            point_color=cfg.scale_bar_color,
            text_color=cfg.scale_bar_color,
            point_size=0,
            shape=None,
        )
