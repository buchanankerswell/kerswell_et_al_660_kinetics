#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 4) {
    cat(" !! Usage: Rscript osf.R [util_dir] [data_dir] [sim_dir] [sync_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  data_dir <- args[2]
  sim_dir <- args[3]
  sync_dir <- args[4]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  if (sync_dir == "download") {
    download_results_from_osf(data_dir, sim_dir)
  } else if (sync_dir == "upload") {
    upload_results_to_osf(data_dir)
    upload_results_to_osf(sim_dir)
  } else {
    log_error(paste0("Error: unknown sync command '", sync_dir, "'. Use 'upload' or 'download'."))
  }
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
