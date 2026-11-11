#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 4) {
    cat(" !! Warning: Usage: seismic.R [util_dir] [data_dir_sw] [data_dir_nc] [out_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dir_sw <- args[2]
  data_dir_nc <- args[3]
  out_dir <- args[4]
  force_rewrite <- if (length(args) >= 5) as.logical(args[5]) else FALSE

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

  out_path <- file.path(out_dir, "seismic-sw-nc.png")

  visualize_seismic_comparison(data_dir_sw, data_dir_nc, out_path, force_rewrite = force_rewrite)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
