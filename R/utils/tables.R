#######################################################
## Write markdown tables                         !!! ##
#######################################################
write_simulation_results_summary_table <- function(csv_path, out_dir, quiet = TRUE) {
  if (!file.exists(csv_path)) {
    if (!quiet) cat(" !! Error: Input CSV file not found:", csv_path, "\n")
    return(invisible())
  }

  if (!quiet) cat(" .. Reading and formatting plume simulation data\n")

  summary_data <- read_csv(csv_path, show_col_types = FALSE)

  if (!is.null(summary_data) && nrow(summary_data) > 0) {
    md_dir <- file.path(out_dir, "markdown")
    if (!dir.exists(md_dir)) dir.create(md_dir, recursive = TRUE)

    csv_filename <- basename(csv_path)
    md_filename <- sub("\\.csv$", ".md", csv_filename)
    out_path_md <- file.path(md_dir, md_filename)

    if (!quiet) cat(" -> ", out_path_md, "\n", sep = "")

    formatted_summary <- summary_data |>
      select(-z_ol_wd) |>
      filter(scenario != 9) |>
      mutate(simulation_type = str_extract(model_id, "^(plume|slab)")) |>
      mutate(characteristic_length_scale = max_velocity_vertical / max_reaction_rate * 10) |>
      select(
        Type = simulation_type,
        Scenario = scenario,
        `$Z_\\mathrm{ri}$` = z_ri_ps,
        Displacement = displacement,
        Width = width,
        `$\\dot{X}_\\mathrm{max}$` = max_reaction_rate,
        `$\\vec{v}_\\mathrm{max}$` = max_velocity_vertical,
        `$L$` = characteristic_length_scale,
        Regime = regime
      ) |>
      arrange(`Type`, Scenario, desc(`$Z_\\mathrm{ri}$`)) |>
      mutate(across(c(`$Z_\\mathrm{ri}$`, `$L$`), ~ formatC(.x, format = "e", digits = 1))) |>
      mutate(across(c(`$\\dot{X}_\\mathrm{max}$`), ~ formatC(.x, format = "e", digits = 2))) |>
      mutate(across(c(`$\\vec{v}_\\mathrm{max}$`), ~ formatC(.x, format = "f", digits = 2))) |>
      mutate(across(c(Displacement, Width), ~ formatC(.x, format = "f", digits = 1))) |>
      select(-`$L$`)

    col_align <- c("l", rep("r", ncol(formatted_summary) - 1), "l")

    md_table <- kable(formatted_summary, format = "pipe", escape = FALSE, align = col_align)
    writeLines(md_table, out_path_md)
  }
}
