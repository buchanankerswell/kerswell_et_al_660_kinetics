"""Export the per-slab postprocessed table for the combined suite analysis.

Reads each suite's structure-summary-{tag}.csv and seismic-profile-cache-{tag}.pkl
from the flattened simulation/data/ dir, interpolates core nonadiabatic
temperature at the measured 410/660 transition depths, and splits measured
displacement into thermal offset (gamma*hat_T/(rho*g)) and kinetic
contribution (measured minus thermal).
"""

import argparse
import pickle
from pathlib import Path

import numpy as np
import pandas as pd

from simulation.params.transitions import (
    find_surface_depth_offset,
    find_transition,
    read_dG_profile,
)
from utils.logging import log_artifact, log_info

RHO = 4100.0
GRAV = 9.81


def parse_arguments():
    parser = argparse.ArgumentParser(description="Export postprocessed table.")
    parser.add_argument("--data-dir", required=True, help="Flattened simulation/data dir")
    parser.add_argument("--skip-test", action="store_true", help="Skip T1-T4 test rows")
    parser.add_argument("--out-csv", required=True, help="Output CSV path")
    parser.add_argument("--profile-ol-wd", required=True)
    parser.add_argument("--profile-wd-ri", required=True)
    parser.add_argument("--profile-ri-ps", required=True)
    parser.add_argument("--model-height", type=float, required=True)
    parser.add_argument("--surface-pressure", type=float, required=True)
    parser.add_argument("--depth-corr-ol-wd", type=float, default=0.0)
    parser.add_argument("--depth-corr-wd-ri", type=float, default=0.0)
    parser.add_argument("--depth-corr-ri-ps", type=float, default=0.0)
    parser.add_argument("--force", action="store_true", help="Overwrite output.")
    return parser.parse_args()


def nominal_transition(profile_path, model_height, surface_depth_offset, depth_corr):
    headers, data = read_dG_profile(profile_path)
    pt = find_transition(headers, data, model_height, surface_depth_offset)
    return pt.depth + depth_corr, pt.clapeyron


def interp_at(rep, field, depth):
    d = np.asarray(rep[field]["depths"], dtype=float)
    v = np.asarray(rep[field]["values"], dtype=float)
    m = np.isfinite(d) & np.isfinite(v)
    if m.sum() < 2:
        return np.nan
    return float(np.interp(depth, d[m], v[m]))


def main():
    args = parse_arguments()
    out_path = Path(args.out_csv)
    if out_path.exists() and not args.force:
        log_info(f"postprocessed exists (use --force to overwrite): {out_path}")
        return

    ref_headers, ref_data = read_dG_profile(args.profile_ol_wd)
    surface_offset = find_surface_depth_offset(ref_headers, ref_data, args.surface_pressure)
    rxn410, gamma410 = nominal_transition(
        args.profile_ol_wd, args.model_height, surface_offset, args.depth_corr_ol_wd
    )
    _, _ = nominal_transition(
        args.profile_wd_ri, args.model_height, surface_offset, args.depth_corr_wd_ri
    )
    rxn660, gamma660 = nominal_transition(
        args.profile_ri_ps, args.model_height, surface_offset, args.depth_corr_ri_ps
    )
    log_info(f"nominal 410={rxn410 / 1e3:.1f} km gamma={gamma410:.3e}; "
             f"nominal 660={rxn660 / 1e3:.1f} km gamma={gamma660:.3e}")

    rows = []
    data_dir = Path(args.data_dir)
    sources = [("sw-suite", "sw"), ("nc-suite", "nc")]
    if not args.skip_test:
        sources.append(("test-suite", "test"))

    for suite_key, tag in sources:
        summary_csv = data_dir / f"structure-summary-{tag}.csv"
        if not summary_csv.exists():
            continue
        loc = pd.read_csv(summary_csv)
        with open(data_dir / f"seismic-profile-cache-{tag}.pkl", "rb") as f:
            seis = pickle.load(f)
        slabs = loc[loc["model_id"].str.startswith("slab_")]
        slabs = slabs[slabs["timestep"] == 100]
        if suite_key == "test-suite":
            # TEST suite holds only T1-T4 (cold, b=1); include all rows.
            # Map to nc-suite for scenario indices 16-19 (see below).
            pass
        for _, r in slabs.iterrows():
            mid = r["model_id"]
            ts = int(r["timestep"])
            try:
                rep = seis[mid][ts]["representative"]
            except KeyError:
                continue
            rate = float(r["max_reaction_rate_660"])
            vmax = float(r["max_velocity_vertical_660"])
            disp660 = float(r["displacement_660"])
            hatT660 = interp_at(rep, "nonadiabatic_temperature", rxn660 + disp660)
            therm660 = gamma660 * hatT660 / (RHO * GRAV)
            disp410 = float(r["displacement_410"])
            hatT410 = interp_at(rep, "nonadiabatic_temperature", rxn410 + disp410)
            therm410 = gamma410 * hatT410 / (RHO * GRAV)
            suite = "nc-suite" if suite_key == "test-suite" else suite_key
            rows.append({
                "suite": suite,
                "model_id": mid,
                "timestep": ts,
                "z_ol_wd": float(r["z_ol_wd"]),
                "z_ri_ps": float(r["z_ri_ps"]),
                "eta_therm": float(r["eta_therm"]),
                "eta_trans_ri_ps": float(r["eta_trans_ri_ps"]),
                "prescribed_velocity": float(r["prescribed_velocity"]),
                "disp660_km": disp660 / 1e3,
                "width660_km": abs(float(r["width_660"])) / 1e3,
                "rate660": rate,
                "vmax660": vmax,
                "kin660_km": (disp660 - therm660) / 1e3,
                "therm660_km": therm660 / 1e3,
                "hatT660": hatT660,
                "L_km": (10.0 * vmax / rate) if rate > 0 else np.nan,
                "disp410_km": disp410 / 1e3,
                "width410_km": abs(float(r["width_410"])) / 1e3,
                "kin410_km": (disp410 - therm410) / 1e3,
                "therm410_km": therm410 / 1e3,
                "is_T": bool(suite == "nc-suite" and float(r["z_ol_wd"]) < 100),
            })

    df = pd.DataFrame(rows)
    base_vels = [0.05, 0.1]
    base_therms = [5.0, 10.0]
    base_trans = [50.0, 1.0]
    scenarios = []
    for _, r in df.iterrows():
        offset = 0 if r["suite"] == "sw-suite" else 1
        if r["is_T"]:
            if float(r["prescribed_velocity"]) < 0.15:
                scenarios.append(16 if float(r["z_ol_wd"]) < 5.0 else 17)
            else:
                scenarios.append(18 if float(r["z_ol_wd"]) < 5.0 else 19)
        else:
            vel_i = base_vels.index(float(r["prescribed_velocity"]))
            therm_j = base_therms.index(float(r["eta_therm"]))
            trans_k = base_trans.index(float(r["eta_trans_ri_ps"]))
            scenarios.append(
                trans_k * (len(base_vels) * len(base_therms)) + vel_i * len(base_therms) + therm_j + 8 * offset
            )
    df["scenario"] = scenarios

    out_path.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(out_path, index=False)
    log_info(f"postprocessed: {len(df)} rows")
    log_artifact(out_path)


if __name__ == "__main__":
    main()
