#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import gc
import pickle
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Generator

import numpy as np
import pandas as pd
import pyvista as pv
from config import MeshConfig
from plotter import MeshPlotter
from postprocess import MeshPostProcessor
from preprocess import MeshPreProcessor
from simulation.params.transitions import PhaseTransition
from tqdm import tqdm


#######################################################
## .1. BasePipeline                              !!! ##
#######################################################
@dataclass
class BasePipeline:
    """
    Shared infrastructure for all pipeline variants.

    Provides file discovery, mesh loading, timestep filtering, and the phase-transition metadata tables used by both post-processing and plotting.
    """

    config: MeshConfig
    pvtu_in_dirs: dict[str, Path]
    tsteps: list[int]
    trans_data: dict[str, PhaseTransition]
    verbosity: int = 0

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def __post_init__(self) -> None:
        self.preprocessor = MeshPreProcessor(self.verbosity)
        self._pvtu_file_cache: dict | None = None
        self.trans_info: dict = {
            "X_wd": (
                "reaction_rate_C0",
                "profile_x_410",
                "displacement_410",
                "width_410",
                self.trans_data["X_wd"].y,
                self.trans_data["X_wd"].depth,
            ),
            "X_ps": (
                "reaction_rate_C2",
                "profile_x_660",
                "displacement_660",
                "width_660",
                self.trans_data["X_ps"].y,
                self.trans_data["X_ps"].depth,
            ),
        }

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _iter_valid_timesteps(self, pvtu_files: list[Path], timesteps: list[int]) -> Generator[tuple[Path, int], None, None]:
        """
        Yield (path, timestep) pairs that are in the requested timestep list.

        Skips sentinel value -1, which marks files whose timestep could not be parsed from the filename.
        """
        for pvtu_path, tstep in zip(pvtu_files, timesteps):
            if tstep != -1 and tstep in self.tsteps:
                yield pvtu_path, tstep

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _load_mesh(self, pvtu_path: Path) -> pv.UnstructuredGrid | None:
        """Load a .pvtu file and return the mesh, or None on failure."""
        try:
            return pv.UnstructuredGrid(pvtu_path)
        except Exception as e:
            if self.verbosity >= 1:
                print(f" !! Warning: Error loading {pvtu_path.name}:\n    {e}")
            return None

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_ordered_pvtu_files(self) -> dict[str, tuple[list[Path], list[int]]]:
        """Return the ordered file/timestep dict, building and caching it on first call."""
        if self._pvtu_file_cache is None:
            self._pvtu_file_cache = self._build_ordered_pvtu_files()
        return self._pvtu_file_cache

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _build_ordered_pvtu_files(self) -> dict[str, tuple[list[Path], list[int]]]:
        """
        Glob each model's solution directory, parse timesteps, and return a dict of model_id -> (sorted_files, sorted_timesteps), ordered by model_id.
        """
        model_entries: list[tuple[str, tuple[list[Path], list[int]]]] = []

        for model_id, directory in self.pvtu_in_dirs.items():
            solution_dir = directory / "solution"
            if not solution_dir.is_dir():
                if self.verbosity >= 1:
                    print(f" !! Warning: solution directory not found for model: {model_id}")
                model_entries.append((model_id, ([], [])))
                continue

            try:
                files = list(solution_dir.glob("*.pvtu"))
                if not files:
                    if self.verbosity >= 1:
                        print(f" !! Warning: no .pvtu files found for model: {model_id}")
                    model_entries.append((model_id, ([], [])))
                    continue
            except Exception as e:
                if self.verbosity >= 1:
                    print(f" !! Warning: error processing directory {solution_dir}:\n    {e}")
                model_entries.append((model_id, ([], [])))
                continue

            parsed = []
            for file in files:
                match = re.search(r"solution-(\d+)\.pvtu", file.name)
                if match:
                    timestep = int(match.group(1))
                else:
                    timestep = -1
                    if self.verbosity >= 1:
                        print(f" !! Warning: could not parse timestep from filename:\n    {file.name}")
                parsed.append((timestep, file))

            parsed.sort(key=lambda x: x[0])
            sorted_timesteps = [t for t, _ in parsed]
            sorted_files = [f for _, f in parsed]
            model_entries.append((model_id, (sorted_files, sorted_timesteps)))

        model_entries.sort(key=lambda x: self._extract_sort_key(x[0]))
        return dict(model_entries)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_prams_from_model_uid(self, model_id_str: str) -> tuple[float, float, float, float, float, float, float, float, float, float]:
        """
        Parse z_ol_wd, z_wd_ri, z_ri_ps, eta_therm, prescribed_velocity, and prescribed_temperature_anomaly from a model ID string.

        Searches the string for tokens of the form:
            Zol<val>, Zwd<val>, Zri<val>, EtaTherm<val>, Vel<val>, Temp<Val>
        where <val> may be in standard or scientific notation (e.g., 1.4e+04).

        The order of parameters and presence of additional fields are ignored.
        Returns (nan, nan, nan, nan, nan, nan) and warns if any parameter cannot be found or parsed.
        """

        def extract_float(pattern: str) -> float:
            match = re.search(pattern, model_id_str)
            return float(match.group(1)) if match else np.nan

        def extract_str(pattern: str) -> str | None:
            match = re.search(pattern, model_id_str)
            return match.group(1) if match else None

        try:
            z_ol_wd = extract_float(r"Zol([0-9.+\-eE]+)")
            z_wd_ri = extract_float(r"Zwd([0-9.+\-eE]+)")
            z_ri_ps = extract_float(r"Zri([0-9.+\-eE]+)")
            eta_therm = extract_float(r"EtaTherm([0-9.+\-eE]+)")
            prescribed_velocity = extract_float(r"Vel([0-9.+\-eE]+)")
            prescribed_temperature_anomaly = extract_float(r"Temp([0-9.+\-eE]+)")
            eta_phases_raw = extract_str(r"EtaTrans([0-9.+\-eE]+(?:-[0-9.+\-eE]+)*)")
            eta_phases_values = [float(x) for x in eta_phases_raw.split("-")] if eta_phases_raw else [np.nan] * 4
            eta_trans_ol_wd = eta_phases_values[1] / eta_phases_values[0]
            eta_trans_wd_ri = eta_phases_values[2] / eta_phases_values[1]
            eta_trans_ri_ps = eta_phases_values[3] / eta_phases_values[2]
            mg_num = extract_float(r"MG([0-9.+\-eE]+)")

            if any(
                np.isnan(
                    [
                        z_ol_wd,
                        z_wd_ri,
                        z_ri_ps,
                        eta_therm,
                        eta_trans_ol_wd,
                        eta_trans_wd_ri,
                        eta_trans_ri_ps,
                        prescribed_velocity,
                        prescribed_temperature_anomaly,
                        mg_num,
                    ]
                )
            ):
                raise ValueError("Missing one or more parameters")

            return (
                z_ol_wd,
                z_wd_ri,
                z_ri_ps,
                eta_therm,
                eta_trans_ol_wd,
                eta_trans_wd_ri,
                eta_trans_ri_ps,
                prescribed_velocity,
                prescribed_temperature_anomaly,
                mg_num,
            )

        except Exception as e:
            if self.verbosity >= 1:
                print(f" !! Warning: could not extract parameters from model_id '{model_id_str}':\n    {e}")
            return np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _extract_sort_key(self, model_id: str) -> tuple:
        """Return a (prefix, number) sort key so model IDs sort numerically by trailing integer."""
        match = re.match(r"(.*?)(\d+)$", model_id)
        if match:
            prefix, number = match.groups()
            return (prefix, int(number))
        return (model_id, float("inf"))


#######################################################
## .2. PostProcessing Pipeline                   !!! ##
#######################################################
@dataclass
class PostProcessingPipeline(BasePipeline):
    """
    Iterates over all models and timesteps, measures phase transition structure, and caches per-model seismic profiles and transition summaries for
    downstream use.
    """

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def __post_init__(self) -> None:
        super().__post_init__()
        self.postprocessor = MeshPostProcessor(self.config, self.verbosity)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def run(
        self, transition_summary_cache_path: Path | None = None, seismic_profile_cache_path: Path | None = None, force_reprocess: bool = False
    ) -> tuple[dict, dict]:
        """
        Run post-processing over all models and timesteps.

        For each mesh, derives computed fields, measures phase transition structure at each discontinuity defined in trans_info, and
        extracts seismic profiles for all configured fields at the best-representative x-position.

        Args:
            transition_summary_cache_path: If provided, pickle the structure summary cache to this path.
            seismic_profile_cache_path:    If provided, pickle the full depth profile cache to this path.
            force_reprocess:               Overwrite existing cache if it exists.

        Returns:
            transition_summary_cache dict: cache[model_id][tstep] -> entry dict with structure measurements, depth profiles, and scalar maxima.
            seismic_profile_cache dict:    cache[model_id][tstep] -> full depth profiles for all fields.
        """
        transition_summary_cache = {}
        seismic_profile_cache = {}

        can_skip = False
        if not force_reprocess:
            summary_exists = transition_summary_cache_path and transition_summary_cache_path.exists()
            profile_exists = seismic_profile_cache_path and seismic_profile_cache_path.exists()

            if summary_exists and profile_exists:
                can_skip = True

        if can_skip:
            assert transition_summary_cache_path is not None
            assert seismic_profile_cache_path is not None

            try:
                print(f" .. Loading {transition_summary_cache_path}")
                with open(transition_summary_cache_path, "rb") as f:
                    transition_summary_cache = pickle.load(f)

                print(f" .. Loading {seismic_profile_cache_path}")
                with open(seismic_profile_cache_path, "rb") as f:
                    seismic_profile_cache = pickle.load(f)

                if transition_summary_cache and seismic_profile_cache:
                    return transition_summary_cache, seismic_profile_cache
                else:
                    print(" !! Warning: one or more caches were empty. Reprocessing ...")
            except Exception as e:
                print(f" !! Error: Could not load cache:\n    {e}")

        eta_therm_vals = set()
        velocity_vals = set()
        eta_trans_vals = set()

        for model_id, _ in self._get_ordered_pvtu_files().items():
            if "LH" in model_id:
                continue

            _, _, _, eta_therm, _, _, eta_trans_ri_ps, velocity, _, _ = self._get_prams_from_model_uid(model_id)

            if not np.isnan(eta_therm):
                eta_therm_vals.add(eta_therm)
            if not np.isnan(velocity):
                velocity_vals.add(velocity)
            if not np.isnan(eta_trans_ri_ps):
                eta_trans_vals.add(eta_trans_ri_ps)

        velocity_vals = sorted(velocity_vals)
        eta_therm_vals = sorted(eta_therm_vals)
        eta_trans_vals = sorted(eta_trans_vals, reverse=True)

        velocity_idx = {v: j for j, v in enumerate(velocity_vals)}
        eta_therm_idx = {v: i for i, v in enumerate(eta_therm_vals)}
        eta_trans_idx = {v: k for k, v in enumerate(eta_trans_vals)}

        transition_summary_cache = {}
        seismic_profile_cache = {}

        model_items = self._get_ordered_pvtu_files().items()
        pbar = tqdm(
            model_items,
            desc="Processing meshes",
            unit="model",
            ncols=80,
            bar_format="{l_bar}{bar}| {n_fmt}/{total_fmt} [{elapsed}<{remaining}, {rate_fmt}{postfix}]",
        )
        for model_id, (pvtu_files, timesteps) in pbar:
            if "LH" in model_id:
                continue

            if not pvtu_files:
                if self.verbosity >= 1:
                    print(f" !! Warning: no result files for model: {model_id}")
                continue

            z_ol_wd, z_wd_ri, z_ri_ps, eta_therm, eta_trans_ol_wd, eta_trans_wd_ri, eta_trans_ri_ps, velocity, temperature, mg_num = (
                self._get_prams_from_model_uid(model_id)
            )

            try:
                i = velocity_idx[velocity]
                j = eta_therm_idx[eta_therm]
                k = eta_trans_idx[eta_trans_ri_ps]
            except Exception as e:
                if self.verbosity >= 1:
                    print(f" !! Warning: could not compute scenario for {model_id}:\n    {e}")
                continue

            scenario = k * (len(velocity_vals) * len(eta_therm_vals)) + i * len(eta_therm_vals) + j

            transition_summary_cache[model_id] = {}
            seismic_profile_cache[model_id] = {}

            for pvtu_path, tstep in self._iter_valid_timesteps(pvtu_files, timesteps):
                mesh = self._load_mesh(pvtu_path)
                if mesh is None:
                    continue

                for field_name in self.config.file_map:
                    self.preprocessor.prepare_mesh(mesh, field_name)

                entry = {
                    "time": self.preprocessor.get_mesh_time_myr(mesh, model_id, tstep),
                    "z_ol_wd": z_ol_wd,
                    "z_wd_ri": z_wd_ri,
                    "z_ri_ps": z_ri_ps,
                    "eta_therm": eta_therm,
                    "eta_trans_ol_wd": eta_trans_ol_wd,
                    "eta_trans_wd_ri": eta_trans_wd_ri,
                    "eta_trans_ri_ps": eta_trans_ri_ps,
                    "prescribed_velocity": velocity,
                    "prescribed_temperature_anomaly": temperature,
                    "mg_num": mg_num,
                    "scenario": scenario,
                }

                depth_data = mesh.point_data["depth"]
                d_min, d_max = np.min(depth_data), np.max(depth_data)
                requested_depths = np.linspace(d_min, d_max, num=500)
                y_max = mesh.bounds[3]
                y_slicing_grid = y_max - requested_depths
                reverse_direction = True if "plume" in model_id else False
                x_jump_threshold = 100e3 if "plume" in model_id else 150e3

                representative_trace = self._extract_representative_trace(
                    mesh, y_slicing_grid, requested_depths, x_jump_threshold=x_jump_threshold, reverse_direction=reverse_direction
                )

                trace_depths = representative_trace["trace_x"]["depths"]
                trace_x_vals = representative_trace["trace_x"]["values"]
                entry["trace"] = {"depths": trace_depths.copy(), "x_positions": trace_x_vals.copy(), "y_max": y_max}

                summary_entry = entry.copy()
                for phase_field, (rate_field, x_key, disp_key, width_key, _, rxn_depth) in self.trans_info.items():
                    suffix = x_key.split("_")[-1]
                    self._process_transition(
                        representative_trace,
                        summary_entry,
                        phase_field,
                        x_key,
                        disp_key,
                        width_key,
                        suffix,
                        rxn_depth,
                        rate_field,
                    )

                transition_summary_cache[model_id][tstep] = summary_entry
                seismic_profile_cache[model_id][tstep] = {"representative": representative_trace}

                del mesh
                gc.collect()

        if transition_summary_cache_path:
            self._save_cache(transition_summary_cache, transition_summary_cache_path)
        if seismic_profile_cache_path:
            self._save_cache(seismic_profile_cache, seismic_profile_cache_path)

        return transition_summary_cache, seismic_profile_cache

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def export_transition_summary(
        self,
        csv_path: Path,
        transition_summary_cache: dict | None = None,
        transition_summary_cache_path: Path | None = None,
        seismic_profile_cache_path: Path | None = None,
        force_reprocess: bool = False,
    ) -> pd.DataFrame:
        """
        Export a flattened summary of the cache to a csv file.

        Runs post-processing if no cache is provided. Column format lists are derived from trans_info so they stay in sync if transitions
        are added or removed.

        Args:
            csv_path:        Destination path for the summary csv file.
            cache:           Pre-computed cache dict; runs self.run() if None.
            cache_path:      If provided, pickle the result cache to this path.
            force_reprocess: Overwrite existing cache if it exists.

        Returns:
            The exported DataFrame, or an empty DataFrame on failure.
        """
        if transition_summary_cache is None:
            transition_summary_cache, _ = self.run(transition_summary_cache_path, seismic_profile_cache_path, force_reprocess)

        float_cols = []
        scientific_cols = ["z_ol_wd", "z_wd_ri", "z_ri_ps", "prescribed_velocity"]
        integer_cols = [
            "time",
            "eta_therm",
            "eta_trans_ol_wd",
            "eta_trans_wd_ri",
            "eta_trans_ri_ps",
            "prescribed_temperature_anomaly",
            "mg_num",
            "scenario",
        ]

        for rate_field, x_key, disp_key, width_key, _, _ in self.trans_info.values():
            suffix = x_key.split("_")[-1]
            scientific_cols.append(f"max_{rate_field}_{suffix}")
            scientific_cols.append(f"max_velocity_vertical_{suffix}")
            float_cols.extend([x_key, disp_key, width_key])

        try:
            df = pd.DataFrame(self._cache_to_summary(transition_summary_cache)).drop_duplicates()

            for col in scientific_cols:
                if col in df.columns:
                    df[col] = df[col].apply(lambda x: f"{x:.3e}" if pd.notna(x) else x)
            for col in float_cols:
                if col in df.columns:
                    df[col] = df[col].apply(lambda x: f"{x:.3f}" if pd.notna(x) else x)
            for col in integer_cols:
                if col in df.columns:
                    df[col] = df[col].apply(lambda x: f"{x:.0f}" if pd.notna(x) else x)

            csv_path.parent.mkdir(parents=True, exist_ok=True)
            df.rename(columns=lambda x: re.sub(r"_C\d+", "", x)).to_csv(csv_path, index=False)
            print(f" -> {csv_path}")
            return df
        except Exception as e:
            print(f" !! Error: Failed to write csv:\n    {e}")
            return pd.DataFrame()

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def export_seismic_profiles(
        self, out_dir: Path, target_fields: list[str] = ["density", "seismic_Vp", "seismic_Vs"], seismic_profile_cache: dict | None = None
    ) -> None:
        if seismic_profile_cache is None:
            return

        export_fields = list(set(target_fields + ["trace_x"]))
        out_dir.mkdir(parents=True, exist_ok=True)

        for model_id, timesteps in seismic_profile_cache.items():
            for tstep, suffix_dict in timesteps.items():
                for suffix, fields_dict in suffix_dict.items():
                    csv_path = out_dir / f"seismic_profile_{model_id}_t{tstep}_{suffix}.csv"

                    if all(f in fields_dict for f in export_fields):
                        raw_z = fields_dict[target_fields[0]]["depths"]
                        if raw_z.size == 0:
                            continue

                        uniform_z = np.linspace(np.min(raw_z), np.max(raw_z), 1000)
                        export_data = {"depth": uniform_z}

                        for f in export_fields:
                            from scipy.interpolate import interp1d

                            clean_z = fields_dict[f]["depths"]
                            clean_v = fields_dict[f]["values"]

                            mask = ~np.isnan(clean_v)
                            if not np.any(mask):
                                export_data[f] = np.full(1000, np.nan)
                                continue

                            f_interp = interp1d(clean_z[mask], clean_v[mask], bounds_error=False, fill_value="extrapolate")  # type: ignore
                            export_data[f] = f_interp(uniform_z)

                        df = pd.DataFrame(export_data)
                        cols = ["depth", "trace_x"] + [f for f in target_fields if f != "trace_x"]
                        df[cols].to_csv(csv_path, index=False)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _process_transition(
        self,
        representative_trace: dict,
        entry: dict,
        phase_field: str,
        x_key: str,
        disp_key: str,
        width_key: str,
        suffix: str,
        rxn_depth: float,
        rate_field: str,
    ) -> None:
        """
        Measure one phase transition along the pre-computed representative trace and populate the entry dict in-place.

        All depth profiles and scalar maxima are derived from representative_trace, ensuring that the transition structure and the seismic
        profiles are extracted from the same trace rather than from separate per-column scans.

        x_position is set to the trace x-coordinate interpolated at the measured transition depth (rxn_depth + displacement).  When no
        valid crossing is found the transition keys are written as nan and the method returns early.

        Args:
            representative_trace: Output of _extract_representative_trace.
            entry:                  Summary dict to populate in-place.
            phase_field:            Phase fraction field (e.g. 'X_wd').
            x_key:                  Cache key for the x_position scalar.
            disp_key:               Cache key for the displacement scalar.
            width_key:              Cache key for the transition width scalar.
            suffix:                 Short tag used to namespace max-value keys ('410', '660').
            rxn_depth:              Nominal equilibrium reaction depth (m).
            rate_field:             Reaction-rate field whose maximum is also recorded.
        """
        if phase_field not in representative_trace:
            return

        phase_depths = representative_trace[phase_field]["depths"]
        phase_values = representative_trace[phase_field]["values"]

        structure = self._evaluate_transition_structure_from_trace(phase_depths, phase_values, rxn_depth)

        trace_depths = representative_trace["trace_x"]["depths"]
        trace_x_vals = representative_trace["trace_x"]["values"]

        displacement = structure["displacement"]
        if not np.isnan(displacement):
            trans_depth = rxn_depth + displacement
        else:
            trans_depth = rxn_depth

        valid_trace = ~np.isnan(trace_x_vals)
        if np.any(valid_trace):
            x_pos = float(np.interp(trans_depth, trace_depths[valid_trace], trace_x_vals[valid_trace]))
        else:
            x_pos = np.nan

        structure["x_position"] = x_pos
        entry.update({x_key: x_pos, disp_key: structure["displacement"], width_key: structure["width"]})

        if np.isnan(x_pos) or np.isnan(displacement):
            return

        fields_cache: dict = {}
        for field_name in self.config.file_map:
            if field_name not in representative_trace:
                continue

            depths = representative_trace[field_name]["depths"]
            values = representative_trace[field_name]["values"]
            fields_cache[field_name] = {"depths": depths, "values": values}

            if field_name in (rate_field, "velocity_vertical"):
                entry[f"max_{field_name}_{suffix}"] = self.postprocessor.calculate_max_in_region(
                    depths, values, rxn_depth, displacement, structure["width"]
                )

        entry[f"fields_{suffix}"] = fields_cache

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_transition_structure_from_trace(
        self,
        trace_depths: np.ndarray,
        trace_phase_values: np.ndarray,
        rxn_depth: float,
    ) -> dict[str, float]:
        """
        Measure phase transition displacement and width from a pre-sampled trace profile.

        Unlike measure_discontinuity_structure, which scans many vertical columns and picks the best one heuristically, this method accepts a single
        depth profile that was already sampled along the maximum-thermal-anomaly trace and applies _evaluate_transition_structure directly to it.

        Args:
            trace_depths:       Depth coordinates of the trace (m), not necessarily sorted.
            trace_phase_values: Phase fraction values sampled along the trace, aligned with trace_depths.  Expected to be broadly 0 → 1.
            rxn_depth:          Nominal equilibrium reaction depth (m).

        Returns:
            Dict with keys 'displacement' and 'width' (m).  Both are nan if the profile is too corrupt or no valid crossing is found.  'x_position'
            is set to nan; the caller is responsible for interpolating it from the trace_x array.
        """
        if trace_depths.size < 2 or trace_phase_values.size < 2:
            return {"x_position": np.nan, "displacement": np.nan, "width": np.nan}

        valid = ~(np.isnan(trace_depths) | np.isnan(trace_phase_values))
        if valid.sum() < 2:
            return {"x_position": np.nan, "displacement": np.nan, "width": np.nan}

        sort_idx = np.argsort(trace_depths[valid])
        sorted_depths = trace_depths[valid][sort_idx]
        sorted_values = trace_phase_values[valid][sort_idx]

        _, displacement, width = self.postprocessor._evaluate_transition_structure(sorted_depths, sorted_values, rxn_depth)

        return {"x_position": np.nan, "displacement": displacement, "width": width}

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _extract_representative_trace(
        self,
        mesh: pv.UnstructuredGrid,
        y_grid: np.ndarray,
        depth_grid: np.ndarray,
        target_field: str = "nonadiabatic_temperature",
        anomaly_threshold: float = 250,
        x_buffer: float = 50e3,
        x_jump_threshold: float = 100e3,
        reverse_direction: bool = False,
    ) -> dict:
        """
        Extracts trace with thermal threshold and jump-suppression.
        reverse_direction=False: Processes top-to-bottom (standard y_grid order).
        reverse_direction=True: Processes bottom-to-top.
        """

        anomaly_full = np.abs(mesh.point_data[target_field])
        idx_sig = np.where(anomaly_full > anomaly_threshold)[0]

        if idx_sig.size > 0:
            x_min, x_max = np.min(mesh.points[idx_sig, 0]) - x_buffer, np.max(mesh.points[idx_sig, 0]) + x_buffer
            roi_mesh = mesh.clip_box([x_min, x_max, mesh.bounds[2], mesh.bounds[3], -1, 1], invert=False)
        else:
            roi_mesh = mesh

        all_fields = list(roi_mesh.point_data.keys())
        representative_trace = {f: {"depths": depth_grid.copy(), "values": np.full(depth_grid.shape, np.nan)} for f in all_fields + ["trace_x"]}

        last_valid_x = None

        indices = np.arange(len(y_grid))
        if reverse_direction:
            indices = indices[::-1]

        for idx in indices:
            y_val = y_grid[idx]
            slice_poly = roi_mesh.slice(normal="y", origin=(0, y_val, 0))

            if slice_poly.n_points == 0:
                continue

            slice_anomalies = np.abs(slice_poly.point_data[target_field])
            current_max_val = np.max(slice_anomalies)
            current_max_idx = np.argmax(slice_anomalies)
            current_max_x = slice_poly.points[current_max_idx][0]

            use_current_max = False

            if current_max_val >= anomaly_threshold:
                if last_valid_x is None:
                    use_current_max = True
                else:
                    jump_distance = abs(current_max_x - last_valid_x)
                    if jump_distance <= x_jump_threshold:
                        use_current_max = True

            if use_current_max:
                active_idx = current_max_idx
                last_valid_x = current_max_x
            elif last_valid_x is not None:
                active_idx = slice_poly.find_closest_point((last_valid_x, y_val, 0))
            else:
                active_idx = current_max_idx

            representative_trace["trace_x"]["values"][idx] = slice_poly.points[active_idx][0]

            for f in all_fields:
                val = slice_poly.point_data[f][active_idx]
                scalar = np.linalg.norm(val) if np.ndim(val) > 0 else float(val)
                scale = self.config.scaling_map.get(f, 1.0)
                representative_trace[f]["values"][idx] = scalar * scale

        return representative_trace

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _cache_to_summary(self, cache: dict) -> list[dict]:
        """
        Flatten the nested cache into a list of row dicts for DataFrame construction.

        Output columns are derived from trans_info so they remain consistent if transitions are added or removed.
        """
        keys = [
            "time",
            "z_ol_wd",
            "z_wd_ri",
            "z_ri_ps",
            "eta_therm",
            "eta_trans_ol_wd",
            "eta_trans_wd_ri",
            "eta_trans_ri_ps",
            "prescribed_velocity",
            "prescribed_temperature_anomaly",
            "mg_num",
            "scenario",
        ]
        for rate_field, x_key, disp_key, width_key, _, _ in self.trans_info.values():
            suffix = x_key.split("_")[-1]
            keys.extend([x_key, disp_key, width_key])
            keys.append(f"max_{rate_field}_{suffix}")
            keys.append(f"max_velocity_vertical_{suffix}")

        summary = []
        for model_id, timesteps in cache.items():
            for tstep, data in timesteps.items():
                row = {"model_id": model_id, "timestep": tstep}
                for k in keys:
                    row[k] = data.get(k, np.nan)
                summary.append(row)
        return summary

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _save_cache(self, cache: dict, path: Path) -> None:
        """Pickle the cache dict to disk, creating parent directories as needed."""
        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "wb") as f:
            pickle.dump(cache, f)
        print(f" -> {path}")


#######################################################
## .3. Plotting Pipeline                        !!! ##
#######################################################
@dataclass
class PlottingPipeline(BasePipeline):
    """
    Renders mesh field plots for all models and timesteps.

    Optionally annotates phase fraction field plots with the transition profile position and depth bounds derived from a pre-computed
    post-processing cache.
    """

    cache: dict = field(default_factory=dict)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def __post_init__(self) -> None:
        super().__post_init__()
        self.postprocessor = MeshPostProcessor(self.config, self.verbosity)
        self.plotter = MeshPlotter(self.config, self.trans_info, self.verbosity)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def run(self, fields_to_plot: list[str] | None) -> None:
        """
        Render and save plots for each field, model, and timestep.

        For phase fraction fields present in trans_info, overlays the transition profile position and depth bounds from the cache
        if available.

        Args:
            fields_to_plot: Fields to render. Defaults to all fields in config.file_map.
        """
        if fields_to_plot is None:
            fields_to_plot = list(self.config.file_map.keys())

        for model_id, (pvtu_files, timesteps) in self._get_ordered_pvtu_files().items():
            if not pvtu_files:
                if self.verbosity >= 1:
                    print(f" !! Warning: no result files for model: {model_id}")
                continue

            model_id_padded = re.sub(r"B(\d+)", lambda m: f"B{int(m.group(1)):0{2}d}", model_id)
            out_fig_dir = self.config.default_fig_dir / "meshes" / model_id_padded
            out_fig_dir.mkdir(parents=True, exist_ok=True)

            for pvtu_path, tstep in self._iter_valid_timesteps(pvtu_files, timesteps):
                needed_fields = []
                for field_name in fields_to_plot:
                    if field_name not in self.config.file_map:
                        continue

                    field_id = self.config.file_map.get(field_name, field_name.replace("_", "-"))
                    out_path = out_fig_dir / f"{model_id_padded.replace('_', '-')}-{field_id}-{str(tstep).zfill(4)}.png"

                    if not out_path.exists():
                        needed_fields.append((field_name, out_path))

                if not needed_fields:
                    continue

                mesh = self._load_mesh(pvtu_path)
                if mesh is None:
                    continue

                cached_data = self.cache.get(model_id, {}).get(tstep, {})

                for field_name, out_path in needed_fields:
                    self.preprocessor.prepare_mesh(mesh, field_name)
                    if not self.preprocessor.check_mesh(mesh, field_name):
                        continue

                    annotations = self._get_annotation_data(field_name, cached_data)
                    self.plotter.plot_mesh(mesh.copy(), field_name, out_path, annotations)

                del mesh
                gc.collect()

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_annotation_data(self, field_name: str, cached_data: dict) -> list[dict]:
        """
        Returns a list of annotation objects.

        Each object has a 'type' key:
          - 'arrows' : x_pos + (lower, upper) depth bounds  -> vertical arrow pair
          - 'trace'  : depths + x_positions + y_max         -> representative-trace polyline
        """
        annotations = []

        target_keys: list[str] = []
        if field_name in self.trans_info:
            target_keys = [field_name]
        elif field_name == "nonadiabatic_temperature":
            target_keys = list(self.trans_info.keys())

        if target_keys and cached_data:
            for key in target_keys:
                _, x_key, disp_key, width_key, _, rxn_depth = self.trans_info[key]

                x_pos = cached_data.get(x_key, np.nan)
                disp = cached_data.get(disp_key, np.nan)
                width = cached_data.get(width_key, np.nan)

                if not np.isnan(disp) and not np.isnan(width):
                    lower, upper = self.postprocessor.transition_depth_bounds(rxn_depth, disp, width, for_visualizing=True)
                    annotations.append({"type": "arrows", "x": x_pos, "bounds": (lower, upper), "label": key})

        if self.config.trace_map.get(field_name, False) and cached_data.get("trace"):
            trace = cached_data["trace"]
            annotations.append({"type": "trace", "depths": trace["depths"], "x_positions": trace["x_positions"], "y_max": trace["y_max"]})

        return annotations

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @classmethod
    def load_cache(cls, cache_path: Path) -> dict:
        """Load and return a pickled cache dict from disk."""
        print(f" .. Loading cache {cache_path.name}")
        with open(cache_path, "rb") as f:
            return pickle.load(f)


#######################################################
## .4. Full Pipeline                             !!! ##
#######################################################
@dataclass
class FullPipeline(BasePipeline):
    """
    Convenience pipeline that runs post-processing and plotting in sequence.

    Passes the post-processing cache directly to the plotting pipeline and reuses the file-discovery cache to avoid redundant filesystem globbing.
    """

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def run(
        self,
        fields_to_plot: list[str] | None,
        fields_for_seismic_profiles: list[str] | None,
        csv_path: Path | None,
        out_profile_dir: Path | None,
        transition_summary_cache_path: Path | None = None,
        seismic_profile_cache_path: Path | None = None,
        save_csv: bool = True,
        force_reprocess: bool = False,
    ) -> None:
        """
        Run post-processing then plotting, optionally exporting a csv summary.

        Args:
            fields_to_plot:  Fields to render. Defaults to all fields in config.file_map.
            csv_path:        Destination path for the summary csv file. Defaults to structure-summary-local.csv
            out_profile_dir: Destination for csv files. Defaults to postprocess_data/.
            cache_path:      If provided, pickle the result cache to this path.
            save_csv:        Whether to export a csv summary of structure measurements.
            force_reprocess: Overwrite existing cache if it exists.
        """
        out_profile_dir = out_profile_dir or Path("postprocess_data")

        post_processor = PostProcessingPipeline(self.config, self.pvtu_in_dirs, self.tsteps, self.trans_data, self.verbosity)
        transition_summary_cache, seismic_profile_cache = post_processor.run(
            transition_summary_cache_path, seismic_profile_cache_path, force_reprocess
        )

        if save_csv:
            csv_path = csv_path or Path("structure-summary-local.csv")
            post_processor.export_transition_summary(csv_path, transition_summary_cache, transition_summary_cache_path)

            if fields_for_seismic_profiles:
                post_processor.export_seismic_profiles(out_profile_dir, fields_for_seismic_profiles, seismic_profile_cache)

        plotter = PlottingPipeline(self.config, self.pvtu_in_dirs, self.tsteps, self.trans_data, self.verbosity, transition_summary_cache)
        plotter._pvtu_file_cache = post_processor._pvtu_file_cache
        plotter.run(fields_to_plot)
