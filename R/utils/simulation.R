#######################################################
## Helpers                                       !!! ##
#######################################################
read_kerswell_data <- function(filepath, scenario_offset = 0) {
  raw <- suppressWarnings(read_csv(filepath, show_col_types = FALSE)) |>
    mutate(scenario = as.integer(factor(B_factor)) + scenario_offset)

  raw |>
    transmute(
      model_id = str_replace_all(model_id, "_", "-"),
      scenario = scenario,
      timestep = timestep,
      z_ol_wd = Z_factor,
      z_ri_ps = NA_real_,
      displacement = displacement / 1e3,
      width = abs(width) / 1e3,
      max_reaction_rate = max_reaction_rate,
      max_velocity_vertical = max_velocity,
      transition = "410",
      Z_factor = Z_factor,
      B_factor = B_factor,
      source = "kerswell_2026"
    ) |>
    filter(is.finite(max_reaction_rate), max_reaction_rate > 0)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
read_local_data <- function(filepath) {
  raw_df <- suppressWarnings(read_csv(filepath, show_col_types = FALSE))

  extract_transition_data <- function(df, trans_label) {
    df |>
      select(model_id, scenario, timestep, z_ol_wd, z_ri_ps, contains(trans_label)) |>
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
  )
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
      cat(" -> ", csv_path_raw, "\n", sep = "")
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
      cat(" -> ", csv_path_filtered, "\n", sep = "")
    }
  }

  df_filtered_final
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

#######################################################
## Regime transition thresholds                  !!! ##
#######################################################
max_velocity_vertical_stagnation_660 <- 5e-1
characteristic_length_scale_quasi_eq_660 <- 5
rxn_rate_stagnation_410 <- 6.76e-2
rxn_rate_quasi_eq_410 <- 2.14e0

#######################################################
## Visualize                                     !!! ##
#######################################################
visualize_composition <- function(data_dir, out_path, csv_path_raw = NULL, csv_path_filtered = NULL, save_csv = FALSE, force_rewrite = TRUE) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  df_combined <- process_and_combine_data(
    file.path(data_dir, "structure-summary-local.csv"),
    file.path(data_dir, "structure-summary-kerswell-et-al-2026.csv"),
    csv_path_raw,
    csv_path_filtered,
    save_csv,
    force_rewrite
  )

  df_slab <- df_combined |> filter(str_detect(model_id, "slab"))
  df_plume <- df_combined |> filter(str_detect(model_id, "plume"))

  lim_w <- c(0, 160)
  lim_d <- range(df_combined$displacement, na.rm = TRUE)
  lim_r_plume <- range(df_plume$max_reaction_rate, na.rm = TRUE)
  lim_r_slab <- range(df_slab$max_reaction_rate, na.rm = TRUE)
  lim_r <- range(df_combined$max_reaction_rate, na.rm = TRUE)

  plume_breaks_rxn <- c(1e-1, 1e1, 1e3, 1e5)

  p_scatter <- function(data, y_var, y_label, title = "", show_x = TRUE, show_y = TRUE, show_legend = FALSE) {
    p <- ggplot(data, aes(x = max_reaction_rate, y = !!sym(y_var))) +
      geom_point(
        aes(shape = factor(transition), alpha = factor(transition), color = factor(transition), fill = max_reaction_rate),
        size = 2.5, stroke = 0.5, show.legend = show_legend
      ) +
      annotation_logticks(sides = "b", linewidth = 0.2) +
      scale_shape_manual(values = c("410" = 21, "660" = 24)) +
      scale_color_manual(values = c("410" = "white", "660" = "black")) +
      scale_alpha_manual(values = c("410" = 0.8, "660" = 1)) +
      scale_fill_viridis_c(
        name = bquote(dot(italic(X))["max"] * " (" * Ma^-1 * ")"),
        trans = "log10", option = "plasma", breaks = plume_breaks_rxn, labels = label_log(), limits = lim_r
      ) +
      guides(shape = guide_legend(override.aes = list(stroke = 0.6, fill = viridis_pal(option = "plasma")(12)[1]))) +
      labs(title = title, y = y_label, x = bquote("Max " * italic(dot(X)) * " (Ma"^-1 * ")"), shape = NULL, color = NULL, fill = NULL, alpha = NULL) +
      theme_bw(base_size = 14) +
      theme_1()

    if (!show_x) p <- p + theme(axis.text.x = element_blank(), axis.title.x = element_blank())
    if (!show_y) p <- p + theme(axis.text.y = element_blank(), axis.title.y = element_blank())
    p
  }

  p0 <-
    (p_scatter(df_plume, "width", "Width (km)", "Plumes", FALSE, TRUE, TRUE) +
      scale_x_log10(labels = label_log(), limits = lim_r_plume) +
      scale_y_continuous(limits = lim_w)
    ) |
      (p_scatter(df_slab, "width", NULL, "Slabs", FALSE, FALSE, FALSE) +
        scale_x_log10(labels = label_log(), limits = lim_r_slab) +
        scale_y_continuous(limits = lim_w)
      )

  p1 <-
    (p_scatter(df_plume, "displacement", "Displacement (km)", "", TRUE, TRUE, FALSE) +
      scale_x_log10(labels = label_log(), limits = lim_r_plume) +
      scale_y_reverse(limits = lim_d)
    ) |
      (p_scatter(df_slab, "displacement", NULL, "", TRUE, FALSE, FALSE) +
        scale_x_log10(labels = label_log(), limits = lim_r_slab) +
        scale_y_reverse(limits = lim_d)
      )
  p <- p0 / p1

  ggsave(out_path, plot = p, width = 4.5, height = 4.5, dpi = 300, bg = "white", create.dir = TRUE)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
visualize_tiles <- function(in_path, out_path) {
  if (plot_exists(out_path)) {
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
  suppressWarnings(ggsave(out_path, plot = p, width = 4.5, height = 5.0, dpi = 300, bg = "white"))
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
