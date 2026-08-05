#!/usr/bin/env Rscript

#######################################################
## Visualize Adiabatic Reference Conditions      !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 4) {
    cat(" !! Usage: Rscript adiabat.R [util_dir] [model_id] [data_dir] [out_dir]\n")
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

  missing <- c()
  if (!file.exists(in_material_table)) missing <- c(missing, in_material_table)
  if (!file.exists(in_profiles[1])) missing <- c(missing, in_profiles[1])
  if (!file.exists(in_profiles[2])) missing <- c(missing, in_profiles[1])

  if (length(missing) > 0) {
    cat(" !! Warning: the following input files do not exist:\n")
    for (f in missing) cat(" -- ", f, "\n", sep = "")
    return(invisible())
  }

  tryCatch(
    {
      visualize_material_table(in_adiabatic_profile, in_material_table, out_material_table)
      visualize_material_profile(in_profiles, out_material_profiles)
      visualize_thermodynamic_profile(in_profiles, out_thermodynamic_profiles)
    },
    error = function(e) {
      cat(" !! Error: drawing issue: ", conditionMessage(e), "\n", sep = "")
    }
  )
}

if (!interactive() && (sys.nframe() == 0 || identical(environment(), globalenv()))) {
  main()
}
