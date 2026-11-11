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
      z_ri = as.numeric(str_extract(fname, "(?<=Zri)[0-9e.+-]+")),
      depth = depth / 1e3,
      trace_x = trace_x / 1e3,
    )
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

read_init_profile <- function(data_dir) {
  files <- list.files(data_dir, pattern = "slab_.*_t0_representative\\.csv", full.names = TRUE)
  if (!length(files)) {
    return(NULL)
  }
  read_seismic_profile(files[1]) |> filter(!is.na(seismic_Vp))
}

visualize_seismic_comparison <- function(data_dir_sw, data_dir_nc, out_path, force_rewrite = FALSE) {
  if (!force_rewrite && plot_exists(out_path)) {
    return(invisible())
  }
  df <- bind_rows(
    read_matched_profiles(data_dir_sw, "SW suite"),
    read_matched_profiles(data_dir_nc, "NC suite")
  )
  if (is.null(df) || !nrow(df)) {
    return(invisible())
  }
  df <- df |> mutate(suite = factor(suite,
    levels = c("SW suite", "NC suite")
  ))
  df_init <- read_init_profile(data_dir_sw)

  lim_vp <- range(c(df$seismic_Vp, if (!is.null(df_init)) df_init$seismic_Vp), na.rm = TRUE)

  # Nominal-transition bands (light gray, matching the setup diagram) drawn
  # first so profiles render on top of them.
  nominal_bands <- function() {
    list(
      annotate("rect", xmin = -Inf, xmax = Inf, ymin = NOMINAL_410_KM - 10, ymax = NOMINAL_410_KM + 10, fill = "grey80", alpha = 0.7),
      annotate("rect", xmin = -Inf, xmax = Inf, ymin = NOMINAL_520_KM - 10, ymax = NOMINAL_520_KM + 10, fill = "grey80", alpha = 0.7),
      annotate("rect", xmin = -Inf, xmax = Inf, ymin = NOMINAL_660_KM - 10, ymax = NOMINAL_660_KM + 10, fill = "grey80", alpha = 0.7)
    )
  }

  p_panel <- function(suite_label, labels = TRUE) {
    d <- df |> filter(suite == suite_label)
    panel <-
      ggplot(d, aes(x = seismic_Vp, y = depth, group = model_id)) +
      nominal_bands() +
      geom_path(aes(color = z_ri), linewidth = 2.0, alpha = 0.85) +
      scale_y_reverse() +
      scale_x_continuous(limits = lim_vp, breaks = c(8, 9, 10, 11, 12)) +
      scale_color_continuous_sequential(
        palette = "YlOrRd",
        rev = FALSE,
        trans = "log10",
        breaks = if (labels) c(1e-9, 1e-7, 1e-5) else c(1e-2, 1e0, 1e2),
        labels = label_log()
      ) +
      labs(title = suite_label, x = expression(V[p] ~ (km / s)), y = "Depth (km)", color = expression(Z[ri])) +
      theme_bw(base_size = 24) +
      theme_profile_comparison()

    if (!is.null(df_init)) {
      panel <- panel + geom_path(data = df_init, color = "black", linewidth = 1.4, show.legend = FALSE)
    }

    if (labels) {
      panel <- panel + list(
        annotate("text", x = 8.05, y = NOMINAL_410_KM + 40, label = "410", size = 6.5, hjust = 0, color = "gray30"),
        annotate("text", x = 8.05, y = NOMINAL_520_KM + 40, label = "520", size = 6.5, hjust = 0, color = "gray30"),
        annotate("text", x = 8.05, y = NOMINAL_660_KM + 40, label = "660", size = 6.5, hjust = 0, color = "gray30"),
        annotate("segment", x = 9.3, xend = 9.3, y = 300, yend = 200, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 9.3, y = 190, label = "-T", vjust = 0, parse = TRUE, size = 6),
        annotate("segment", x = 9.3, xend = 9.3, y = 400, yend = 500, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 9.3, y = 515, label = "-Z[ol]", vjust = 1, parse = TRUE, size = 6),
        annotate("segment", x = 10.1, xend = 10.1, y = 430, yend = 330, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 10.1, y = 320, label = "-T", vjust = 0, parse = TRUE, size = 6),
        annotate("segment", x = 10.1, xend = 10.1, y = 550, yend = 650, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 10.1, y = 665, label = "-Z[wd]", vjust = 1, parse = TRUE, size = 6),
        annotate("segment", x = 10.9, xend = 10.9, y = 720, yend = 820, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 10.9, y = 835, label = "-T~-Z[ri]", vjust = 1, parse = TRUE, size = 6)
      )
    } else {
      panel <- panel + list(
        annotate("segment", x = 9.3, xend = 9.3, y = 260, yend = 160, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 9.3, y = 150, label = "-T", vjust = 0, parse = TRUE, size = 6),
        annotate("segment", x = 10.0, xend = 10.0, y = 370, yend = 270, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 10.0, y = 260, label = "-T", vjust = 0, parse = TRUE, size = 6),
        annotate("segment", x = 10.9, xend = 10.9, y = 700, yend = 800, arrow = arrow(length = unit(0.25, "cm"), type = "closed"), linewidth = 1.0),
        annotate("text", x = 10.9, y = 815, label = "-T", vjust = 1, parse = TRUE, size = 6)
      )
    }
    panel
  }

  p <- p_panel("SW suite") |
    (p_panel("NC suite", FALSE) + theme(axis.text.y = element_blank(), axis.title.y = element_blank()))
  ggsave(out_path, plot = p, width = 8.25, height = 6.0, dpi = 300, bg = "white", create.dir = TRUE)
  log_artifact(out_path)
}

# Tuned theme for the SW/NC comparison figure.
theme_profile_comparison <- function() {
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    panel.spacing.x = unit(1.5, "cm"),
    plot.margin = margin(5, 5, 5, 5),
    plot.title = element_text(hjust = 0.5, size = 26, face = "bold", margin = margin(0, 0, 10, 0)),
    axis.ticks = element_blank(),
    legend.justification = "right",
    legend.position = "inside",
    legend.position.inside = c(0.93, 0.90),
    legend.direction = "horizontal",
    legend.key.height = unit(0.8, "lines"),
    legend.key.width = unit(1.2, "lines"),
    legend.box.margin = margin(2, 2, 2, 2),
    legend.margin = margin(),
    legend.title = element_text(size = 22, vjust = 1),
    legend.text = element_text(size = 16, margin = margin(5, 0, 0, 0)),
    legend.background = element_blank(),
    legend.ticks = element_line(color = "black", linewidth = 0.4),
    legend.ticks.length = unit(0.2, "lines"),
    legend.frame = element_rect(color = "black", linewidth = 0.4),
    legend.spacing.y = unit(1.0, "lines")
  )
}
