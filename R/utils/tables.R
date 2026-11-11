write_postprocessed_summary_table <- function(postprocessed_csv, out_dir, quiet = TRUE) {
  if (!file.exists(postprocessed_csv)) {
    if (!quiet) log_error(paste("Input postprocessed CSV not found:", postprocessed_csv))
    return(invisible())
  }

  if (!quiet) log_info("Reading and formatting postprocessed slab data")

  postprocessed_data <- suppressWarnings(read_csv(postprocessed_csv, show_col_types = FALSE))

  if (is.null(postprocessed_data) || !nrow(postprocessed_data)) {
    return(invisible())
  }

  out_path_md <- file.path(out_dir, "postprocessed.md")

  if (!quiet) log_artifact(out_path_md)

  formatted <- postprocessed_data |>
    mutate(
      test = case_when(
        is_T & scenario == 16 ~ "T1",
        is_T & scenario == 17 ~ "T2",
        is_T & scenario == 18 ~ "T3",
        is_T & scenario == 19 ~ "T4",
        TRUE ~ ""
      ),
      regime = case_when(
        L_km <= 5 & vmax660 > 0.5 ~ 1L,
        L_km > 5 & vmax660 > 0.5 ~ 2L,
        TRUE ~ 3L
      ),
      suite_ord = factor(suite, levels = c("sw-suite", "nc-suite")),
      suite_abbr = case_when(
        is_T ~ test,
        suite == "sw-suite" ~ "SW",
        TRUE ~ "NC"
      )
    ) |>
    select(
      Suite = suite_abbr,
      Scenario = scenario,
      `$Z_\\mathrm{ri}$` = z_ri_ps,
      `$\\delta z$` = disp660_km,
      `$\\delta w$` = width660_km,
      `$\\dot{X}_\\mathrm{max}$` = rate660,
      `$\\vec{v}_\\mathrm{max}$` = vmax660,
      `$\\delta z_t$` = therm660_km,
      `$\\delta z_k$` = kin660_km,
      Regime = regime,
      suite_ord = suite_ord,
      test_ord = test
    ) |>
    arrange(suite_ord, Scenario, test_ord, desc(`$Z_\\mathrm{ri}$`)) |>
    select(-suite_ord, -test_ord) |>
    mutate(across(c(`$Z_\\mathrm{ri}$`), ~ formatC(.x, format = "e", digits = 1))) |>
    mutate(across(c(`$\\dot{X}_\\mathrm{max}$`), ~ formatC(.x, format = "e", digits = 2))) |>
    mutate(across(c(`$\\vec{v}_\\mathrm{max}$`), ~ formatC(.x, format = "f", digits = 2))) |>
    mutate(across(c(`$\\delta z$`, `$\\delta w$`, `$\\delta z_t$`, `$\\delta z_k$`), ~ formatC(.x, format = "f", digits = 1)))

  col_align <- c("l", rep("r", ncol(formatted) - 1))

  md_table <- kable(formatted, format = "pipe", escape = FALSE, align = col_align)
  writeLines(md_table, out_path_md)
}
