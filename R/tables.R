#!/usr/bin/env Rscript

#######################################################
## Write markdown tables                             ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 3) {
    cat(" !! Usage: Rscript tables.R [util_dir] [csv_path] [out_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  csv_path <- args[2]
  out_dir <- args[3]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  write_simulation_results_summary_table(csv_path, out_dir)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
