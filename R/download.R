#!/usr/bin/env Rscript

#######################################################
## Download ASPECT results from OSF repo         !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 2) {
    cat(" !! Usage: Rscript main.R [util_dir] [data_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dir <- args[2]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)
  download_simulation_results_from_osf(data_dir)
}

if (
  !interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))
) {
  main()
}
