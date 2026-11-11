#!/usr/bin/env Rscript

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 4) {
    cat(" !! Warning: Usage: Rscript adiabat.R [util_dir] [model_id] [data_dir] [out_dir]\n")
    return(invisible())
  }

  util_dir <- args[1]
  model_id <- args[2]
  data_dir <- args[3]
  out_dir <- args[4]

  lapply(list.files(util_dir, pattern = "\\.R$", full.names = TRUE), source)

  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

  in_adiabatic_profile <- file.path(data_dir, paste0(model_id, "-adiabatic-profile.tsv"))
  in_material_table <- file.path(data_dir, paste0(model_id, "-material-table.tab"))
  in_profiles <- c(
    file.path(data_dir, "olivine-wadsleyite-profile-Mg100.tsv"),
    file.path(data_dir, "wadsleyite-ringwoodite-profile-Mg100.tsv"),
    file.path(data_dir, "ringwoodite-postspinel-profile-Mg100.tsv")
  )

  out_material_table <- file.path(out_dir, paste0(model_id, "-material-table.png"))
  out_material_profiles <- file.path(out_dir, "material-property-profiles.png")
  out_thermodynamic_profiles <- file.path(out_dir, "thermodynamic-property-profiles.png")

  missing <- c(in_material_table, in_profiles)[!file.exists(c(in_material_table, in_profiles))]

  if (length(missing) > 0) {
    log_warn("the following input files do not exist:")
    for (f in missing) log_detail(f)
    return(invisible())
  }

  tryCatch(
    {
      visualize_material_table(in_adiabatic_profile, in_material_table, out_material_table)
      visualize_material_profile(in_profiles, out_material_profiles)
      visualize_thermodynamic_profile(in_profiles, out_thermodynamic_profiles)
    },
    error = function(e) {
      log_error(paste("drawing issue:", conditionMessage(e)))
    }
  )
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
