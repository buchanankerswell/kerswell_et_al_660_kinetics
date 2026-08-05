#!/usr/bin/env Rscript

#######################################################
## Prepare R Environment                         !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main <- function() {
  options(repos = c(CRAN = "https://cloud.r-project.org"))

  if (!requireNamespace("renv", quietly = TRUE)) {
    install.packages("renv", quiet = TRUE)
  }

  lockfile <- "renv.lock"

  if (file.exists(lockfile)) {
    renv::restore(prompt = FALSE)
  } else {
    cran_pkgs <- c("tidyverse", "patchwork", "colorspace", "osfr", "knitr")

    suppressWarnings({
      renv::install(cran_pkgs, verbose = FALSE)
      renv::snapshot(packages = cran_pkgs, prompt = FALSE)
    })
  }
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
