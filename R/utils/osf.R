upload_results_to_osf <- function(up_dir, conflicts = "skip", verbose = TRUE) {
  if (Sys.getenv("OSF_PAT") == "") {
    stop(" !! Access denied: only the OSF repository owner can upload data to this project.", call. = FALSE)
  }
  if (!dir.exists(up_dir)) {
    stop(paste0(" -- Error: Local directory '", up_dir, "' not found. Nothing to upload."), call. = FALSE)
  }

  osf_retrieve_node("kur93") |>
    osf_upload(path = up_dir, recurse = TRUE, conflicts = conflicts, verbose = verbose)
}

download_results_from_osf <- function(data_dir, sim_dir, conflicts = "skip", verbose = TRUE) {
  node_id <- "kur93"

  if (!dir.exists(data_dir)) dir.create(data_dir, recursive = TRUE)
  if (!dir.exists(sim_dir)) dir.create(sim_dir, recursive = TRUE)

  osf_node <- osf_retrieve_node(node_id)
  node_files <- osf_ls_files(osf_node)

  data_dir_node <- node_files[node_files$name == "data", ]

  if (nrow(data_dir_node) == 1) {
    if (length(list.files(data_dir)) == 0) {
      log_info("Downloading archived data from OSF")
      osf_download(data_dir_node, path = data_dir, conflicts = conflicts, recurse = TRUE)
    } else {
      log_detail(paste("Found local data in:", data_dir))
    }
  } else {
    log_warn("Warning: could not find a unique folder named 'data' in the OSF repository.")
  }

  results_dir_node <- node_files[node_files$name == "results", ]

  if (nrow(results_dir_node) == 1) {
    patterns <- c(
      "slab_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-11_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02",
      "slab_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri1.90e-08_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02",
      "slab_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-05_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02",
      "slab_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-11_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02",
      "slab_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri1.90e-08_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02",
      "slab_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-05_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02",
      "plume_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-11_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02",
      "plume_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri1.90e-08_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02",
      "plume_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-05_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02",
      "plume_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-11_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02",
      "plume_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri1.90e-08_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02",
      "plume_KN_Dynp0_Zol4.44e-04_Zwd4.44e-04_Zri5.08e-05_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02"
    )

    osf_results_files <- osf_ls_files(results_dir_node)

    log_info("Syncing archived simulation results from OSF")
    cli::cli_progress_bar("Syncing results", total = length(patterns))
    for (pattern in patterns) {
      target_local_dir <- file.path(sim_dir, pattern)

      if (!dir.exists(target_local_dir)) {
        matched_node <- osf_results_files[osf_results_files$name == pattern, ]

        if (nrow(matched_node) == 1) {
          osf_download(matched_node, path = sim_dir, conflicts = conflicts, recurse = TRUE)
        } else {
          log_warn(paste("Warning: target not found on OSF or ambiguous:", pattern))
        }
      } else {
        log_detail(paste("Found data:", target_local_dir))
      }
      cli::cli_progress_update()
    }
    cli::cli_progress_done()
  } else {
    log_warn("Warning: could not find a unique folder named 'results' in the OSF repository.")
  }
}
