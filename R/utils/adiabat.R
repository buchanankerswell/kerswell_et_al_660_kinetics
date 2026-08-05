#######################################################
## Visualize Adiabatic Reference Conditions      !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
read_burnman_profile <- function(filepath) {
  file_lines <- readLines(filepath)
  header_lines <- file_lines[str_detect(file_lines, "^#")]
  skip_lines <- length(header_lines)
  read_delim(
    filepath,
    delim = "\t",
    skip = skip_lines,
    show_col_types = FALSE
  ) |>
    mutate(across(everything(), ~ as.numeric(.)))
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
read_material_table <- function(filepath) {
  file_lines <- readLines(filepath)
  header_pattern <- "^T\\(K\\)\\s+P\\(bar\\)\\s+rho"
  header_line_indices <- str_which(file_lines, header_pattern)

  if (length(header_line_indices) == 1) {
    header_line_index <- header_line_indices[1]
    skip_lines <- header_line_index - 1
  } else if (length(header_line_indices) > 1) {
    stop("Multiple lines matched the header pattern!")
  } else {
    stop("Header line not found with the specified pattern!")
  }

  suppressWarnings({
    df <- read_table(filepath, skip = skip_lines, show_col_types = FALSE)
  })

  df |>
    rename(
      temperature = "T(K)",
      pressure = "P(bar)",
      density = "rho,kg/m3",
      thermal_expansivity = "alpha,1/K",
      compressibility = "beta,1/bar",
      specific_heat = "cp,J/K/kg",
      entropy = "s,J/K/kg"
    ) |>
    select(c(
      temperature,
      pressure,
      density,
      thermal_expansivity,
      compressibility,
      specific_heat,
      entropy
    )) |>
    mutate(across(everything(), ~ as.numeric(.))) |>
    mutate(
      pressure = pressure / 1e4,
      density = density / 1e3,
      thermal_expansivity = thermal_expansivity * 1e5,
      compressibility = compressibility * 1e7,
      specific_heat = specific_heat / 1e3,
      entropy = entropy / 1e3
    )
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
expand_range_iqr <- function(x, threshold = 5.0) {
  x <- x[is.finite(x)]
  q <- quantile(x, probs = c(0.25, 0.75), na.rm = TRUE)
  iqr <- q[2] - q[1]
  lower <- q[1] - threshold * iqr
  upper <- q[2] + threshold * iqr
  inliers <- x[x >= lower & x <= upper]
  range(inliers, na.rm = TRUE)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_profile_metadata <- function(filepath) {
  fname <- basename(filepath)
  parts <- str_split(fname, "-")[[1]]

  get_abbr <- function(name) {
    if (name == "olivine") {
      "ol"
    } else if (name == "wadsleyite") {
      "wd"
    } else if (name == "ringwoodite") {
      "ri"
    } else if (name == "postspinel") {
      "ps"
    } else {
      name
    }
  }

  name_a <- get_abbr(parts[1])
  name_b <- get_abbr(parts[2])

  file_limits <- if (name_a == "ol" && name_b == "wd") {
    c(0e9, 17e9)
  } else if (name_a == "wd" && name_b == "ri") {
    c(12e9, 23e9)
  } else if (name_a == "ri" && name_b == "ps") {
    c(18e9, 40e9)
  } else {
    c(0, 40e9)
  }

  phase_limits <- list(ol = c(5e9, 17e9), wd = c(12e9, 23e9), ri = c(17e9, 27e9), ps = c(20e9, 40e9))
  list(name_a = name_a, name_b = name_b, limits = file_limits, phase_limits = phase_limits, delta_label = paste0(name_a, "-", name_b))
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
theme_profile <- function() {
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey90"),
    panel.spacing.x = unit(1.5, "cm"),
    plot.margin = margin(5, 25, 5, 25),
    plot.title = element_text(hjust = 0.5),
    axis.ticks = element_blank(),
    legend.justification = "left",
    legend.position = "inside",
    legend.position.inside = c(0.02, 0.85),
    legend.direction = "horizontal",
    legend.key.height = unit(0.5, "cm"),
    legend.key.width = unit(1, "cm"),
    legend.box.margin = margin(2, 2, 2, 2),
    legend.margin = margin(),
    legend.title = element_text(vjust = 0, size = 20),
    legend.background = element_blank()
  )
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
theme_table <- function() {
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = NA),
    plot.margin = margin(50, 25, 5, 5),
    plot.title = element_text(hjust = 0.5),
    plot.tag.location = "panel",
    plot.tag = element_text(margin = margin(5, 0, 0, -5), hjust = 0, face = "bold", color = "white"),
    axis.ticks = element_blank(),
    legend.justification = c(1, 0),
    legend.position = "inside",
    legend.position.inside = c(1.0, 1.0),
    legend.direction = "horizontal",
    legend.key.height = unit(1.15, "lines"),
    legend.key.width = unit(2.0, "lines"),
    legend.ticks = element_line(color = "black", linewidth = 0.6),
    legend.ticks.length = unit(0.2, "lines"),
    legend.frame = element_rect(color = "black", linewidth = 0.6),
    legend.box.margin = margin(15, 5, 15, 5),
    legend.margin = margin(5, 5, 5, 5),
    legend.title = element_text(vjust = 1, size = 24),
    legend.text = element_text(size = 20, margin = margin(5, 0, 0, 0)),
    legend.background = element_blank()
  )
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
visualize_thermodynamic_profile <- function(profile_paths, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  all_data <- map_dfr(profile_paths, function(path) {
    meta <- get_profile_metadata(path)
    df_raw <- read_burnman_profile(path) |>
      filter(pressure >= meta$limits[1], pressure <= meta$limits[2]) |>
      mutate(
        pressure_pa = pressure,
        pressure = pressure / 1e9,
        G_a = molar_gibbs_a / 1e3, G_b = molar_gibbs_b / 1e3, G_delta = delta_molar_gibbs / 1e3,
        S_a = molar_entropy_a, S_b = molar_entropy_b, S_delta = delta_molar_entropy,
        V_a = molar_volume_a * 1e6, V_b = molar_volume_b * 1e6, V_delta = delta_molar_volume * 1e6
      ) |>
      select(pressure, pressure_pa, matches("^[GSV]_(a|b|delta)")) |>
      pivot_longer(cols = -c(pressure, pressure_pa), names_to = c("property", "type"), names_sep = "_") |>
      mutate(
        legend_label = case_when(
          type == "a" ~ meta$name_a,
          type == "b" ~ meta$name_b,
          type == "delta" ~ meta$delta_label
        ),
        pair_id = meta$delta_label,
        plot_group = type
      ) |>
      filter(
        case_when(
          type == "a" ~ pressure_pa >= meta$phase_limits[[meta$name_a]][1] & pressure_pa <= meta$phase_limits[[meta$name_a]][2],
          type == "b" ~ pressure_pa >= meta$phase_limits[[meta$name_b]][1] & pressure_pa <= meta$phase_limits[[meta$name_b]][2],
          TRUE ~ TRUE
        )
      ) |>
      select(-pressure_pa)
  })

  all_deltas <- all_data |>
    filter(plot_group == "delta") |>
    pull(legend_label) |>
    unique()

  all_data <- all_data |> mutate(legend_label = factor(legend_label, levels = c("ol", "wd", "ri", "ps", all_deltas)))
  df_phases <- filter(all_data, plot_group != "delta")
  df_deltas <- filter(all_data, plot_group == "delta")

  phase_trans <- list(olwd = 14.4e9, wdri = 20.1e9, rips = 23.4e9)

  units <- c(G = "kJ/mol", S = "J/K/mol", V = "cm^3/mol")
  labs <- c(G = "bar(G)", S = "bar(S)", V = "bar(V)")
  labs_delta <- c(G = "Delta*bar(G)", S = "Delta*bar(S)", V = "Delta*bar(V)")

  custom_labeller <- function(variable) {
    paste0(labs[variable], " * ' (' * ", units[variable], " * ')'")
  }
  custom_labeller_delta <- function(variable) {
    paste0(labs_delta[variable], " * ' (' * ", units[variable], " * ')'")
  }

  p0 <- ggplot(df_phases, aes(value, pressure, color = legend_label, group = interaction(legend_label, pair_id))) +
    geom_hline(yintercept = phase_trans$olwd / 1e9, alpha = 0.1, linewidth = 5) +
    geom_hline(yintercept = phase_trans$wdri / 1e9, alpha = 0.1, linewidth = 5) +
    geom_hline(yintercept = phase_trans$rips / 1e9, alpha = 0.1, linewidth = 5) +
    geom_path(linewidth = 1.8) +
    facet_wrap(~property, nrow = 1, scales = "free_x", labeller = labeller(property = custom_labeller, .default = label_parsed)) +
    scale_x_continuous(breaks = pretty_breaks(n = 4), guide = guide_axis(check.overlap = TRUE), expand = expansion(mult = 0.10)) +
    scale_y_reverse() +
    scale_color_brewer(palette = "Set1") +
    labs(x = NULL, y = "Pressure (GPa)", color = NULL) +
    theme_bw(base_size = 36) +
    theme_profile() +
    theme(
      strip.background = element_blank(),
      strip.text = element_text(size = 32, face = "bold"),
      legend.position = "inside",
      legend.direction = "vertical",
      legend.position.inside = c(0.01, 0.22),
      legend.text = element_text(size = 28),
      legend.title = element_text(margin = margin()),
      legend.box.background = element_rect(fill = "grey90", color = NA)
    )

  p1 <- ggplot(df_deltas, aes(value, pressure, linetype = legend_label)) +
    geom_hline(yintercept = phase_trans$olwd / 1e9, alpha = 0.1, linewidth = 5) +
    geom_hline(yintercept = phase_trans$wdri / 1e9, alpha = 0.1, linewidth = 5) +
    geom_hline(yintercept = phase_trans$rips / 1e9, alpha = 0.1, linewidth = 5) +
    geom_path(linewidth = 1.8) +
    facet_wrap(~property, nrow = 1, scales = "free_x", labeller = labeller(property = custom_labeller_delta, .default = label_parsed)) +
    scale_x_continuous(n.breaks = 5, guide = guide_axis(check.overlap = TRUE), expand = expansion(mult = 0.10)) +
    scale_y_reverse() +
    labs(x = NULL, y = "Pressure (GPa)", linetype = NULL) +
    theme_bw(base_size = 36) +
    theme_profile() +
    theme(
      plot.margin = margin(5, 5, 5, 5),
      strip.background = element_blank(),
      strip.text = element_text(size = 32, face = "bold"),
      legend.position = "inside",
      legend.direction = "vertical",
      legend.position.inside = c(0.01, 0.85),
      legend.text = element_text(size = 28),
      legend.title = element_text(margin = margin()),
      legend.box.background = element_rect(fill = "grey90", color = NA)
    )

  p <- p0 / p1 & theme(legend.key.width = unit(2, "cm"))
  ggsave(out_path, plot = p, width = 15, height = 13)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
visualize_material_profile <- function(profile_paths, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  target_props <- c("density", "thermal_expansivity", "compressibility", "specific_heat")

  df_all <- map_dfr(profile_paths, function(path) {
    meta <- get_profile_metadata(path)
    df_raw <- read_burnman_profile(path)

    df_raw |>
      filter(pressure >= meta$limits[1], pressure <= meta$limits[2]) |>
      select(pressure, matches(paste0("^(", paste(target_props, collapse = "|"), ")_[ab]$"))) |>
      pivot_longer(cols = -pressure, names_to = c("property", "type_raw"), names_sep = "_(?=[ab]$)", values_to = "value") |>
      mutate(pressure = pressure / 1e9, type = ifelse(type_raw == "a", meta$name_a, meta$name_b), pair_id = meta$delta_label) |>
      rowwise() |>
      filter((pressure * 1e9) >= meta$phase_limits[[type]][1], (pressure * 1e9) <= meta$phase_limits[[type]][2]) |>
      ungroup()
  })

  df_all <- df_all |>
    mutate(
      value = case_when(
        property == "density" ~ value / 1e3,
        property == "thermal_expansivity" ~ value * 1e5,
        property == "specific_heat" ~ value / 1e3,
        property == "compressibility" ~ value * 1e12,
        TRUE ~ value
      ),
      type = factor(type, levels = c("ol", "wd", "ri", "ps")),
      property = factor(property, levels = target_props)
    )

  units <- c("density" = "g/cm^3", "thermal_expansivity" = "K%*%10^-5", "specific_heat" = "kJ/K~kg", "compressibility" = "Pa%*%10^-12")
  labs <- c("density" = "bar(rho)", "thermal_expansivity" = "bar(alpha)", "specific_heat" = "bar(C)[p]", "compressibility" = "bar(beta)")

  custom_labeller <- function(variable) {
    paste0(labs[variable], " * ' (' * ", units[variable], " * ')'")
  }

  phase_trans <- list(olwd = 14.4e9, wdri = 20.1e9, rips = 23.4e9)

  p <- ggplot(df_all, aes(x = value, y = pressure, color = type, group = interaction(type, pair_id))) +
    geom_hline(yintercept = phase_trans$olwd / 1e9, alpha = 0.1, linewidth = 5) +
    geom_hline(yintercept = phase_trans$wdri / 1e9, alpha = 0.1, linewidth = 5) +
    geom_hline(yintercept = phase_trans$rips / 1e9, alpha = 0.1, linewidth = 5) +
    geom_path(linewidth = 1.8) +
    facet_wrap(~property, nrow = 1, scales = "free_x", labeller = labeller(property = custom_labeller, .default = label_parsed)) +
    scale_y_reverse() +
    scale_color_brewer(palette = "Set1") +
    labs(x = NULL, y = "Pressure (GPa)", color = NULL) +
    theme_bw(base_size = 36) +
    theme_profile() +
    theme(
      strip.background = element_blank(),
      strip.text = element_text(size = 32, face = "bold"),
      legend.position = "inside",
      legend.direction = "vertical",
      legend.position.inside = c(0.01, 0.19),
      legend.key.width = unit(2, "cm"),
      legend.text = element_text(size = 28),
      legend.title = element_text(margin = margin()),
      legend.box.background = element_rect(fill = "grey90", color = NA)
    )

  ggsave(out_path, plot = p, width = 20, height = 7, dpi = 300)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
visualize_material_table <- function(profile_path, table_path, out_path) {
  if (plot_exists(out_path)) {
    return(invisible())
  }

  df_profile <- read_burnman_profile(profile_path) |>
    mutate(
      pressure = pressure / 1e9,
      density = density / 1e3,
      thermal_expansivity = thermal_expansivity * 1e5,
      compressibility = compressibility * 1e12
    ) |>
    select(-c(seismic_vp, seismic_vs)) |>
    filter(pressure >= 0 & pressure <= 43 & temperature >= 1053 & temperature <= 2673)

  df_tables <- read_material_table(table_path) |>
    filter(pressure >= 0 & pressure <= 43 & temperature >= 1053 & temperature <= 2673)

  props <- c("entropy", "density")
  units <- c("density" = "g/cm^3", "thermal_expansivity" = "K%*%10^-5", "compressibility" = "Pa%*%10^-12", "specific_heat" = "KJ/K~kg", "entropy" = "kJ/K~kg")
  labs <- c("density" = "bar(rho)", "thermal_expansivity" = "bar(alpha)", "compressibility" = "bar(beta)", "specific_heat" = "bar(C[p])", "entropy" = "bar(S)")
  color_map <- c("density" = "mako", "thermal_expansivity" = "magma", "compressibility" = "mako", "specific_heat" = "magma", "entropy" = "mako")

  color_lims <- list(
    density = expand_range_iqr(df_tables$density),
    thermal_expansivity = expand_range_iqr(df_tables$thermal_expansivity),
    compressibility = expand_range_iqr(df_tables$compressibility),
    specific_heat = expand_range_iqr(df_tables$specific_heat),
    entropy = expand_range_iqr(df_tables$entropy)
  )

  color_direction <- c("density" = -1, "thermal_expansivity" = 1, "compressibility" = 1, "specific_heat" = 1, "entropy" = 1)

  custom_labeller <- function(variable) {
    if (units[variable] != "") {
      label <- paste0(labs[variable], " * ' (' * ", units[variable], " * ')'")
    } else {
      label <- labs[variable]
    }
    parse(text = label)
  }

  suppressWarnings({
    p1 <-
      ggplot() +
      geom_raster(data = df_tables, aes(temperature, pressure, fill = get(props[1]))) +
      geom_path(data = df_profile, aes(temperature, pressure), color = "white", linewidth = 1.4) +
      geom_path(data = data.frame(x = c(1205, 2523, 2523, 1205, 1205), y = c(2.5, 2.5, 40, 40, 2.5)), aes(x, y), color = "black", linewidth = 1.4) +
      scale_fill_viridis_c(
        option = color_map[props[1]],
        direction = color_direction[props[1]],
        limits = color_lims[[props[1]]],
        breaks = pretty_breaks(n = 3),
        na.value = "grey90"
      ) +
      labs(x = "Temperature (K)", y = "Pressure (GPa)", fill = custom_labeller(props[1])) +
      coord_cartesian(expand = FALSE) +
      theme_bw(base_size = 30) +
      theme_table()

    p2 <-
      ggplot() +
      geom_raster(data = df_tables, aes(temperature, pressure, fill = get(props[2]))) +
      geom_path(data = df_profile, aes(temperature, pressure), color = "white", linewidth = 1.4) +
      geom_path(data = data.frame(x = c(1205, 2523, 2523, 1205, 1205), y = c(2.5, 2.5, 40, 40, 2.5)), aes(x, y), color = "black", linewidth = 1.4) +
      scale_fill_viridis_c(
        option = color_map[props[2]],
        direction = color_direction[props[2]],
        limits = color_lims[[props[2]]],
        breaks = pretty_breaks(n = 4),
        na.value = "grey90"
      ) +
      labs(x = "Temperature (K)", y = "Pressure (GPa)", fill = custom_labeller(props[2])) +
      coord_cartesian(expand = FALSE) +
      theme_bw(base_size = 30) +
      theme_table() +
      theme(axis.title.y = element_blank(), axis.text.y = element_blank())

    p <- p1 + p2

    ggsave(out_path, plot = p, width = 10, height = 5.5, dpi = 300, bg = "white", create.dir = TRUE)
  })
}
