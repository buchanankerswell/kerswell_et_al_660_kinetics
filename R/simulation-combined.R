#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 6) {
    cat(" !! Warning: Usage: Rscript simulation-combined.R [util_dir] [data_dir_warm] [data_dir_cold] [out_dir] [csv_raw] [csv_filtered]\n")
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

  in_data <- file.path(data_dirs, "structure-summary-local.csv")
  out_path_composition <- file.path(out_dir, "composition.png")
  out_path_tiles <- file.path(out_dir, "tiles-660.png")

  log_info("Visualizing structure: warm+cold combined")
  visualize_composition(data_dirs, out_path_composition, csv_path_raw, csv_path_filtered, save_csv, force_rewrite, by_suite = TRUE)
  visualize_tiles(in_data, out_path_tiles, height = 9.0)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
