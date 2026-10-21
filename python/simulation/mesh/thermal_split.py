"""Export per-slab thermal-kinetic split for the combined warm+cold analysis.

Reads each suite's structure-summary-local.csv and seismic-profile-cache.pkl,
interpolates core nonadiabatic temperature at the measured 410/660 transition
depths, and splits measured displacement into thermal offset
(gamma*hat_T/(rho*g)) and kinetic contribution (measured minus thermal).

Scenario indices replicate R/utils/simulation.R grouped logic: ranks computed
within each suite (velocity ascending, eta_therm ascending, eta_trans
descending), cold slabs offset by +8.
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

RHO = 4100.0
GRAV = 9.81


def parse_arguments():
    parser = argparse.ArgumentParser(description="Export thermal-kinetic split.")
    parser.add_argument("--warm-data", required=True, help="Warm suite data dir")
    parser.add_argument("--cold-data", required=True, help="Cold suite data dir")
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
        print(f"split exists (use --force to overwrite): {out_path}")
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
    print(f"nominal 410={rxn410 / 1e3:.1f} km gamma={gamma410:.3e}; "
          f"nominal 660={rxn660 / 1e3:.1f} km gamma={gamma660:.3e}")

    rows = []
    for suite, data_dir in (("warm", args.warm_data), ("cold", args.cold_data)):
        data_dir = Path(data_dir)
        loc = pd.read_csv(data_dir / "structure-summary-local.csv")
        with open(data_dir / "seismic-profile-cache.pkl", "rb") as f:
            seis = pickle.load(f)
        slabs = loc[loc["model_id"].str.startswith("slab_")]
        slabs = slabs[slabs["timestep"] == 100]
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
                "is_T": bool(suite == "cold" and float(r["z_ol_wd"]) < 100),
            })

    df = pd.DataFrame(rows)
    # Scenario indices mirror R grouped logic (ranks within each suite).
    scenarios = []
    for suite, cold in (("warm", 0), ("cold", 1)):
        d = df[df["suite"] == suite]
        vels = sorted(d["prescribed_velocity"].unique())
        therms = sorted(d["eta_therm"].unique())
        trans = sorted(d["eta_trans_ri_ps"].unique(), reverse=True)
        for _, r in d.iterrows():
            vel_i = vels.index(r["prescribed_velocity"])
            therm_j = therms.index(r["eta_therm"])
            trans_k = trans.index(r["eta_trans_ri_ps"])
            scenarios.append(
                trans_k * (len(vels) * len(therms)) + vel_i * len(therms) + therm_j + 8 * cold
            )
    df["scenario"] = scenarios

    out_path.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(out_path, index=False)
    print(f"wrote {out_path} ({len(df)} rows)")


if __name__ == "__main__":
    main()
