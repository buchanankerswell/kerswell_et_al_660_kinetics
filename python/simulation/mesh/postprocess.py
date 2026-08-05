#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
from dataclasses import dataclass

import numpy as np
import pyvista as pv
from config import MeshConfig


#######################################################
## .1. MeshPostProcessor                         !!! ##
#######################################################
@dataclass
class MeshPostProcessor:
    """
    Measures phase transition structure from geodynamic simulation meshes.

    Provides methods to locate the best-representative vertical profile for a phase transition, extract depth profiles, and compute scalar maxima
    within the transition window.
    """

    config: MeshConfig
    verbosity: int = 0

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def measure_discontinuity_structure(
        self,
        mesh: pv.UnstructuredGrid,
        field: str,
        rxn_depth: float,
        x_offset: float = 750e3,
        width_threshold: float = 15e3,
    ) -> dict[str, float]:
        """
        Find the best-representative vertical profile and measure the phase transition displacement and width from the X=0.1 to X=0.9 interval.

        Args:
            mesh:      Source mesh with 'depth' and field point data.
            field:     Phase fraction field name (values expected in [0, 1]).
            rxn_depth: Nominal reaction depth for this transition (m).
            threshold: Width threshold (m) above which width-based selection is preferred when not in a displacement regime.

        Returns:
            Dict with keys 'x_position', 'displacement', and 'width' (all in m). All values are nan if no valid profile is found.
        """
        x_coords = mesh.points[:, 0]
        x_center = 0.5 * (x_coords.min() + x_coords.max())
        x_start = max(x_center - x_offset, x_coords.min())
        x_end = min(x_center + x_offset, x_coords.max())

        x_positions = np.unique(x_coords)
        x_positions = x_positions[(x_positions >= x_start) & (x_positions <= x_end)]

        valid = []
        for x in x_positions:
            mask = x_coords == x
            depths = mesh.point_data["depth"][mask]
            values = mesh.point_data[field][mask]
            sort_idx = np.argsort(depths)

            trans_depth, displacement, width = self._evaluate_transition_structure(depths[sort_idx], values[sort_idx], rxn_depth)
            if not (np.isnan(trans_depth) or np.isnan(displacement) or np.isnan(width)):
                valid.append((x, trans_depth, displacement, width))

        if not valid:
            return {"x_position": np.nan, "displacement": np.nan, "width": np.nan}

        x_vals, trans_depths, displacements, widths = np.array(valid).T

        # Determine most representative depth profile
        if np.any(widths > width_threshold):
            best_idx = np.nanargmax(widths)
        else:
            median_trans_depth = np.nanmedian(trans_depths)
            deviations = np.abs(trans_depths - median_trans_depth)
            best_idx = np.nanargmax(deviations)

        return {"x_position": x_vals[best_idx], "displacement": displacements[best_idx], "width": widths[best_idx]}

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def extract_depth_profile(self, mesh: pv.UnstructuredGrid, field: str, x_pos: float, tolerance=500.0) -> tuple[np.ndarray, np.ndarray]:
        """
        Return (depths, values) along a vertical profile at x_pos, sorted by depth.

        Args:
            mesh:          Source mesh with 'depth' point data.
            field:         Field name to extract values for.
            x_pos:         x-coordinate of the vertical profile (m).
            tolerance:     x_pos tolerance for extracting depth profile (m).

        Returns:
            Tuple of (depths, values) arrays sorted by depth, or two empty arrays if no points are found at x_pos.
        """
        mask = np.isclose(mesh.points[:, 0], x_pos, atol=tolerance)
        if not np.any(mask):
            return np.empty(0), np.empty(0)

        depths = mesh.point_data["depth"][mask]
        values = mesh.point_data[field][mask] * self.config.scaling_map.get(field, 1.0)

        sort_idx = np.argsort(depths)
        return depths[sort_idx], values[sort_idx]

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def calculate_max_in_region(
        self, depths: np.ndarray, values: np.ndarray, rxn_depth: float, displacement: float, width: float, width_threshold: float = 15e3
    ) -> float:
        """
        Return the maximum absolute value within the depth window around the transition.

        Args:
            depths:        Depth array (m), sorted ascending.
            values:        Field value array aligned with depths.
            rxn_depth:     Nominal reaction depth (m).
            displacement:  Measured transition displacement from rxn_depth (m).
            width:         Measured transition width (m).

        Returns:
            Maximum absolute value within the window, or nan if the window contains no points or inputs are empty.
        """
        if depths.size == 0 or values.size == 0:
            return np.nan

        lower_factor, upper_factor = self._bound_factors(width, width_threshold)
        lower = max(np.nanmin(depths), rxn_depth + displacement - width * lower_factor)
        upper = min(np.nanmax(depths), rxn_depth + displacement + width * upper_factor)

        mask = (depths >= lower) & (depths <= upper)

        if not np.any(mask):
            center = rxn_depth + displacement
            nearest_idx = np.argmin(np.abs(depths - center))
            return float(np.abs(values[nearest_idx]))

        return float(np.nanmax(np.abs(values[mask]))) if np.any(mask) else np.nan

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def transition_depth_bounds(self, rxn_depth: float, displacement: float, width: float, width_threshold: float = 15e3, for_visualizing: bool = False) -> tuple[float, float]:
        """
        Return (lower, upper) mesh-relative depth bounds for the transition window.

        Uses the same _bound_factors as calculate_max_in_region so that annotation brackets in plots are geometrically identical to the max-value
        integration window.

        Args:
            rxn_depth:    Nominal reaction depth (m).
            displacement: Measured transition displacement from rxn_depth (m).
            width:        Measured transition width (m).

        Returns:
            (lower, upper) depths in mesh-relative coordinates (m).
        """
        if not for_visualizing:
            lower_factor, upper_factor = self._bound_factors(width, width_threshold)
            lower = rxn_depth + displacement - width * lower_factor
            upper = rxn_depth + displacement + width * upper_factor
        else:
            lower = rxn_depth + displacement - width
            upper = rxn_depth + displacement

        return lower, upper

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _bound_factors(self, width: float, width_threshold: float = 15e3) -> tuple[float, float]:
        """
        Return (lower_factor, upper_factor) for the transition depth window.

        Narrow transitions (width <= 5 km) use a wider lower margin to capture the full phase change. Broad transitions use a tighter window.
        """
        return (2.5, 1.5) if width <= width_threshold else (2.0, 1.0)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_transition_structure(
        self,
        depths: np.ndarray,
        values: np.ndarray,
        rxn_depth: float,
        search_window: float = 100e3,
    ) -> tuple[float, float, float]:
        """
        Measure the displacement and width of a phase transition from a depth profile.

        Before crossing detection, the profile is repaired for monotonicity using isotonic regression (PAVA). Profiles where the total downward
        variation exceeds the tolerance in _repair_monotonic are considered too corrupt to interpret and return (nan, nan, nan).

        Crossings at X=0.1 and X=0.9 are located by linear interpolation, with each crossing anchored to rxn_depth: when multiple crossings exist,
        the one whose midpoint depth is closest to rxn_depth is selected. This prevents noise crossings far from the known transition depth from
        being mistaken for the real transition boundary.

        When both crossings are found, the result is validated before use:
            - depth_90 must be greater than depth_10 (crossings must be in the correct order).
            - the midpoint of the transition must lie within max_displacement_limit of rxn_depth.

        Transition structure is then computed as:
            displacement = depth(X=0.9) - rxn_depth
            width        = depth(X=0.9) - depth(X=0.1)

        If only one crossing is found, width falls back to the local vertical grid spacing at that crossing and trans_depth is set to the single
        valid crossing depth.

        Args:
            depths:        Depth array (m), sorted ascending.
            values:        Phase fraction array aligned with depths, expected to be broadly 0 -> 1.
            rxn_depth:     Nominal reaction depth (m), used both to anchor crossing selection and to compute displacement.
            search_window: Half-width (m) of the depth window around rxn_depth within which monotonicity is enforced. Default 80 km.

        Returns:
            (trans_depth, displacement, width) in metres, or (nan, nan, nan) if the profile is too corrupt, no valid crossings are found,
            or the inferred transition location fails the proximity check.
        """

        if len(depths) < 2:
            return np.nan, np.nan, np.nan

        dz_all = np.diff(depths)
        if dz_all.size == 0:
            return np.nan, np.nan, np.nan
        dz_min = float(np.nanmin(dz_all))

        # Monotonicity repair via isotonic regression (PAVA)
        repaired_values = self._repair_monotonic(values, depths, rxn_depth, search_window)
        if repaired_values is None:
            # Profile was too corrupt to repair meaningfully
            return np.nan, np.nan, np.nan

        # Pre-compute the trusted index range once
        search_lo = int(np.searchsorted(depths, rxn_depth - search_window))
        search_hi = int(np.searchsorted(depths, rxn_depth + search_window, side="right"))
        search_depths = depths[search_lo:search_hi]
        search_repaired = repaired_values[search_lo:search_hi]

        # Crossing detection
        def find_crossing(target: float) -> int:
            """Return global index of the crossing closest to rxn_depth, within the trusted window."""
            if search_depths.size < 2:
                return -1
            signs = np.sign(search_repaired - target)
            signs[signs == 0] = 1
            local_crossings = np.where(np.diff(signs) != 0)[0]
            if not local_crossings.size:
                return -1
            crossing_depths = 0.5 * (search_depths[local_crossings] + search_depths[local_crossings + 1])
            best_local = int(local_crossings[np.argmin(np.abs(crossing_depths - rxn_depth))])
            return search_lo + best_local  # convert back to global index

        def interp_depth(target: float, idx: int) -> float:
            if idx < 0 or idx >= len(repaired_values) - 1:
                return np.nan
            x0, x1 = repaired_values[idx], repaired_values[idx + 1]
            z0, z1 = depths[idx], depths[idx + 1]
            if x1 == x0:
                return float((z0 + z1) / 2.0)
            return float(z0 + (target - x0) / (x1 - x0) * (z1 - z0))

        idx_10 = find_crossing(0.1)
        idx_90 = find_crossing(0.9)

        depth_10 = interp_depth(0.1, idx_10) if idx_10 != -1 else np.nan
        depth_90 = interp_depth(0.9, idx_90) if idx_90 != -1 else np.nan

        # Validate that both crossings belong to the same transition
        if not np.isnan(depth_10) and not np.isnan(depth_90):
            if depth_90 <= depth_10:
                return np.nan, np.nan, np.nan
            midpoint = 0.5 * (depth_10 + depth_90)
            if abs(midpoint - rxn_depth) > search_window:
                return np.nan, np.nan, np.nan
            width = abs(depth_90 - depth_10)
            trans_depth = depth_90
        else:
            # Fallback: only one crossing found
            valid_idx = idx_10 if not np.isnan(depth_10) else idx_90
            valid_depth = depth_10 if not np.isnan(depth_10) else depth_90

            if valid_idx == -1:
                return np.nan, np.nan, np.nan

            dz_local = depths[valid_idx + 1] - depths[valid_idx] if valid_idx < len(depths) - 1 else dz_min
            width = float(abs(dz_local)) if dz_local > 0 else dz_min
            trans_depth = valid_depth

        displacement = trans_depth - rxn_depth
        return trans_depth, displacement, width

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _repair_monotonic(self, values: np.ndarray, depths: np.ndarray, rxn_depth: float, search_window: float = 100e3) -> np.ndarray:
        """
        Repair monotonicity violations in a phase fraction profile near a known reaction depth.

        Only the subset of points within search_window of rxn_depth is inspected and repaired using the Pool Adjacent Violators Algorithm (PAVA).
        Non-monotonic artefacts outside this window are ignored entirely, preventing unrelated mesh noise elsewhere in the depth column from
        triggering rejection or corrupting the repair.

        Within the window, PAVA pools adjacent violating points into blocks and replaces each block with its mean.

        Args:
            values:        Phase fraction array (expected to be broadly 0 -> 1).
            depths:        Depth array (m), sorted ascending, aligned with values.
            rxn_depth:     Nominal reaction depth (m) used to centre the search window.
            search_window: Half-width (m) of the depth window around rxn_depth within which monotonicity is enforced. Default 80 km.

        Returns:
            Array with monotonicity enforced within the search window.
        """
        repaired = values.astype(float).copy()

        window_mask = np.where((depths >= rxn_depth - search_window) & (depths <= rxn_depth + search_window))[0]
        if window_mask.size == 0:
            return repaired

        lo, hi = int(window_mask[0]), int(window_mask[-1])
        n_local = hi - lo + 1

        # Both lists use local indices (0..n_local-1) throughout
        block_start = list(range(n_local))
        block_end = list(range(n_local))

        def full(local: int) -> int:
            return lo + local

        i = 0
        while i < n_local - 1:
            if repaired[full(i)] > repaired[full(i + 1)]:
                start = block_start[i]  # local index
                end = block_end[i + 1]  # local index

                block_mean = float(np.mean(repaired[full(start) : full(end) + 1]))
                repaired[full(start) : full(end) + 1] = block_mean

                for k in range(start, end + 1):  # all local
                    block_start[k] = start
                    block_end[k] = end

                i = max(0, start - 1)
            else:
                i += 1

        return repaired
