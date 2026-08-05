#!/usr/bin/env Rscript

#######################################################
## Visualize MTZ structure                       !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 5) {
    cat(" !! Usage: Rscript simulation.R [util_dir] [data_dir] [out_dir] [csv_path_raw] [csv_path_filtered]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dir <- args[2]
  out_dir <- args[3]
  csv_path_raw <- args[4]
  csv_path_filtered <- args[5]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  save_csv <- parse_logical(args[6])
  force_rewrite <- parse_logical(args[7])

  in_data <- file.path(data_dir, "structure-summary-local.csv")
  out_path_composition <- file.path(out_dir, "composition.png")
  out_path_tiles <- file.path(out_dir, "tiles-660.png")

  visualize_composition(data_dir, out_path_composition, csv_path_raw, csv_path_filtered, save_csv, force_rewrite)
  visualize_tiles(in_data, out_path_tiles)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
