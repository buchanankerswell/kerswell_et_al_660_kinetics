#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 4) {
    cat(" !! Warning: Usage: seismic-combined.R [util_dir] [data_dir_warm] [data_dir_cold] [out_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dir_warm <- args[2]
  data_dir_cold <- args[3]
  out_dir <- args[4]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

  out_path <- file.path(out_dir, "seismic-warm-cold.png")

  log_info("Visualizing seismic: warm+cold matched-forcing comparison")
  visualize_seismic_comparison(data_dir_warm, data_dir_cold, out_path)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
