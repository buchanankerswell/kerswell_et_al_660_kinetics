#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 6) {
    cat(" !! Warning: Usage: simulation-combined.R [util_dir] [data_dir_warm_sluggish] [data_dir_cold_nominal] [out_dir] [csv_raw] [csv_filtered] [save_csv] [force_rewrite] [split_csv]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dirs <- c(args[2], args[3])
  out_dir <- args[4]
  csv_path_raw <- args[5]
  csv_path_filtered <- args[6]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  save_csv <- parse_logical(args[7])
  force_rewrite <- parse_logical(args[8])
  split_csv <- if (length(args) >= 9) args[9] else ""

  in_data <- file.path(data_dirs, "structure-summary-local.csv")
  out_path_composition <- file.path(out_dir, "composition.png")
  out_path_tiles <- file.path(out_dir, "tiles-660.png")
  out_path_contributions <- file.path(out_dir, "contributions.png")
  out_path_tiles_rate <- file.path(out_dir, "tiles-rate.png")
  out_path_regime_joint <- file.path(out_dir, "regime-joint.png")

  visualize_composition(data_dirs, out_path_composition, csv_path_raw, csv_path_filtered, save_csv, force_rewrite, by_suite = TRUE)
  visualize_tiles(in_data, out_path_tiles, height = 9.0)

  if (nzchar(split_csv)) {
    visualize_contributions(in_data, split_csv, out_path_contributions)
    visualize_tiles_rate(in_data, split_csv, out_path_tiles_rate)
    visualize_regime_joint(in_data, split_csv, out_path_regime_joint)
  }
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
