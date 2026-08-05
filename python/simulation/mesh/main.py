#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import re
from argparse import ArgumentParser, ArgumentTypeError, Namespace
from pathlib import Path

from simulation.mesh.config import MeshConfig
from simulation.mesh.pipeline import FullPipeline, PlottingPipeline, PostProcessingPipeline
from simulation.params.transitions import PhaseTransition, find_surface_depth_offset, find_transition, read_dG_profile
from tile import ImageTiler


#######################################################
## .1. Helpers                                   !!! ##
#######################################################
def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ("yes", "true", "t", "y", "1"):
        return True
    elif v.lower() in ("no", "false", "f", "n", "0"):
        return False
    else:
        raise ArgumentTypeError("Boolean value expected.")


def parse_arguments() -> Namespace:
    """ """
    parser = ArgumentParser(description="Visualize and postprocess simulation results.")

    parser.add_argument("dG_profile_ol_wd", type=str, help="Path to olivine-wadsleyite dG profile")
    parser.add_argument("dG_profile_wd_ri", type=str, help="Path to wadsleyite-ringwoodite dG profile")
    parser.add_argument("dG_profile_ri_ps", type=str, help="Path to ringwoodite-bridgmanite dG profile")
    parser.add_argument("model_height", type=float, help="Model height [m]")
    parser.add_argument("surface_pressure", type=float, help="Surface pressure [Pa]")
    parser.add_argument("out_fig_dir", type=str, help="Output figure directory")
    parser.add_argument("out_data_dir", type=str, help="Output data directory")

    parser.add_argument("--model-ids", nargs="+", type=str, required=True, help="Simulation names")
    parser.add_argument("--timesteps", nargs="+", type=int, required=True, help="Timesteps to process")
    parser.add_argument("--in-dirs", nargs="+", type=str, required=True, help="Simulation results directories")

    parser.add_argument("--depth-corr-ol-wd", type=float, default=0.0, help="Depth correction for the olivine -> wadsleyite transition [m].")
    parser.add_argument("--depth-corr-wd-ri", type=float, default=0.0, help="Depth correction for the wadsleyite -> ringwoodite transition [m].")
    parser.add_argument("--depth-corr-ri-ps", type=float, default=0.0, help="Depth correction for the ringwoodite -> bridgmanite transition [m].")
    parser.add_argument("--mode", type=str, choices=["postprocess", "visualize", "full"], default="full", help="Pipeline mode.")
    parser.add_argument("--save-csv", type=str2bool, default=True, help="Save structure data to csv.")
    parser.add_argument("--force-reprocess", type=str2bool, default=False, help="Force reprocessing and overwriting of cache.")
    parser.add_argument("--verbosity", type=int, default=0, help="Verbosity.")

    return parser.parse_args()


#######################################################
## .2. Main                                      !!! ##
#######################################################
def main():
    """ """
    args = parse_arguments()

    model_height = args.model_height
    headers, data = read_dG_profile(args.dG_profile_ol_wd)
    surface_depth = find_surface_depth_offset(headers, data, args.surface_pressure)

    depth_corrections: dict[str, float] = {
        "X_wd": args.depth_corr_ol_wd,
        "X_ri": args.depth_corr_wd_ri,
        "X_ps": args.depth_corr_ri_ps,
    }

    trans_data: dict[str, PhaseTransition] = {}
    for phase_key, filepath in [("X_wd", args.dG_profile_ol_wd), ("X_ri", args.dG_profile_wd_ri), ("X_ps", args.dG_profile_ri_ps)]:
        hdrs, dat = read_dG_profile(filepath)

        transition = find_transition(hdrs, dat, model_height, surface_depth)
        correction = depth_corrections.get(phase_key, 0.0)

        transition.depth += correction
        transition.y -= correction

        trans_data[phase_key] = transition

    model_ids = args.model_ids or []
    tsteps = args.timesteps or []
    in_dirs = [Path(p) for p in args.in_dirs] if args.in_dirs else []
    out_fig_dir = Path(args.out_fig_dir) if args.out_fig_dir else Path("./figures")
    out_data_dir = Path(args.out_data_dir) if args.out_data_dir else Path("./data")
    mode = args.mode or "visualize"
    save_csv = args.save_csv or True
    force_reprocess = args.force_reprocess or False
    verbosity = args.verbosity or 0

    fields_to_plot = [
        "nonadiabatic_temperature",
        "nonadiabatic_density",
        "velocity_vertical",
        # "nonadiabatic_pressure",
        "viscosity",
        # "seismic_Vp",
        "reaction_rate_C0",
        "reaction_rate_C1",
        "reaction_rate_C2",
        "X_wd",
        "X_ri",
        "X_ps",
    ]

    fields_for_seismic_profiles = ["density", "seismic_Vp", "seismic_Vs"]

    plot_config = MeshConfig()
    plot_config.file_map = {k: plot_config.file_map[k] for k in fields_to_plot if k in plot_config.file_map}
    plot_config.default_fig_dir = out_fig_dir

    pvtu_in_dirs = dict(zip(model_ids, in_dirs))
    transition_summary_path = out_data_dir / "structure-cache.pkl"
    seismic_profile_cache_path = out_data_dir / "seismic-profile-cache.pkl"
    csv_path = out_data_dir / "structure-summary-local.csv"
    out_seismic_profile_dir = out_data_dir / "seismic_profiles"

    transition_summary = None
    seismic_profile_cache = None
    if mode == "postprocess":
        pipeline = PostProcessingPipeline(plot_config, pvtu_in_dirs, tsteps, trans_data, verbosity)

        transition_summary, seismic_profile_cache = pipeline.run(transition_summary_path, seismic_profile_cache_path, force_reprocess)
        pipeline.export_transition_summary(csv_path, transition_summary)

        pipeline.export_seismic_profiles(out_seismic_profile_dir, fields_for_seismic_profiles, seismic_profile_cache)

    elif mode == "visualize":
        if not transition_summary_path.exists() or force_reprocess:
            post_pipeline = PostProcessingPipeline(plot_config, pvtu_in_dirs, tsteps, trans_data, verbosity)
            transition_summary, seismic_profile_cache = post_pipeline.run(transition_summary_path, seismic_profile_cache_path, force_reprocess)
        else:
            transition_summary = PlottingPipeline.load_cache(transition_summary_path)

        plot_pipeline = PlottingPipeline(plot_config, pvtu_in_dirs, tsteps, trans_data, verbosity, transition_summary)
        plot_pipeline.run(fields_to_plot)

    else:
        pipeline = FullPipeline(plot_config, pvtu_in_dirs, tsteps, trans_data, verbosity)
        pipeline.run(
            fields_to_plot,
            fields_for_seismic_profiles,
            csv_path,
            out_seismic_profile_dir,
            transition_summary_path,
            seismic_profile_cache_path,
            save_csv,
            force_reprocess,
        )

    if mode in ["visualize", "full"]:
        tile_sets = {
            "set0": {"tags": None, "fields": ["nonadiabatic_temperature", "nonadiabatic_density", "velocity_vertical"]},
            "set1": {"tags": None, "fields": ["reaction_rate_C0", "reaction_rate_C1", "reaction_rate_C2"]},
            "set2": {"tags": None, "fields": ["X_wd", "X_ri", "X_ps"]},
            "set3": {"tags": None, "fields": ["nonadiabatic_temperature", "viscosity", "X_ps"]},
        }

        for model_id in pvtu_in_dirs.keys():
            model_id_padded = re.sub(r"B(\d+)", lambda m: f"B{int(m.group(1)):0{2}d}", model_id)

            for config in tile_sets.values():
                fields = config.get("fields", None)
                tags = config.get("tags", None)
                if fields and len(fields) == 3:
                    tiler = ImageTiler(plot_config, out_fig_dir / "meshes" / model_id_padded, fields[0], fields[1], fields[2], tags)
                    tiler.tile_images()


if __name__ == "__main__":
    main()
