# Nominal equilibrium depths (m -> km): transition depth from the Mg100
# Perple_X profile plus the ASPECT depth correction used at runtime.
NOMINAL_410_KM <- 359.2 + 5.0
NOMINAL_520_KM <- 506.2 + 5.0
NOMINAL_660_KM <- 599.7 + 15.0

read_seismic_profile <- function(filepath) {
  df <- read_csv(filepath, show_col_types = FALSE)
  fname <- basename(filepath)
  df |>
    mutate(
      model_id = fname,
      tstep = as.numeric(str_extract(fname, "(?<=_t)[0-9]+(?=_)")),
      type = if_else(str_detect(fname, "plume"), "Plume", "Slab"),
      z_ri = as.numeric(str_extract(fname, "(?<=Zri)[0-9e.+-]+")),
      depth = depth / 1e3,
      trace_x = trace_x / 1e3,
    )
}

visualize_seismic_profiles <- function(data_dir, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  file_list <- list.files(data_dir, pattern = "*.csv", full.names = TRUE)
  if (!length(file_list)) {
    log_error(paste("no seismic profiles in:", data_dir, "(run meshes first)"))
    return(invisible())
  }
  log_info(paste("Reading", length(file_list), "seismic profiles"))
  data <- map_df(file_list, read_seismic_profile)
  data_init <- data |> filter(tstep == 0)
  data <- data |> filter((str_detect(model_id, "plume") & tstep == 50) | (str_detect(model_id, "slab") & tstep == 100))

  df_plume <- data |> filter(type == "Plume")
  df_slab <- data |> filter(type == "Slab")

  lim_zri <- range(data$z_ri, na.rm = TRUE)
  lim_vp <- range(data$seismic_Vp, na.rm = TRUE)

  p_profile <- function(data, x_var, title = "", x_label = "", show_y = TRUE, show_legend = FALSE, labels = FALSE) {
    p <- ggplot(data, aes(x = !!sym(x_var), y = depth, group = model_id)) +
      geom_hline(yintercept = NOMINAL_410_KM, linetype = "dotted", linewidth = 1.2, color = "gray60") +
      geom_hline(yintercept = NOMINAL_520_KM, linetype = "dotted", linewidth = 1.2, color = "gray60") +
      geom_hline(yintercept = NOMINAL_660_KM, linetype = "dotted", linewidth = 1.2, color = "gray60") +
      geom_path(aes(color = z_ri), linewidth = 1.2, alpha = 0.8, show.legend = show_legend) +
      scale_y_reverse() +
      scale_color_continuous_sequential(
        palette = "YlOrRd",
        rev = FALSE,
        trans = "log10",
        limits = lim_zri,
        breaks = c(1e-9, 1e-7, 1e-5),
        labels = label_log()
      ) +
      labs(title = title, x = x_label, y = "Depth (km)", color = expression(Z[ri])) +
      theme_bw(base_size = 34) +
      theme_profile() +
      theme(legend.position = "inside", legend.position.inside = c(0.30, 0.85))

    if (x_var != "trace_x") {
      p <- p + geom_path(data = filter(data_init, !is.na(!!sym(x_var))), color = "black", linewidth = 1.2, show.legend = show_legend)
    }

    if (labels) {
      p <- p + list(
        annotate("text", x = 8.05, y = NOMINAL_410_KM + 45, label = "410", size = 7, hjust = 0, color = "gray30"),
        annotate("text", x = 8.05, y = NOMINAL_520_KM + 45, label = "520", size = 7, hjust = 0, color = "gray30"),
        annotate("text", x = 8.05, y = NOMINAL_660_KM + 45, label = "660", size = 7, hjust = 0, color = "gray30")
      )
    }

    if (!show_y) {
      p <- p + theme(axis.text.y = element_blank(), axis.title.y = element_blank())
    }
    p
  }

  p0 <- (
    p_profile(df_plume, "seismic_Vp", "Plumes", expression(V[p] ~ (km / s)), TRUE, TRUE, TRUE) +
      scale_x_continuous(limits = lim_vp) +
      annotate("segment", x = 9.4, xend = 9.4, y = 460, yend = 560, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
      annotate("text", x = 9.4, y = 575, label = "+T", vjust = 1, parse = TRUE, size = 8) +
      annotate("segment", x = 10.2, xend = 10.2, y = 630, yend = 730, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
      annotate("text", x = 10.2, y = 745, label = "+T", vjust = 1, parse = TRUE, size = 8) +
      annotate("segment", x = 10.8, xend = 10.8, y = 550, yend = 450, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
      annotate("text", x = 10.8, y = 445, label = "+T", vjust = 0, parse = TRUE, size = 8)
  ) |
    (
      p_profile(df_slab, "seismic_Vp", "Slabs", expression(V[p] ~ (km / s)), FALSE) +
        scale_x_continuous(limits = lim_vp) +
        annotate("segment", x = 9.3, xend = 9.3, y = 300, yend = 200, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
        annotate("text", x = 9.3, y = 195, label = "-T", vjust = 0, parse = TRUE, size = 8) +
        annotate("segment", x = 9.3, xend = 9.3, y = 400, yend = 500, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
        annotate("text", x = 9.3, y = 515, label = "-Z[ol]", vjust = 1, parse = TRUE, size = 8) +
        annotate("segment", x = 10.1, xend = 10.1, y = 430, yend = 330, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
        annotate("text", x = 10.1, y = 325, label = "-T", vjust = 0, parse = TRUE, size = 8) +
        annotate("segment", x = 10.1, xend = 10.1, y = 550, yend = 650, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
        annotate("text", x = 10.1, y = 665, label = "-Z[wd]", vjust = 1, parse = TRUE, size = 8) +
        annotate("segment", x = 10.9, xend = 10.9, y = 720, yend = 820, arrow = arrow(length = unit(0.3, "cm"), type = "closed"), linewidth = 1.2) +
        annotate("text", x = 10.9, y = 835, label = "-T~-Z[ri]", vjust = 1, parse = TRUE, size = 8)
    )

  p <- p0

  ggsave(out_path, plot = p, width = 12, height = 6, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

read_matched_profiles <- function(data_dir, suite_label) {
  files <- list.files(data_dir, pattern = "slab_.*_t100_representative\\.csv", full.names = TRUE)
  matched <- files[str_detect(basename(files), fixed("EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02"))]
  if (!length(matched)) {
    log_error(paste("no matched-forcing slab profiles in:", data_dir))
    return(NULL)
  }
  map_df(matched, read_seismic_profile) |>
    mutate(suite = suite_label)
}

visualize_seismic_comparison <- function(data_dir_warm_sluggish, data_dir_cold_nominal, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }
  df <- bind_rows(
    read_matched_profiles(data_dir_warm_sluggish, "Warm Slab\nSluggish Kinetics"),
    read_matched_profiles(data_dir_cold_nominal, "Cold Slab\nNominal Kinetics")
  )
  if (is.null(df) || !nrow(df)) {
    return(invisible())
  }
  df <- df |> mutate(suite = factor(suite,
    levels = c("Warm Slab\nSluggish Kinetics", "Cold Slab\nNominal Kinetics")
  ))

  lim_vp <- range(df$seismic_Vp, na.rm = TRUE)

  p_panel <- function(suite_label, labels = TRUE) {
    d <- df |> filter(suite == suite_label)
    panel <-
      ggplot(d, aes(x = seismic_Vp, y = depth, group = model_id)) +
      geom_path(aes(color = z_ri), linewidth = 2.2, alpha = 0.80) +
      geom_hline(yintercept = NOMINAL_410_KM, linetype = "dotted", linewidth = 1.5) +
      geom_hline(yintercept = NOMINAL_520_KM, linetype = "dotted", linewidth = 1.5) +
      geom_hline(yintercept = NOMINAL_660_KM, linetype = "dotted", linewidth = 1.5) +
      scale_y_reverse() +
      scale_x_continuous(limits = lim_vp, breaks = c(8, 9, 10, 11, 12)) +
      scale_color_viridis_c(
        option = "mako", trans = "log10",
        breaks = c(1e-10, 1e-8, 1e-6, 1e-4, 1e-2, 1e0, 1e2, 1e4), labels = label_log()
      ) +
      labs(title = suite_label, x = expression(V[p] ~ (km / s)), y = "Depth (km)", color = expression(Z[ri])) +
      theme_bw(base_size = 22) +
      theme_profile_comparison()

    if (labels) {
      panel + list(
        annotate("text", x = 8.05, y = NOMINAL_410_KM + 35, label = "410", size = 7, hjust = 0),
        annotate("text", x = 8.05, y = NOMINAL_520_KM + 35, label = "520", size = 7, hjust = 0),
        annotate("text", x = 8.05, y = NOMINAL_660_KM + 35, label = "660", size = 7, hjust = 0)
      )
    } else {
      panel
    }
  }

  p <- p_panel("Warm Slab\nSluggish Kinetics") |
    (p_panel("Cold Slab\nNominal Kinetics", FALSE) + theme(axis.text.y = element_blank(), axis.title.y = element_blank()))
  ggsave(out_path, plot = p, width = 6.5, height = 6.5, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

# Tuned variant for the revisions comparison figure. The submission figure
# (visualize_seismic_profiles) keeps the original theme_profile below.
theme_profile_comparison <- function() {
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    panel.spacing.x = unit(1.5, "cm"),
    plot.margin = margin(5, 5, 5, 5),
    plot.title = element_text(hjust = 0.5, size = 20, margin = margin(0, 0, 10, 0)),
    axis.ticks = element_blank(),
    legend.justification = "right",
    legend.position = "inside",
    legend.position.inside = c(0.93, 0.90),
    legend.direction = "horizontal",
    legend.key.height = unit(0.8, "lines"),
    legend.key.width = unit(1.2, "lines"),
    legend.box.margin = margin(2, 2, 2, 2),
    legend.margin = margin(),
    legend.title = element_text(size = 20, vjust = 1),
    legend.text = element_text(size = 15, margin = margin(5, 0, 0, 0)),
    legend.background = element_blank(),
    legend.ticks = element_line(color = "black", linewidth = 0.4),
    legend.ticks.length = unit(0.2, "lines"),
    legend.frame = element_rect(color = "black", linewidth = 0.4),
    legend.spacing.y = unit(1.0, "lines")
  )
}

# Original submission styling for visualize_seismic_profiles, as submitted.
theme_profile <- function() {
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    panel.spacing.x = unit(1.5, "cm"),
    plot.margin = margin(5, 25, 5, 25),
    plot.title = element_text(hjust = 0.5, size = 32, margin = margin(0, 0, 10, 0)),
    axis.ticks = element_blank(),
    legend.justification = "left",
    legend.position = "inside",
    legend.position.inside = c(0.02, 0.85),
    legend.direction = "horizontal",
    legend.key.height = unit(0.65, "cm"),
    legend.key.width = unit(1.1, "cm"),
    legend.box.margin = margin(2, 2, 2, 2),
    legend.margin = margin(),
    legend.title = element_text(vjust = 1, size = 32),
    legend.background = element_blank(),
    legend.ticks = element_line(color = "black", linewidth = 1.0),
    legend.ticks.length = unit(0.2, "lines"),
    legend.frame = element_rect(color = "black", linewidth = 1.0),
    legend.text = element_text(size = 28, margin = margin(5, 0, 0, 0)),
    legend.spacing.y = unit(1.0, "lines")
  )
}
