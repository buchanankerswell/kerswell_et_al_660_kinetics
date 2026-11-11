#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 3) {
    cat(" !! Warning: Usage: Rscript tables.R [util_dir] [postprocessed_csv] [out_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  postprocessed_csv <- args[2]
  out_dir <- args[3]

  lapply(list.files(util_dir, pattern = "R$", full.names = TRUE), source)

  write_postprocessed_summary_table(postprocessed_csv, out_dir)
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
