read_kerswell_data <- function(filepath, scenario_offset = 0) {
  # Archived 410 runs ran at sluggish Z = nominal Z / 3.15e7 (see erratum); rescale
  # on the fly since the OSF archive is read-only.
  sec_per_year <- 3.15e7

  raw <- suppressWarnings(read_csv(filepath, show_col_types = FALSE)) |>
    mutate(scenario = as.integer(factor(B_factor)) + scenario_offset)

  raw |>
    transmute(
      model_id = str_replace_all(model_id, "_", "-"),
      scenario = scenario,
      timestep = timestep,
      z_ol_wd = Z_factor / sec_per_year,
      z_ri_ps = NA_real_,
      displacement = displacement / 1e3,
      width = abs(width) / 1e3,
      max_reaction_rate = max_reaction_rate,
      max_velocity_vertical = max_velocity,
      transition = "410",
      Z_factor = Z_factor / sec_per_year,
      B_factor = B_factor,
      source = "kerswell_2026"
    ) |>
    filter(is.finite(max_reaction_rate), max_reaction_rate > 0)
}

read_local_data <- function(filepath) {
  # filepath may be a single path (per-suite figures) or a vector of paths
  # (merged suite figures); rows bind in order so warm-sluggish scenarios keep
  # indices 0-7 and cold-nominal scenarios offset to 8-15 below.
  raw_df <- bind_rows(lapply(filepath, function(p) suppressWarnings(read_csv(p, show_col_types = FALSE))))

  extract_transition_data <- function(df, trans_label) {
    df |>
      select(model_id, scenario, timestep, z_ol_wd, z_ri_ps, prescribed_velocity, eta_therm, eta_trans_ri_ps, contains(trans_label)) |>
      rename_with(~ str_remove(., paste0("_", trans_label)), contains(trans_label)) |>
      mutate(
        transition = trans_label,
        displacement = displacement / 1e3,
        width = abs(width) / 1e3,
        model_id = str_replace_all(model_id, "_", "-"),
        source = "local"
      )
  }

  bind_rows(
    extract_transition_data(raw_df, "410"),
    extract_transition_data(raw_df, "660")
  ) |>
    # Scenario indices recomputed deterministically from kinematic/rheological
    # parameters (pipeline parity: velocity and eta_therm ascending, eta_trans
    # descending). Chunked mesh runs index scenarios per chunk, so the cached
    # column drifts for homogeneous chunks; recomputing here keeps tile rows
    # unambiguous. Cold-nominal slabs offset by +8 as before.
    group_by(cold_nominal_suite = str_detect(model_id, fixed("Temp10e+02"))) |>
    mutate(
      vel_i = match(prescribed_velocity, sort(unique(prescribed_velocity))) - 1L,
      therm_j = match(eta_therm, sort(unique(eta_therm))) - 1L,
      trans_k = match(eta_trans_ri_ps, sort(unique(eta_trans_ri_ps), decreasing = TRUE)) - 1L,
      scenario = trans_k * (n_distinct(prescribed_velocity) * n_distinct(eta_therm)) +
        vel_i * n_distinct(eta_therm) + therm_j + 8L * cold_nominal_suite
    ) |>
    ungroup() |>
    select(-cold_nominal_suite, -vel_i, -therm_j, -trans_k)
}

process_and_combine_data <- function(filepath_local,
                                     filepath_kerswell,
                                     csv_path_raw = NULL,
                                     csv_path_filtered = NULL,
                                     save_csv = TRUE,
                                     force_rewrite = FALSE) {
  df_local_raw <- read_local_data(filepath_local)

  regime_data <- df_local_raw |>
    filter(transition == "660", str_detect(model_id, "slab"), timestep == 100) |>
    mutate(characteristic_length_scale = max_velocity_vertical / max_reaction_rate * 10) |>
    assign_regimes()

  df_regime <- regime_data$df_tiled |> select(model_id, scenario, z_ri_ps, regime)
  df_local_raw <- df_local_raw |> left_join(df_regime, by = c("model_id", "scenario", "z_ri_ps"))

  local_max <- max(df_local_raw$scenario, na.rm = TRUE)
  if (!is.finite(local_max)) local_max <- 0

  df_kerswell_raw <- read_kerswell_data(filepath_kerswell, local_max) |> mutate(regime = NA_integer_)

  apply_neat_formats <- function(df) {
    df |>
      mutate(
        across(
          any_of(c("z_ol_wd", "z_wd_ri", "z_ri_ps", "max_reaction_rate", "max_velocity_vertical")),
          ~ ifelse(is.na(.), NA, sprintf("%.3e", .))
        ),
        across(any_of(c("displacement", "width")), ~ ifelse(is.na(.), NA, sprintf("%.3f", .))),
        across(any_of(c("time", "scenario", "timestep", "regime")), ~ ifelse(is.na(.), NA, sprintf("%.0f", .)))
      )
  }

  common_cols <- intersect(names(df_local_raw), names(df_kerswell_raw))
  df_combined_raw <- bind_rows(df_local_raw |> select(all_of(common_cols)), df_kerswell_raw |> select(all_of(common_cols)))

  if (save_csv && !is.null(csv_path_raw)) {
    if (force_rewrite || !file.exists(csv_path_raw)) {
      df_combined_raw |>
        apply_neat_formats() |>
        write_csv(csv_path_raw)
    }
  }

  df_local_filtered <- df_local_raw |>
    filter(transition == "660") |>
    filter((str_detect(model_id, "plume") & timestep == 50) | (str_detect(model_id, "slab") & timestep == 100))

  df_kerswell_filtered <- df_kerswell_raw |>
    filter(B_factor == 4) |>
    filter(timestep == 10)

  df_filtered_final <- bind_rows(
    df_local_filtered |> select(all_of(common_cols)),
    df_kerswell_filtered |> select(all_of(common_cols))
  )

  if (save_csv && !is.null(csv_path_filtered)) {
    if (force_rewrite || !file.exists(csv_path_filtered)) {
      df_filtered_final |>
        apply_neat_formats() |>
        write_csv(csv_path_filtered)
    }
  }

  df_filtered_final
}

calculate_tile_boundaries <- function(data_frame) {
  z_unique <- sort(unique(data_frame$z_ri_ps))
  z_boundaries <- c(
    z_unique[1] / sqrt(z_unique[2] / z_unique[1]),
    sqrt(z_unique[-length(z_unique)] * z_unique[-1]),
    z_unique[length(z_unique)] * sqrt(z_unique[length(z_unique)] / z_unique[length(z_unique) - 1])
  )
  z_factor_map <- data.frame(
    z_ri_ps = z_unique,
    xmin = z_boundaries[-length(z_boundaries)],
    xmax = z_boundaries[-1]
  )
  data_frame |> left_join(z_factor_map, by = "z_ri_ps")
}

assign_regimes <- function(df) {
  df_tiled <- calculate_tile_boundaries(df)

  x_min_global <- min(df_tiled$xmin, na.rm = TRUE)
  x_max_global <- max(df_tiled$xmax, na.rm = TRUE)

  find_crossing <- function(z, r, threshold, mode = c("nearest", "left", "right")) {
    mode <- match.arg(mode)

    idx <- which(diff(sign(r - threshold)) != 0)
    if (length(idx) == 0) {
      return(NA_real_)
    }

    i <- idx[1]

    z1 <- z[i]
    z2 <- z[i + 1]
    r1 <- r[i]
    r2 <- r[i + 1]

    if (mode == "left") {
      z1
    } else if (mode == "right") {
      z2
    } else {
      if (abs(r1 - threshold) <= abs(r2 - threshold)) {
        z1
      } else {
        z2
      }
    }
  }

  scenario_thresholds <- df |>
    arrange(scenario, z_ri_ps) |>
    group_by(scenario) |>
    summarize(
      x_trans_1_2 = {
        in_regime_1 <- as.numeric(
          characteristic_length_scale <= characteristic_length_scale_quasi_eq_660 &
            max_velocity_vertical > max_velocity_vertical_stagnation_660
        )
        find_crossing(z_ri_ps, in_regime_1, 0.5, "nearest")
      },
      x_trans_2_3 = find_crossing(
        z_ri_ps,
        max_velocity_vertical,
        max_velocity_vertical_stagnation_660,
        "nearest"
      ),
      .groups = "drop"
    )

  scenario_thresholds <- scenario_thresholds |>
    left_join(
      df_tiled |> select(scenario, xmin, xmax),
      by = "scenario"
    ) |>
    group_by(scenario) |>
    mutate(
      x_trans_1_2 = {
        idx <- which(xmin <= x_trans_1_2 & xmax >= x_trans_1_2)
        if (length(idx)) xmin[idx[1]] else NA_real_
      },
      x_trans_2_3 = {
        idx <- which(xmin <= x_trans_2_3 & xmax >= x_trans_2_3)
        if (length(idx)) xmin[idx[1]] else NA_real_
      }
    ) |>
    distinct(scenario, x_trans_1_2, x_trans_2_3) |>
    ungroup() |>
    mutate(
      is_inverted = !is.na(x_trans_1_2) &
        !is.na(x_trans_2_3) &
        (x_trans_2_3 > x_trans_1_2),
      x_trans_1_2 = ifelse(is_inverted, NA_real_, x_trans_1_2),
      x_trans_2_3 = ifelse(is_inverted, NA_real_, x_trans_2_3)
    ) |>
    select(-is_inverted) |>
    mutate(
      x_trans_1_2 = ifelse(is.na(x_trans_1_2), x_max_global, x_trans_1_2),
      x_trans_2_3 = ifelse(is.na(x_trans_2_3) & scenario > 0, x_min_global, x_trans_2_3),
      x_trans_2_3 = ifelse(is.na(x_trans_2_3) & scenario == 0, x_max_global, x_trans_2_3)
    )

  df_tiled <- df_tiled |>
    left_join(
      scenario_thresholds |> select(scenario, x_trans_1_2, x_trans_2_3),
      by = "scenario"
    ) |>
    mutate(regime = case_when(xmin >= x_trans_1_2 ~ 1L, xmin >= x_trans_2_3 ~ 2L, TRUE ~ 3L))

  list(df_tiled = df_tiled, scenario_thresholds = scenario_thresholds)
}

max_velocity_vertical_stagnation_660 <- 5e-1
characteristic_length_scale_quasi_eq_660 <- 5
rxn_rate_stagnation_410 <- 6.76e-2
rxn_rate_quasi_eq_410 <- 2.14e0

visualize_composition <- function(data_dir, out_path, csv_path_raw = NULL, csv_path_filtered = NULL, save_csv = FALSE,
                                  force_rewrite = TRUE, by_suite = FALSE) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  # data_dir may be a single suite dir or c(warm-sluggish dir, cold-nominal dir) for merged figures.
  in_locals <- file.path(data_dir, "structure-summary-local.csv")
  if (any(!file.exists(in_locals))) {
    log_error(paste("missing mesh output:", paste(in_locals[!file.exists(in_locals)], collapse = ", "), "(run meshes first)"))
    return(invisible())
  }

  df_combined <- process_and_combine_data(
    in_locals,
    file.path(data_dir[1], "structure-summary-kerswell-et-al-2026.csv"),
    csv_path_raw,
    csv_path_filtered,
    save_csv,
    force_rewrite
  )

  if (by_suite) {
    df_combined <- df_combined |> mutate(suite = case_when(
      str_detect(model_id, fixed("Temp10e+02")) ~ "cold-nominal (1000 K anomaly)",
      str_detect(model_id, fixed("Temp5e+02")) ~ "warm-sluggish (500 K anomaly)",
      TRUE ~ "410 archive"
    ))
  }

  df_slab <- df_combined |> filter(str_detect(model_id, "slab"))
  df_plume <- df_combined |> filter(str_detect(model_id, "plume"))

  lim_w <- c(0, 160)
  lim_d <- range(df_combined$displacement, na.rm = TRUE)
  lim_r_plume <- range(df_plume$max_reaction_rate, na.rm = TRUE)
  lim_r_slab <- range(df_slab$max_reaction_rate, na.rm = TRUE)
  lim_r <- range(df_combined$max_reaction_rate, na.rm = TRUE)

  plume_breaks_rxn <- c(1e-1, 1e1, 1e3, 1e5)
  # Shared across panels so patchwork guides="collect" sees identical guides.
  rxn_labeller <- label_log()

  suite_pal <- c("warm-sluggish (500 K anomaly)" = "#E41A1C", "cold-nominal (1000 K anomaly)" = "#377EB8", "410 archive" = "grey60")

  p_scatter <- function(data, y_var, y_label, title = "", show_x = TRUE, show_y = TRUE, show_legend = FALSE) {
    # Merged figures drop the alpha mapping (transition already reads through
    # shape); per-suite figures keep the established mappings untouched.
    point_aes <- if (by_suite) {
      aes(shape = factor(transition), color = factor(suite), fill = max_reaction_rate)
    } else {
      aes(shape = factor(transition), alpha = factor(transition), color = factor(transition), fill = max_reaction_rate)
    }
    p <- ggplot(data, aes(x = max_reaction_rate, y = !!sym(y_var))) +
      geom_point(
        point_aes,
        size = 2.5, stroke = if (by_suite) 0.8 else 0.5, show.legend = show_legend
      ) +
      annotation_logticks(sides = "b", linewidth = 0.2) +
      scale_shape_manual(values = c("410" = 21, "660" = 24)) +
      (if (by_suite) scale_color_manual(values = suite_pal, drop = FALSE) else scale_color_manual(values = c("410" = "white", "660" = "black"))) +
      (if (by_suite) NULL else scale_alpha_manual(values = c("410" = 0.8, "660" = 1))) +
      scale_fill_viridis_c(
        name = bquote(dot(italic(X))["max"] * " (" * Ma^-1 * ")"),
        trans = "log10", option = "plasma", breaks = plume_breaks_rxn, labels = rxn_labeller, limits = lim_r
      ) +
      guides(shape = guide_legend(override.aes = list(stroke = 0.6, fill = viridis_pal(option = "plasma")(12)[1]))) +
      labs(title = title, y = y_label, x = bquote("Max " * italic(dot(X)) * " (Ma"^-1 * ")"),
        shape = if (by_suite) "Transition" else NULL, color = if (by_suite) "Suite" else NULL, fill = NULL, alpha = NULL) +
      theme_bw(base_size = 14) +
      theme_1()

    if (!show_x) p <- p + theme(axis.text.x = element_blank(), axis.title.x = element_blank())
    if (!show_y) p <- p + theme(axis.text.y = element_blank(), axis.title.y = element_blank())
    p
  }

  # Per-suite figures keep legends inside the top-left panel. Merged figures draw
  # legends once, on the slab-displacement panel only, stacked vertically below
  # it (guide collection is unreliable for these layered scales in this
  # environment, so every other panel hides its legends).
  lg_tl <- TRUE
  lg_tr <- FALSE
  lg_bl <- FALSE
  lg_br <- FALSE
  if (by_suite) {
    lg_tl <- FALSE
    lg_tr <- FALSE
    lg_bl <- FALSE
    lg_br <- TRUE
  }

  p0 <-
    (p_scatter(df_plume, "width", "Width (km)", "Plumes", FALSE, TRUE, lg_tl) +
      scale_x_log10(labels = rxn_labeller, limits = lim_r_plume) +
      scale_y_continuous(limits = lim_w)
    ) |
      (p_scatter(df_slab, "width", NULL, "Slabs", FALSE, FALSE, lg_tr) +
        scale_x_log10(labels = rxn_labeller, limits = lim_r_slab) +
        scale_y_continuous(limits = lim_w)
      )

  p1 <-
    (p_scatter(df_plume, "displacement", "Displacement (km)", "", TRUE, TRUE, lg_bl) +
      scale_x_log10(labels = rxn_labeller, limits = lim_r_plume) +
      scale_y_reverse(limits = lim_d)
    ) |
      (p_scatter(df_slab, "displacement", NULL, "", TRUE, FALSE, lg_br) +
        scale_x_log10(labels = rxn_labeller, limits = lim_r_slab) +
        scale_y_reverse(limits = lim_d)
      )
  p <- p0 / p1

  if (by_suite) {
    p <- p & theme(legend.position = "bottom", legend.justification = "left",
      legend.box = "vertical", legend.direction = "vertical",
      legend.margin = margin(0, 0, 0, 0), legend.box.margin = margin(0, 0, 0, 0),
      legend.text = element_text(size = 10))
  }

  ggsave(out_path, plot = p, width = 4.5, height = if (by_suite) 5.5 else 4.5, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

SUITE_LAB_WARM_SLUGGISH <- "Warm Sluggish Kinetics"
SUITE_LAB_COLD_NOMINAL <- "Cold Nominal Kinetics"
SUITE_PAL_SPLIT <- c("Warm Sluggish Kinetics" = "#E41A1C", "Cold Nominal Kinetics" = "#377EB8", "T1-T4" = "black")
SUITE_SHAPES_SPLIT <- c("Warm Sluggish Kinetics" = 16, "Cold Nominal Kinetics" = 16, "T1-T4" = 1)
RATE_BREAKS_SPLIT <- c(1e-1, 1e1, 1e3, 1e5, 1e7, 1e9)

read_split_data <- function(in_locals, split_csv) {
  # Slab 660 traces at the analysis timestep joined to the Python
  # thermal-kinetic split (simulation/data/combined/thermal-kinetic-split.csv).
  if (!file.exists(split_csv)) {
    log_error(paste("missing split output:", split_csv, "(run `make -C python split` first)"))
    return(invisible())
  }
  df_local <- read_local_data(in_locals) |>
    filter(transition == "660", str_detect(model_id, "slab"), timestep == 100) |>
    mutate(model_id_key = model_id)
  df_split <- suppressWarnings(read_csv(split_csv, show_col_types = FALSE)) |>
    mutate(model_id_key = str_replace_all(model_id, "_", "-")) |>
    rename(split_model_id = model_id) |>
    select(-any_of("scenario"))
  df_local |>
    left_join(df_split, by = "model_id_key") |>
    mutate(suite = factor(case_when(
      is_T ~ "T1-T4",
      str_detect(model_id, fixed("Temp10e+02")) ~ SUITE_LAB_COLD_NOMINAL,
      TRUE ~ SUITE_LAB_WARM_SLUGGISH
    ), levels = c(SUITE_LAB_WARM_SLUGGISH, SUITE_LAB_COLD_NOMINAL, "T1-T4")))
}

contrib_point <- function(data, y_var, y_label, show_x = TRUE, show_legend = FALSE) {
  ggplot(data, aes(x = rate660, y = !!sym(y_var))) +
    geom_point(aes(color = suite, shape = suite, size = width660_km),
      alpha = 0.8, stroke = 0.6, show.legend = show_legend) +
    annotation_logticks(sides = "b", linewidth = 0.2) +
    scale_shape_manual(values = SUITE_SHAPES_SPLIT, drop = FALSE) +
    scale_color_manual(values = SUITE_PAL_SPLIT, drop = FALSE) +
    scale_size_continuous(range = c(1, 6)) +
    guides(size = "none") +
    scale_x_log10(labels = label_log(), limits = c(2e-2, 5e9), breaks = RATE_BREAKS_SPLIT) +
    scale_y_continuous(limits = c(0, 70), breaks = c(0, 20, 40, 60)) +
    labs(y = y_label, x = expression("Max Reaction Rate (" * Ma^-1 * ")"),
      color = NULL, shape = NULL, size = NULL) +
    theme_bw(base_size = 14) +
    theme_1() +
    theme(legend.frame = element_blank(), legend.background = element_blank())
}

visualize_contributions <- function(in_locals, split_csv, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }
  df <- read_split_data(in_locals, split_csv)
  p_left <- contrib_point(df, "kin660_km", "Kinetic Contribution (km)", show_legend = TRUE)
  p_right <- contrib_point(df, "therm660_km", "Thermal Contribution (km)") +
    theme(legend.position = "none")
  p <- p_left | p_right
  p <- p & theme(legend.position = "bottom", legend.justification = "left",
    legend.box = "vertical", legend.direction = "vertical",
    legend.margin = margin(0, 0, 0, 0), legend.box.margin = margin(0, 0, 0, 0),
    legend.text = element_text(size = 10))
  ggsave(out_path, plot = p, width = 7.0, height = 3.2, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

tile_rate_panel <- function(data, fill_var, fill_lab, palette, breaks, trans = "identity") {
  p <- ggplot(data, aes(x = rate660, y = scen_plot)) +
    geom_point(aes(fill = !!sym(fill_var)), shape = 22, size = 3.8,
      color = "white", stroke = 0.4) +
    geom_hline(yintercept = 7.5, linetype = "dashed", linewidth = 0.5, color = "black") +
    annotation_logticks(sides = "b", linewidth = 0.2) +
    scale_x_log10(labels = label_log(), limits = c(2e-2, 5e9), breaks = RATE_BREAKS_SPLIT) +
    scale_y_continuous(breaks = seq(0, 18, 2), limits = c(-0.7, 19.7)) +
    labs(x = expression("Max Reaction Rate (" * Ma^-1 * ")"), y = "Scenario", fill = fill_lab) +
    theme_bw(base_size = 14) +
    theme_2()
  if (trans == "log10") {
    p <- p + scale_fill_viridis_c(trans = "log10", option = palette,
      breaks = breaks, labels = label_log())
  } else {
    p <- p + scale_fill_viridis_c(option = palette, breaks = breaks)
  }
  p + guides(fill = guide_colorbar(direction = "horizontal", title.position = "top",
    barwidth = unit(5.5, "lines"), barheight = unit(0.5, "lines"))) +
    theme(legend.position = "top", legend.direction = "horizontal")
}

visualize_tiles_rate <- function(in_locals, split_csv, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }
  df <- read_split_data(in_locals, split_csv) |>
    mutate(scen_plot = scenario)
  p0 <- tile_rate_panel(df, "disp660_km", "Displacement (km)", "plasma", c(20, 40, 60, 80)) +
    theme(axis.text.x = element_blank(), axis.title.x = element_blank())
  p1 <- tile_rate_panel(df, "width660_km", "Width (km)", "viridis", c(10, 20, 30)) +
    theme(axis.text.x = element_blank(), axis.title.x = element_blank(),
      axis.text.y = element_blank(), axis.title.y = element_blank())
  p2 <- tile_rate_panel(df, "vmax660", "Descent Rate (cm/yr)", "cividis", c(0, 2, 4, 6)) +
    annotate("label", x = 2.2e-2, y = 1.0, label = SUITE_LAB_WARM_SLUGGISH, hjust = 0, size = 3,
      fill = "white") +
    annotate("label", x = 2.2e-2, y = 17.0, label = SUITE_LAB_COLD_NOMINAL, hjust = 0, size = 3,
      fill = "white")
  p3 <- tile_rate_panel(df, "L_km", "L (km)", "inferno", c(1e-4, 1e-1, 1e2), trans = "log10") +
    theme(axis.text.y = element_blank(), axis.title.y = element_blank())
  p <- (p0 | p1) / (p2 | p3)
  ggsave(out_path, plot = p, width = 7.0, height = 6.4, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

visualize_regime_joint <- function(in_locals, split_csv, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }
  df <- read_split_data(in_locals, split_csv)
  tag_df <- df |> filter(is_T) |> mutate(tag = case_when(
    str_detect(model_id, "Zol3.0e0") & str_detect(model_id, "Vel20e-02") ~ "T1",
    str_detect(model_id, "Vel5e-02") & str_detect(model_id, "Zol3.0e0") ~ "T2",
    str_detect(model_id, "Zol7.0e0") & str_detect(model_id, "Vel20e-02") ~ "T3",
    TRUE ~ "T4"))
  p_left <- ggplot(df, aes(x = L_km, y = vmax660)) +
    geom_point(aes(color = suite, shape = suite), size = 2.5, alpha = 0.8,
      stroke = 0.6) +
    annotation_logticks(sides = "b", linewidth = 0.2) +
    geom_vline(xintercept = 5, linetype = "dashed", linewidth = 0.5) +
    geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.5) +
    annotate("text", x = 1e-2, y = 6.3, label = "(1)", fontface = "bold", size = 5) +
    annotate("text", x = 30, y = 4.2, label = "(2)", fontface = "bold", size = 5) +
    annotate("text", x = 30, y = 0.22, label = "(3)", fontface = "bold", size = 5) +
    scale_shape_manual(values = SUITE_SHAPES_SPLIT, drop = FALSE) +
    scale_color_manual(values = SUITE_PAL_SPLIT, drop = FALSE) +
    scale_x_log10(labels = label_log(), breaks = c(1e-6, 1e-3, 1e0, 1e2)) +
    scale_y_continuous(breaks = c(0, 2, 4, 6)) +
    labs(x = "Reaction Length Scale L (km)", y = "Descent Rate (cm/yr)",
      color = NULL, shape = NULL) +
    theme_bw(base_size = 14) +
    theme_1() +
    theme(legend.frame = element_blank(), legend.background = element_blank(),
      legend.position = "bottom", legend.justification = "left",
      legend.box = "vertical", legend.direction = "vertical",
      legend.margin = margin(0, 0, 0, 0), legend.box.margin = margin(0, 0, 0, 0),
      legend.text = element_text(size = 10))
  p_right <- ggplot(df, aes(x = kin410_km, y = kin660_km)) +
    geom_point(aes(color = suite, shape = suite, size = width660_km),
      alpha = 0.8, stroke = 0.6) +
    geom_text(data = tag_df, aes(label = tag), nudge_x = 1.2, nudge_y = 0.4, size = 3.5) +
    scale_shape_manual(values = SUITE_SHAPES_SPLIT, drop = FALSE) +
    scale_color_manual(values = SUITE_PAL_SPLIT, drop = FALSE) +
    scale_size_continuous(range = c(1, 6)) +
    scale_x_continuous(breaks = c(0, 10, 20, 30, 40, 50)) +
    scale_y_continuous(breaks = c(0, 20, 40, 60)) +
    labs(x = "410 Kinetic Contribution (km)", y = "660 Kinetic Contribution (km)",
      color = NULL, shape = NULL, size = NULL) +
    theme_bw(base_size = 14) +
    theme_1() +
    theme(legend.position = "none", legend.frame = element_blank())
  p <- p_left | p_right
  ggsave(out_path, plot = p, width = 7.0, height = 3.2, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

visualize_tiles <- function(in_path, out_path, height = 5.0) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  # in_path may be a single local CSV or a vector (merged suite tiles share
  # one log-Z axis; the gap between suites shows as stretched edge tiles).
  if (any(!file.exists(in_path))) {
    log_error(paste("missing mesh output:", paste(in_path[!file.exists(in_path)], collapse = ", "), "(run meshes first)"))
    return(invisible())
  }

  df <- read_local_data(in_path) |>
    filter(transition == "660") |>
    filter((str_detect(model_id, "slab") & timestep == 100)) |>
    mutate(characteristic_length_scale = max_velocity_vertical / max_reaction_rate * 10)

  regime_data <- assign_regimes(df)
  df_tiled <- regime_data$df_tiled
  scenario_thresholds <- regime_data$scenario_thresholds

  v_bounds <- scenario_thresholds |>
    pivot_longer(cols = c(x_trans_1_2, x_trans_2_3), names_to = "type", values_to = "x_val") |>
    filter(!is.na(x_val))

  h_conns <- scenario_thresholds |>
    arrange(scenario) |>
    pivot_longer(cols = c(x_trans_1_2, x_trans_2_3), names_to = "type", values_to = "x") |>
    group_by(type) |>
    mutate(xend = lead(x), y = scenario + 0.5, yend = y) |>
    ungroup() |>
    filter(!is.na(x) & !is.na(xend))

  label_df <- scenario_thresholds |>
    filter(scenario == 1) |>
    mutate(
      x_min = min(df_tiled$xmin, na.rm = TRUE),
      x_max = max(df_tiled$xmax, na.rm = TRUE)
    ) |>
    transmute(
      scenario,
      x_mid_3 = sqrt(x_min * x_trans_2_3),
      x_mid_2 = sqrt(x_trans_2_3 * x_trans_1_2),
      x_mid_1 = sqrt(x_trans_1_2 * x_max) + (sqrt(x_trans_1_2 * x_max) * 1.6)
    ) |>
    pivot_longer(
      cols = starts_with("x_mid"),
      names_to = "regime",
      values_to = "x"
    ) |>
    mutate(
      regime = as.integer(sub("x_mid_", "", regime)),
      y = ifelse(str_detect(regime, "3"), scenario, ifelse(str_detect(regime, "1"), scenario + 3, scenario + 4)),
      label = paste0("(", regime, ")")
    )

  p_tile <- function(data, fill_var, fill_lab, label_regimes = FALSE, palette = "viridis", log10_cbar = FALSE, rev = 1, lab_color = "black") {
    p <- ggplot(data, aes(xmin = xmin, xmax = xmax, ymin = scenario - 0.5, ymax = scenario + 0.5)) +
      geom_rect(aes(fill = !!sym(fill_var))) +
      geom_segment(
        data = v_bounds, aes(x = x_val, xend = x_val, y = scenario - 0.5, yend = scenario + 0.5),
        color = lab_color, linewidth = 0.5, inherit.aes = FALSE
      ) +
      geom_segment(
        data = h_conns, aes(x = x, xend = xend, y = y, yend = yend),
        color = lab_color, linewidth = 0.5, inherit.aes = FALSE
      ) +
      coord_cartesian(clip = "off") +
      scale_x_log10(labels = label_log(), expand = expansion(mult = 0, add = 0)) +
      scale_y_continuous(breaks = sort(unique(data$scenario)), expand = c(0, 0)) +
      labs(x = bquote("Z"["ri"] * " (" * mol^2 * J^-2 * s^-1 * ")"), y = "Scenario", fill = fill_lab) +
      theme_bw(base_size = 14) +
      theme_2()

    if (label_regimes) {
      p <- p + geom_text(data = label_df, aes(x = x, y = y, label = label), inherit.aes = FALSE, size = 4, fontface = "bold", color = lab_color)
    }

    if (log10_cbar) {
      p <- p + scale_fill_viridis_c(trans = "log10", option = palette, labels = label_log(), direction = rev)
    } else {
      p <- p + scale_fill_viridis_c(option = palette, direction = rev)
    }
    p
  }

  p0 <- p_tile(df_tiled, "max_reaction_rate", bquote("Max " * italic(dot(X)) * " (Ma"^-1 * ")"), FALSE, "viridis", log10_cbar = TRUE, lab_color = "white") +
    theme(axis.text.x = element_blank(), axis.title.x = element_blank())
  p1 <- p_tile(df_tiled, "displacement", "Displacement (km)", FALSE, "rocket", rev = -1) +
    theme(axis.text.y = element_blank(), axis.title.y = element_blank())
  p2 <- p_tile(df_tiled, "width", "Width (km)", FALSE, "mako", rev = -1)
  p3 <- p_tile(df_tiled, "max_velocity_vertical", bquote("Max " * italic(v)[max] * " (cm/yr)"), TRUE, "magma", lab_color = "white") +
    theme(axis.text = element_blank(), axis.title = element_blank())

  p <- (p0 | p3) / (p2 | p1)
  suppressWarnings(ggsave(out_path, plot = p, width = 4.5, height = height, dpi = 300, bg = "white"))
  log_artifact(out_path)
}

theme_1 <- function() {
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    plot.margin = margin(5, 5, 5, 5),
    plot.title = element_text(hjust = 0.5, size = 12),
    plot.tag.location = "panel",
    plot.tag.position = "topleft",
    plot.tag = element_text(size = 18, margin = margin(5, 0, 0, 0), hjust = 0, color = "black", face = "bold"),
    axis.ticks = element_blank(),
    legend.justification = "left",
    legend.position = "inside",
    legend.position.inside = c(0.07, 0.62),
    legend.spacing.y = unit(1.5, "lines"),
    legend.direction = "horizontal",
    legend.key.height = unit(0.6, "lines"),
    legend.key.width = unit(1.2, "lines"),
    legend.ticks = element_line(color = "black", linewidth = 0.4),
    legend.ticks.length = unit(0.1, "lines"),
    legend.frame = element_rect(color = "black", linewidth = 0.4),
    legend.box = "vertical",
    legend.box.just = "left",
    legend.box.spacing = unit(0.1, "lines"),
    legend.box.margin = margin(),
    legend.margin = margin(-13, 0, 0, 0),
    legend.title = element_text(hjust = 0, vjust = 0, size = 12, margin = margin(0, 0, 5, 0)),
    legend.title.position = "top",
    legend.text = element_text(size = 11, margin = margin(2, 0, 0, 0)),
    legend.background = element_blank()
  )
}

theme_2 <- function() {
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    plot.margin = margin(2, 5, 2, 5),
    plot.title = element_text(siz = 14, hjust = 0.5),
    plot.tag.location = "panel",
    plot.tag.position = "topleft",
    plot.tag = element_text(size = 18, margin = margin(5, 0, 0, 0), hjust = 0, color = "black", face = "bold"),
    axis.ticks = element_blank(),
    legend.position = "top",
    legend.direction = "horizontal",
    legend.key.height = unit(0.6, "lines"),
    legend.key.width = unit(1.2, "lines"),
    legend.ticks = element_line(color = "black", linewidth = 0.4),
    legend.ticks.length = unit(0.1, "lines"),
    legend.frame = element_rect(color = "black", linewidth = 0.4),
    legend.box.spacing = unit(0.1, "lines"),
    legend.box.margin = margin(),
    legend.margin = margin(0, 0, 0, 0),
    legend.title = element_text(hjust = 0.5, vjust = 0, size = 10, margin = margin(0, 0, 5, 0)),
    legend.title.position = "top",
    legend.text = element_text(size = 11, margin = margin(2, 0, 0, 0)),
    legend.background = element_blank()
  )
}
