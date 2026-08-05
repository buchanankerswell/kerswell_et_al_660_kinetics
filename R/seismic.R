#!/usr/bin/env Rscript

#######################################################
## Visualize seismic profiles                    !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 3) {
    cat(" !! Usage: Rscript seismic.R [util_dir] [data_dir] [out_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dir <- args[2]
  out_dir <- args[3]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

  out_path_profiles <- file.path(out_dir, "seismic-composition.png")

  visualize_seismic_profiles(data_dir, out_path_profiles)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
