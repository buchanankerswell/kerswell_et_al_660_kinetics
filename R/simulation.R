#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 5) {
    cat(" !! Warning: Usage: simulation.R [util_dir] [summary_sw] [summary_nc] [out_dir] [force_rewrite] [postprocessed_csv]\n")
    return(invisible())
  }

  util_dir <- args[1]
  in_data <- c(args[2], args[3])
  out_dir <- args[4]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  force_rewrite <- parse_logical(args[5])
  postprocessed_csv <- if (length(args) >= 6) args[6] else ""

  out_path_contributions <- file.path(out_dir, "contributions.png")
  out_path_tiles_rate <- file.path(out_dir, "tiles-rate.png")
  out_path_interactions_quant <- file.path(out_dir, "interactions-quantitative.png")

  if (nzchar(postprocessed_csv)) {
    visualize_contributions(in_data, postprocessed_csv, out_path_contributions, force_rewrite = force_rewrite)
    visualize_tiles_rate(in_data, postprocessed_csv, out_path_tiles_rate, force_rewrite = force_rewrite)
    visualize_interactions_quantitative(in_data, postprocessed_csv, out_path_interactions_quant, force_rewrite = force_rewrite)
  }
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
