SUITE_LAB_SW_SUITE <- "SW suite"
SUITE_LAB_NC_SUITE <- "NC suite"
SUITE_PAL_SPLIT <- c("SW suite" = "#E41A1C", "NC suite" = "#377EB8")
SUITE_SHAPES_SPLIT <- c("SW suite" = 21, "NC suite" = 21)
RATE_BREAKS_SPLIT <- c(1e-1, 1e1, 1e3, 1e5, 1e7, 1e9)

read_postprocessed_data <- function(in_locals, postprocessed_csv, include_T = FALSE) {
  # Slab 660 traces at the analysis timestep from the Python
  # postprocessed table (simulation/data/postprocessed.csv).
  if (!file.exists(postprocessed_csv)) {
    log_error(paste("missing postprocessed output:", postprocessed_csv, "(run `make -C python postprocess` first)"))
    return(invisible())
  }
  df_post <- suppressWarnings(read_csv(postprocessed_csv, show_col_types = FALSE))
  if (!include_T) {
    df_post <- df_post |> filter(!is_T)
  }
  df_post <- df_post |>
    mutate(
      model_id = str_replace_all(model_id, "_", "-"),
      suite = factor(case_when(
        str_detect(model_id, fixed("Temp10e+02")) ~ SUITE_LAB_NC_SUITE,
        TRUE ~ SUITE_LAB_SW_SUITE
      ), levels = c(SUITE_LAB_SW_SUITE, SUITE_LAB_NC_SUITE))
    )
  df_post
}

contrib_point <- function(data, y_var, y_label, show_x = TRUE, show_legend = FALSE) {
  ggplot(data, aes(x = rate660, y = !!sym(y_var))) +
    geom_point(aes(fill = suite, shape = suite, size = width660_km), alpha = 0.8, stroke = 0.5, show.legend = show_legend) +
    annotation_logticks(sides = "b", linewidth = 0.2) +
    scale_shape_manual(values = SUITE_SHAPES_SPLIT, drop = FALSE) +
    scale_fill_manual(values = SUITE_PAL_SPLIT, drop = FALSE) +
    scale_size_continuous(range = c(0.2, 6)) +
    guides(
      size = "none",
      # fill and shape map the same variable and merge into one legend: a
      # single override.aes suffices (a second one warns as Duplicated).
      fill = guide_legend(override.aes = list(size = 3.5, alpha = 1)),
      shape = guide_legend()
    ) +
    scale_x_log10(labels = label_log(), limits = c(2e-2, 5e9), breaks = RATE_BREAKS_SPLIT) +
    scale_y_continuous(limits = c(0, 70), breaks = c(0, 20, 40, 60)) +
    labs(y = y_label, x = expression("Max Reaction Rate (" * Ma^-1 * ")"), fill = NULL, shape = NULL, size = NULL) +
    theme_bw(base_size = 16) +
    theme_1() +
    theme(legend.direction = "vertical", legend.position.inside = c(0.05, 0.85))
}

regime_panel <- function(data, show_legend = FALSE) {
  ggplot(data, aes(x = L_km, y = vmax660)) +
    geom_point(aes(fill = suite, shape = suite, size = width660_km), alpha = 0.8, stroke = 0.5, show.legend = show_legend) +
    annotation_logticks(sides = "b", linewidth = 0.2) +
    geom_vline(xintercept = 5, linetype = "dashed", linewidth = 0.5) +
    geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 0.5) +
    annotate("text", x = 1e-7, y = 6.0, label = "(1)", fontface = "bold", size = 5) +
    annotate("text", x = 1.5e2, y = 6.0, label = "(2)", fontface = "bold", size = 5) +
    annotate("text", x = 1.5e2, y = -0.5, label = "(3)", fontface = "bold", size = 5) +
    scale_shape_manual(values = SUITE_SHAPES_SPLIT, drop = FALSE) +
    scale_fill_manual(values = SUITE_PAL_SPLIT, drop = FALSE) +
    scale_size_continuous(range = c(0.2, 6), guide = "none") +
    scale_x_log10(labels = label_log(), limits = c(NA, 1e3), breaks = c(1e-8, 1e-5, 1e-2, 1e1)) +
    scale_y_continuous(limits = c(-1.0, NA), breaks = c(0, 2, 4, 6)) +
    labs(x = expression("Reaction Length Scale " * italic(L) * " (km)"), y = "Descent Rate (cm/yr)", fill = NULL, shape = NULL, size = NULL) +
    theme_bw(base_size = 16) +
    theme_1()
}

visualize_contributions <- function(in_locals, postprocessed_csv, out_path, force_rewrite = FALSE) {
  if (!force_rewrite && plot_exists(out_path)) {
    return(invisible())
  }
  ensure_output_dir(out_path)
  df <- read_postprocessed_data(in_locals, postprocessed_csv, include_T = FALSE)
  p_regime <- regime_panel(df, show_legend = FALSE)
  p_kin <- contrib_point(df, "kin660_km", "Kinetic Contribution (km)", show_legend = FALSE)
  p_therm <- contrib_point(df, "therm660_km", "Thermal Contribution (km)", show_legend = TRUE)
  p <- p_regime | p_kin | p_therm
  ggsave(out_path, plot = p, width = 9.8, height = 3.5, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

visualize_interactions_quantitative <- function(in_locals, postprocessed_csv, out_path, force_rewrite = FALSE) {
  if (!force_rewrite && plot_exists(out_path)) {
    return(invisible())
  }
  ensure_output_dir(out_path)
  df <- read_postprocessed_data(in_locals, postprocessed_csv, include_T = FALSE) |>
    mutate(
      vel_cm = round(prescribed_velocity * 100),
      kin_rheo_label = factor(
        case_when(
          vel_cm == 5 & eta_therm == 5 ~ "u_in = 5 cm/yr, B = 5 (S: 0, 4, 8, 12)",
          vel_cm == 5 & eta_therm == 10 ~ "u_in = 5 cm/yr, B = 10 (S: 1, 5, 9, 13)",
          vel_cm == 10 & eta_therm == 5 ~ "u_in = 10 cm/yr, B = 5 (S: 2, 6, 10, 14)",
          vel_cm == 10 & eta_therm == 10 ~ "u_in = 10 cm/yr, B = 10 (S: 3, 7, 11, 15)"
        ),
        levels = c(
          "u_in = 5 cm/yr, B = 5 (S: 0, 4, 8, 12)",
          "u_in = 5 cm/yr, B = 10 (S: 1, 5, 9, 13)",
          "u_in = 10 cm/yr, B = 5 (S: 2, 6, 10, 14)",
          "u_in = 10 cm/yr, B = 10 (S: 3, 7, 11, 15)"
        )
      ),
      b_label = factor(
        ifelse(eta_trans_ri_ps == 1, "b = 1 (no jump: S: 4-7, 12-15)", "b = 50 (50x jump: S: 0-3, 8-11)"),
        levels = c("b = 1 (no jump: S: 4-7, 12-15)", "b = 50 (50x jump: S: 0-3, 8-11)")
      )
    )

  pal_kr <- c(
    "u_in = 5 cm/yr, B = 5 (S: 0, 4, 8, 12)" = "#4393C3",
    "u_in = 5 cm/yr, B = 10 (S: 1, 5, 9, 13)" = "#2166AC",
    "u_in = 10 cm/yr, B = 5 (S: 2, 6, 10, 14)" = "#F46D43",
    "u_in = 10 cm/yr, B = 10 (S: 3, 7, 11, 15)" = "#B2182B"
  )
  shapes_kr <- c(
    "u_in = 5 cm/yr, B = 5 (S: 0, 4, 8, 12)" = 21,
    "u_in = 5 cm/yr, B = 10 (S: 1, 5, 9, 13)" = 22,
    "u_in = 10 cm/yr, B = 5 (S: 2, 6, 10, 14)" = 23,
    "u_in = 10 cm/yr, B = 10 (S: 3, 7, 11, 15)" = 24
  )
  lty_b <- c("b = 1 (no jump: S: 4-7, 12-15)" = "solid", "b = 50 (50x jump: S: 0-3, 8-11)" = "22")

  df_sw <- df |> filter(suite == SUITE_LAB_SW_SUITE)
  df_nc <- df |> filter(suite == SUITE_LAB_NC_SUITE)

  z_breaks_sw <- c(1e-10, 1e-8, 1e-6)
  z_breaks_nc <- c(1e-2, 1e0, 1e2)

  make_panel <- function(sub_df, y_var, y_lab, y_lim, y_breaks, z_breaks, title = NULL,
                         show_x = FALSE, show_y = TRUE, add_stag = FALSE) {
    p <- ggplot(sub_df, aes(x = z_ri_ps, y = !!sym(y_var), group = scenario))
    if (add_stag) {
      # Pin the stagnation band to the panel edges. xmin = 0 warns (log10(0)
      # is -Inf) and xmin = -Inf warns (log(-Inf) is NaN), so use the finite
      # data minimum instead: annotate layers don't train scales, so the view
      # limits are unchanged and the band covers every data point.
      x_lo <- min(sub_df$z_ri_ps, na.rm = TRUE)
      p <- p +
        annotate("rect", xmin = x_lo, xmax = Inf,
                 ymin = -Inf, ymax = 0.5, fill = "grey75", alpha = 0.7) +
        geom_hline(yintercept = 0.5, linetype = "dashed", linewidth = 1.0, color = "grey20")
    }
    p <- p +
      geom_line(aes(color = kin_rheo_label, linetype = b_label), linewidth = 0.85, alpha = 0.9) +
      geom_point(aes(fill = kin_rheo_label, shape = kin_rheo_label), color = "black", size = 2.8, stroke = 0.4, alpha = 0.95) +
      annotation_logticks(sides = "b", linewidth = 0.2) +
      scale_x_log10(labels = label_log(), breaks = z_breaks) +
      scale_y_continuous(limits = y_lim, breaks = y_breaks) +
      scale_color_manual(values = pal_kr, name = "Kinematics & Rheological Strength") +
      scale_fill_manual(values = pal_kr, name = "Kinematics & Rheological Strength") +
      scale_shape_manual(values = shapes_kr, name = "Kinematics & Rheological Strength") +
      scale_linetype_manual(values = lty_b, name = "Viscosity Jump") +
      guides(
        color = guide_legend(nrow = 4, byrow = TRUE, order = 1),
        fill = guide_legend(nrow = 4, byrow = TRUE, order = 1),
        shape = guide_legend(nrow = 4, byrow = TRUE, order = 1),
        linetype = guide_legend(nrow = 2, order = 2)
      ) +
      labs(
        title = title,
        x = if (show_x) expression(italic(Z)["ri"] * " (mol"^2 * " J"^-2 * " s"^-1 * ")") else NULL,
        y = if (show_y) y_lab else NULL
      ) +
      theme_bw(base_size = 16) +
      theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "grey92"),
        plot.title = if (!is.null(title)) element_text(hjust = 0.5, size = 14, face = "bold", margin = margin(0, 0, 6, 0)) else element_blank(),
        axis.ticks = element_blank(),
        axis.text.x = if (show_x) element_text(size = 11, color = "grey20") else element_blank(),
        axis.text.y = if (show_y) element_text(size = 11, color = "grey20") else element_blank(),
        axis.title.x = if (show_x) element_text(size = 12, margin = margin(6, 0, 0, 0)) else element_blank(),
        axis.title.y = if (show_y) element_text(size = 12, margin = margin(0, 6, 0, 0)) else element_blank(),
        plot.margin = margin(3, 5, 3, 5)
      )
    p
  }

  p1_sw <- make_panel(df_sw, "vmax660", "Descent Rate (cm/yr)", c(0, 6.8), c(0, 2, 4, 6), z_breaks_sw,
                      title = "SW suite", show_x = FALSE, show_y = TRUE, add_stag = TRUE)
  p1_nc <- make_panel(df_nc, "vmax660", NULL, c(0, 6.8), c(0, 2, 4, 6), z_breaks_nc,
                      title = "NC suite", show_x = FALSE, show_y = FALSE, add_stag = TRUE)

  p2_sw <- make_panel(df_sw, "kin660_km", expression("Kinetic " * delta * italic(z)[k] * " (km)"), c(0, 68), c(0, 20, 40, 60), z_breaks_sw,
                      show_x = FALSE, show_y = TRUE)
  p2_nc <- make_panel(df_nc, "kin660_km", NULL, c(0, 68), c(0, 20, 40, 60), z_breaks_nc,
                      show_x = FALSE, show_y = FALSE)

  p3_sw <- make_panel(df_sw, "therm660_km", expression("Thermal " * delta * italic(z)[t] * " (km)"), c(0, 68), c(0, 20, 40, 60), z_breaks_sw,
                      show_x = FALSE, show_y = TRUE)
  p3_nc <- make_panel(df_nc, "therm660_km", NULL, c(0, 68), c(0, 20, 40, 60), z_breaks_nc, show_x = FALSE, show_y = FALSE)

  p4_sw <- make_panel(df_sw, "width660_km", expression("660 Width " * delta * italic(w) * " (km)"), c(0, 36), c(0, 10, 20, 30), z_breaks_sw,
                      show_x = TRUE, show_y = TRUE)
  p4_nc <- make_panel(df_nc, "width660_km", NULL, c(0, 36), c(0, 10, 20, 30), z_breaks_nc,
                      show_x = TRUE, show_y = FALSE)

  p <- ((p1_sw | p1_nc) / (p2_sw | p2_nc) / (p3_sw | p3_nc) / (p4_sw | p4_nc)) +
    plot_layout(guides = "collect") &
    theme(
      legend.position = "right",
      legend.direction = "vertical",
      legend.box = "vertical",
      legend.margin = margin(2, 0, 0, 0),
      legend.box.margin = margin(0, 0, 0, 0),
      legend.justification = "left",
      legend.box.just = "left",
      legend.title = element_text(size = 10.5, face = "bold"),
      legend.text = element_text(size = 9.8),
      legend.key.width = unit(1.8, "lines")
    )

  ggsave(out_path, plot = p, width = 7.5, height = 8.0, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

tile_rate_panel <- function(data, fill_var, fill_lab, palette, breaks, trans = "identity", direction = 1) {
  p <- ggplot(data, aes(x = rate660, y = scen_plot)) +
    geom_point(aes(fill = !!sym(fill_var)), shape = 22, size = 4.5, color = "black", stroke = 0.5) +
    geom_hline(yintercept = c(7.5, 15.5), linetype = "dashed", linewidth = 0.8, color = "black") +
    annotation_logticks(sides = "b", linewidth = 0.2) +
    scale_x_log10(labels = label_log(), limits = c(2e-2, 5e9), breaks = RATE_BREAKS_SPLIT) +
    scale_y_continuous(breaks = seq(0, 19, 2), limits = c(-0.7, 19.7)) +
    labs(x = expression("Max Reaction Rate (" * Ma^-1 * ")"), y = "Scenario", fill = fill_lab) +
    theme_bw(base_size = 16) +
    theme_2()
  if (trans == "log10") {
    p <- p + scale_fill_viridis_c(trans = "log10", option = palette, breaks = breaks, labels = label_log(), direction = direction)
  } else {
    p <- p + scale_fill_viridis_c(option = palette, breaks = breaks, direction = direction)
  }
  p + guides(fill = guide_colorbar(direction = "horizontal", title.position = "top", barwidth = unit(6.5, "lines"), barheight = unit(0.6, "lines"))) +
    theme(legend.position = "inside", legend.justification = "right", legend.position.inside = c(0.92, 0.24), legend.direction = "horizontal")
}

visualize_tiles_rate <- function(in_locals, postprocessed_csv, out_path, force_rewrite = FALSE) {
  if (!force_rewrite && plot_exists(out_path)) {
    return(invisible())
  }
  ensure_output_dir(out_path)
  df <- read_postprocessed_data(in_locals, postprocessed_csv) |> mutate(scen_plot = scenario)
  p0 <- tile_rate_panel(df, "disp660_km", "Displacement (km)", "magma", c(30, 45, 60, 75), direction = -1) +
    theme(axis.text.x = element_blank(), axis.title.x = element_blank())
  p1 <- tile_rate_panel(df, "width660_km", "Width (km)", "mako", c(10, 20, 30), direction = -1) +
    theme(
      axis.text.x = element_blank(), axis.title.x = element_blank(),
      axis.text.y = element_blank(), axis.title.y = element_blank()
    )
  p2 <- tile_rate_panel(df, "vmax660", "Descent (cm/yr)", "cividis", c(1, 2, 3, 4, 5, 6))
  p3 <- tile_rate_panel(df, "L_km", "L (km)", "rocket", c(1e-8, 1e-5, 1e-2, 1e1), trans = "log10", direction = -1) +
    theme(axis.text.y = element_blank(), axis.title.y = element_blank())
  p <- (p0 | p1) / (p2 | p3)
  ggsave(out_path, plot = p, width = 6.5, height = 6.0, dpi = 300, bg = "white", create.dir = TRUE)
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
    plot.margin = margin(5, 5, 5, 5),
    plot.title = element_text(size = 14, hjust = 0.5),
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
    legend.title = element_text(hjust = 0.5, vjust = 0, size = 12, margin = margin(0, 0, 5, 0)),
    legend.title.position = "top",
    legend.text = element_text(size = 11, margin = margin(2, 0, 0, 0)),
    legend.background = element_blank()
  )
}
