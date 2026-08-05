#######################################################
## Helpers                                       !!! ##
#######################################################
read_seismic_profile <- function(filepath) {
  df <- read_csv(filepath, show_col_types = FALSE)
  fname <- basename(filepath)
  df |>
    mutate(
      model_id = fname,
      tstep = as.numeric(str_extract(fname, "(?<=_t)[0-9]+(?=_)")),
      type = if_else(str_detect(fname, "plume"), "Plume", "Slab"),
      z_ri = as.numeric(str_extract(fname, "(?<=Zri)[0-9e.+-]+")),
      seismic_Vp = seismic_Vp,
      seismic_Vs = seismic_Vs,
      depth = depth / 1e3,
      trace_x = trace_x / 1e3,
    )
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
visualize_seismic_profiles <- function(data_dir, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  file_list <- list.files(data_dir, pattern = "*.csv", full.names = TRUE)
  data <- map_df(file_list, read_seismic_profile)
  data_init <- data |> filter(tstep == 0)
  data <- data |> filter((str_detect(model_id, "plume") & tstep == 50) | (str_detect(model_id, "slab") & tstep == 100))

  df_plume <- data |> filter(type == "Plume")
  df_slab <- data |> filter(type == "Slab")

  p_profile <- function(data, x_var, title = "", x_label = "", show_y = TRUE, show_legend = FALSE) {
    p <- ggplot(data, aes(x = !!sym(x_var), y = depth, group = model_id)) +
      geom_path(aes(color = z_ri), linewidth = 1.2, alpha = 0.8, show.legend = show_legend) +
      scale_y_reverse() +
      scale_color_continuous_sequential(
        palette = "YlOrRd",
        rev = FALSE,
        trans = "log10",
        breaks = c(1e-2, 1e0, 1e2),
        labels = label_log()
      ) +
      labs(title = title, x = x_label, y = "Depth (km)", color = expression(Z[ri])) +
      theme_bw(base_size = 34) +
      theme_profile() +
      theme(legend.position = "inside", legend.position.inside = c(0.37, 0.85))

    if (x_var != "trace_x") {
      p <- p + geom_path(data = filter(data_init, !is.na(!!sym(x_var))), color = "black", linewidth = 1.2, show.legend = show_legend)
    }

    if (!show_y) {
      p <- p + theme(axis.text.y = element_blank(), axis.title.y = element_blank())
    }
    p
  }

  lim_vp <- range(data$seismic_Vp, na.rm = TRUE)
  lim_vs <- range(data$seismic_Vs, na.rm = TRUE)
  lim_ro <- range(data$density, na.rm = TRUE)
  lim_trace <- c(0, 1500)

  p0 <- (
    p_profile(df_plume, "seismic_Vp", "Plumes", expression(V[p] ~ (km / s)), TRUE, TRUE) +
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

  # p1 <- (p_profile(df_plume, "seismic_Vs", NULL, expression(V[s] ~ (km / s)), TRUE) + scale_x_continuous(limits = lim_vs)) |
  #   (p_profile(df_slab, "seismic_Vs", NULL, expression(V[s] ~ (km / s)), FALSE) + scale_x_continuous(limits = lim_vs))
  #
  # p2 <- (p_profile(df_plume, "trace_x", NULL, "X (km)", TRUE) + scale_x_continuous(limits = lim_trace)) |
  #   (p_profile(df_slab, "trace_x", NULL, "X (km)", FALSE) + scale_x_continuous(limits = lim_trace))

  # p <- p0 / p1 / p2
  p <- p0

  ggsave(out_path, plot = p, width = 12, height = 6, dpi = 300, bg = "white", create.dir = TRUE)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
    legend.key.width = unit(1, "cm"),
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
