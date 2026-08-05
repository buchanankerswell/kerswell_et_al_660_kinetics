#######################################################
## Download ASPECT results from OSF repo         !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
download_simulation_results_from_osf <- function(data_dir) {
  old_path <- file.path(data_dir, "depth-profile-data.csv")
  new_path <- file.path(data_dir, "structure-summary-kerswell-et-al-2026.csv")

  if (!file.exists(new_path)) {
    if (!dir.exists(data_dir)) dir.create(data_dir, recursive = TRUE)

    osf_retrieve_node("9phwc") |>
      osf_ls_files(pattern = "csv") |>
      osf_download(path = data_dir, conflicts = "overwrite")

    if (file.exists(old_path)) invisible(file.rename(old_path, new_path))
  }
}
