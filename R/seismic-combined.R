#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 4) {
    cat(" !! Warning: Usage: seismic-combined.R [util_dir] [data_dir_warm_sluggish] [data_dir_cold_nominal] [out_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dir_warm_sluggish <- args[2]
  data_dir_cold_nominal <- args[3]
  out_dir <- args[4]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

  out_path <- file.path(out_dir, "seismic-warm-sluggish-cold-nominal.png")

  log_info("Visualizing seismic: matched-forcing suite comparison")
  visualize_seismic_comparison(data_dir_warm_sluggish, data_dir_cold_nominal, out_path)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
