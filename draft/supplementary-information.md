# Contents of this file {.unnumbered #sec:contents}

1. Figures -@fig:material-property-profiles to -@fig:plume-composition-660-b50
2. @tbl:depth-profile-summary

\clearpage

# Introduction {.unnumbered #sec:introduction}

This supplementary information provides five figures and one table that support the material model, kinetic calibration, and quantitative results described in the main text.

Figures -@fig:material-property-profiles and -@fig:thermodynamic-property-profiles show the reference material and thermodynamic properties used to initialize and drive the compressible mantle flow simulations. These profiles give the density, thermal expansivity, compressibility, and specific heat capacity of each mantle phase across the transition zone, along with the Gibbs free energy, entropy, and volume changes that govern the 410, 520, and 660 phase transitions.

@fig:regression presents the Monte Carlo regression used to calibrate the ringwoodite decomposition kinetic rate equation against the high-overpressure experimental dataset of @kubo2002. This regression constrains the activation energy and growth-rate prefactor within the uncertainties reported in the main text and justifies the five-order-of-magnitude range of the kinetic prefactor $Z_\mathrm{ri}$ explored in our simulations.

Figures -@fig:slab-composition-660-b01 to -@fig:plume-composition-660-b50 show slab and plume simulation snapshots for scenarios with a moderate lower-mantle viscosity jump ($b$ = 50) compared to the no-jump case ($b$ = 1) shown in the main text. These snapshots show how the three kinetic regimes identified at the 660 (quasi-equilibrium, intermediate, and stagnation) are affected when an additional viscosity contrast is imposed at the base of the transition zone (i.e., slabs and plumes tend to stagnate at the 660).

@tbl:depth-profile-summary reports the kinetic prefactor $Z_\mathrm{ri}$, 660 displacement and width, maximum reaction rate, and maximum descent or ascent velocity through the 660 for every plume and slab simulation across all eight tested scenarios. These values underlie the trends discussed in the main text.

\clearpage

# Material Model (Figures S1--S3) {.unnumbered #sec:material-model}

\clearpage

![Reference material properties used in ASPECT simulations showing density ($\bar{\rho}$), thermal expansivity ($\bar{\alpha}$), compressibility ($\bar{\beta}$), and specific heat capacity ($\bar{C}_p$). Colored profiles are for pure Mg olivine (ol), wadsleyite (wd), ringwoodite (ri), and the post-spinel (ps) assemblage bridgmanite + periclase. Profiles are computed using the methods described in see Section 2.2.1 in the main text. Gray bands indicate the 410, 520, and 660 transitions.](../figs/adiabat/material-property-profiles.png){#fig:material-property-profiles width=100%}

![Reference thermodynamic properties used in our ASPECT simulations. Colored profiles are for pure Mg olivine (ol), wadsleyite (wd), ringwoodite (ri), and the post-spinel (ps) assemblage bridgmanite + periclase. Profiles are computed using the same methods as described in @fig:material-property-profiles (see Section 2.2.1 in the main text). Gray bands indicate the 410, 520, and 660 transitions.](../figs/adiabat/thermodynamic-property-profiles.png){#fig:thermodynamic-property-profiles width=80%}

![Monte Carlo regression of high-overpressure experimental data from @kubo2002. The best-fit activation energy $E^{\ast}$ = 310 $\pm$ 233 kJ mol$^{-1}$ (2$\sigma$) and growth-rate prefactor $\ln(K^{\prime})$ = -29.8 $\pm$ 22.1 are both consistent with @kubo2002 within uncertainty. The large uncertainties in $E^{\ast}$ and $\ln(K^{\prime})$ reflect few data points with relatively high experimental $T$ uncertainties. Our exploration over five orders of magnitude in $Z_\mathrm{ri}$ roughly captures this broad uncertainty.](../figs/kubo/regression.png){#fig:regression width=68%}

\clearpage

# Simulation Snapshots: Slabs and Plumes (Figures S4--S7) {.unnumbered #sec:simulation-snapshots}

\clearpage

![Reference slab simulations with moderate inflow velocity, intermediate slab strength, and no lower mantle viscosity jump (scenario 4; Table 1 in main text). Rows show stagnation (top row: $Z_\mathrm{ri}$ = 1.6e-03 mol$^2$ J$^{-2}$ s$^{-1}$), intermediate (middle row: $Z_\mathrm{ri}$ = 6.0e-01 mol$^2$ J$^{-2}$ s$^{-1}$), and quasi-equilibrium (bottom row: $Z_\mathrm{ri}$ = 1.6e+03 mol$^2$ J$^{-2}$ s$^{-1}$) kinetic regimes after 100 Ma. Columns show dynamic temperature $\hat{T}$ (left column), log viscosity $\eta$ (middle column), and volume fraction of the post-spinel assemblage $X_\mathrm{ps}$ (right column). Thick black lines (left column) highlight the 10% and 90% wadsleyite and post-spinel volume fraction contours used to define 660 displacement and width. The background grid pattern indicates ASPECT's adaptive mesh refinement near high thermal gradients and phase transitions. White trace (left column) indicates the representative depth profile used to extract data, and the white arrows indicate where the 660 structure is evaluated.](../figs/simulation/compositions/slab-set2-composition-b01-0100.png){#fig:slab-composition-660-b01 width=100%}

\clearpage

![Slab simulations with moderate inflow velocity, intermediate slab strength, and a moderate lower mantle viscosity jump (scenario 0; Table 1 in main text). Description and annotations follow @fig:slab-composition-660-b01.](../figs/simulation/compositions/slab-set2-composition-b50-0100.png){#fig:slab-composition-660-b50 width=100%}

\clearpage

![Reference plume simulations with moderate inflow velocity, intermediate plume strength, and no lower mantle viscosity jump (scenario 4; Table 1 in main text). Rows show ultra-sluggish (top row: $Z_\mathrm{ri}$ = 1.6e-03 mol$^2$ J$^{-2}$ s$^{-1}$), intermediate (middle row: $Z_\mathrm{ri}$ = 6.0e-01 mol$^2$ J$^{-2}$ s$^{-1}$), and fast (bottom row: $Z_\mathrm{ri}$ = 1.6e+03 mol$^2$ J$^{-2}$ s$^{-1}$) kinetic conditions after 50 Ma. All other annotations follow @fig:slab-composition-660-b01.](../figs/simulation/compositions/plume-set2-composition-b01-0050.png){#fig:plume-composition-660-b01 width=100%}

\clearpage

![Plume simulations with moderate inflow velocity, intermediate plume strength, and a moderate lower mantle viscosity jump (scenario 0; Table 1 in main text). Description and annotations follow @fig:plume-composition-660-b01.](../figs/simulation/compositions/plume-set2-composition-b50-0050.png){#fig:plume-composition-660-b50 width=100%}

\clearpage

# Structure of the 660: Displacement and Width {.unnumbered #sec:structure-of-the-660}

\clearpage

|Type  | Scenario| $Z_\mathrm{ri}$| Displacement| Width| $\dot{X}_\mathrm{max}$| $\vec{v}_\mathrm{max}$| Regime|
|:-----|--------:|---------------:|------------:|-----:|----------------------:|----------------------:|------:|
|plume |        0|         1.6e+03|        -17.9|   6.5|               2.09e+06|                   2.41|     NA|
|plume |        0|         2.2e+02|        -17.9|   6.5|               2.87e+05|                   2.41|     NA|
|plume |        0|         3.1e+01|        -17.9|   6.5|               4.04e+04|                   2.41|     NA|
|plume |        0|         4.3e+00|        -17.9|   6.5|               5.62e+03|                   2.41|     NA|
|plume |        0|         6.0e-01|        -17.9|   6.5|               7.78e+02|                   2.40|     NA|
|plume |        0|         8.3e-02|        -17.9|   6.5|               1.06e+02|                   2.38|     NA|
|plume |        0|         1.2e-02|        -18.0|   6.6|               1.73e+01|                   2.38|     NA|
|plume |        0|         1.6e-03|        -19.0|   7.1|               3.65e+00|                   2.47|     NA|
|plume |        1|         1.6e+03|        -13.7|   5.2|               2.77e+05|                   2.92|     NA|
|plume |        1|         2.2e+02|        -13.6|   5.2|               3.78e+04|                   2.92|     NA|
|plume |        1|         3.1e+01|        -13.6|   5.2|               5.32e+03|                   2.91|     NA|
|plume |        1|         4.3e+00|        -13.6|   5.2|               7.39e+02|                   2.92|     NA|
|plume |        1|         6.0e-01|        -13.7|   5.2|               1.03e+02|                   2.91|     NA|
|plume |        1|         8.3e-02|        -13.7|   5.4|               1.49e+01|                   2.87|     NA|
|plume |        1|         1.2e-02|        -13.8|   6.4|               4.35e+00|                   3.18|     NA|
|plume |        1|         1.6e-03|        -15.8|   8.8|               3.83e+00|                   3.60|     NA|
|plume |        2|         1.6e+03|        -21.2|   5.4|               1.03e+06|                   3.71|     NA|
|plume |        2|         2.2e+02|        -21.2|   5.4|               1.42e+05|                   3.71|     NA|
|plume |        2|         3.1e+01|        -21.2|   5.4|               2.00e+04|                   3.71|     NA|
|plume |        2|         4.3e+00|        -21.2|   5.4|               2.76e+03|                   3.72|     NA|
|plume |        2|         6.0e-01|        -21.2|   5.4|               3.79e+02|                   3.70|     NA|
|plume |        2|         8.3e-02|        -21.2|   5.4|               5.10e+01|                   3.67|     NA|
|plume |        2|         1.2e-02|        -21.4|   5.8|               1.02e+01|                   3.78|     NA|
|plume |        2|         1.6e-03|        -22.1|   7.9|               4.58e+00|                   4.01|     NA|
|plume |        3|         1.6e+03|        -13.6|   5.2|               1.07e+04|                   4.81|     NA|
|plume |        3|         2.2e+02|        -13.6|   5.2|               1.48e+03|                   4.81|     NA|
|plume |        3|         3.1e+01|        -13.6|   5.2|               2.08e+02|                   4.81|     NA|
|plume |        3|         4.3e+00|        -13.7|   5.2|               2.95e+01|                   4.81|     NA|
|plume |        3|         6.0e-01|        -13.8|   6.3|               8.06e+00|                   5.14|     NA|
|plume |        3|         8.3e-02|        -17.1|   5.8|               6.08e+01|                   4.65|     NA|
|plume |        3|         1.2e-02|        -17.9|   6.6|               2.31e+01|                   4.91|     NA|
|plume |        3|         1.6e-03|        -19.1|   7.9|               5.55e+00|                   5.22|     NA|
|plume |        4|         1.6e+03|        -10.3|   6.9|               3.72e+05|                   4.46|     NA|
|plume |        4|         2.2e+02|        -10.3|   6.9|               5.05e+04|                   4.44|     NA|
|plume |        4|         3.1e+01|        -10.3|   6.9|               6.98e+03|                   4.41|     NA|
|plume |        4|         4.3e+00|        -10.3|   6.8|               9.17e+02|                   4.30|     NA|
|plume |        4|         6.0e-01|        -10.2|   6.8|               1.07e+02|                   4.06|     NA|
|plume |        4|         8.3e-02|        -10.7|   6.8|               2.68e+01|                   4.04|     NA|
|plume |        4|         1.2e-02|        -13.0|   6.7|               1.03e+01|                   3.71|     NA|
|plume |        4|         1.6e-03|        -14.2|   9.2|               3.33e+00|                   3.12|     NA|
|plume |        5|         1.6e+03|        -10.2|   6.8|               4.24e+05|                   4.96|     NA|
|plume |        5|         2.2e+02|        -10.2|   6.8|               5.84e+04|                   4.95|     NA|
|plume |        5|         3.1e+01|        -10.2|   6.8|               8.15e+03|                   4.79|     NA|
|plume |        5|         4.3e+00|        -10.2|   6.7|               1.08e+03|                   4.81|     NA|
|plume |        5|         6.0e-01|        -10.2|   6.7|               1.31e+02|                   4.58|     NA|
|plume |        5|         8.3e-02|        -10.5|   6.7|               2.04e+01|                   4.24|     NA|
|plume |        5|         1.2e-02|        -12.4|   6.9|               8.87e+00|                   3.95|     NA|
|plume |        5|         1.6e-03|        -14.0|   8.8|               3.23e+00|                   3.42|     NA|
|plume |        6|         1.6e+03|        -13.8|   6.3|               1.04e+06|                   7.16|     NA|
|plume |        6|         2.2e+02|        -13.8|   6.3|               1.42e+05|                   7.15|     NA|
|plume |        6|         3.1e+01|        -13.8|   6.3|               2.00e+04|                   7.13|     NA|
|plume |        6|         4.3e+00|        -13.8|   6.3|               2.73e+03|                   7.01|     NA|
|plume |        6|         6.0e-01|        -13.8|   6.3|               3.58e+02|                   6.49|     NA|
|plume |        6|         8.3e-02|        -13.8|   6.2|               4.81e+01|                   6.21|     NA|
|plume |        6|         1.2e-02|        -14.0|   7.2|               1.15e+01|                   6.18|     NA|
|plume |        6|         1.6e-03|        -16.5|   9.9|               6.66e+00|                   5.39|     NA|
|plume |        7|         1.6e+03|        -13.8|   6.2|               1.05e+06|                   8.34|     NA|
|plume |        7|         2.2e+02|        -13.8|   6.2|               1.44e+05|                   8.35|     NA|
|plume |        7|         3.1e+01|        -13.8|   6.2|               2.03e+04|                   8.29|     NA|
|plume |        7|         4.3e+00|        -13.8|   6.2|               2.77e+03|                   8.17|     NA|
|plume |        7|         6.0e-01|        -13.8|   6.1|               3.65e+02|                   7.57|     NA|
|plume |        7|         8.3e-02|        -13.7|   6.1|               4.95e+01|                   7.48|     NA|
|plume |        7|         1.2e-02|        -14.0|   7.1|               1.22e+01|                   7.28|     NA|
|plume |        7|         1.6e-03|        -16.2|  10.1|               6.66e+00|                   6.41|     NA|
|slab  |        0|         1.6e+03|         26.7|  11.0|               1.35e+02|                   0.49|      3|
|slab  |        0|         2.2e+02|         27.3|  11.5|               1.75e+01|                   0.48|      3|
|slab  |        0|         3.1e+01|         29.0|   6.5|               1.67e+00|                   0.32|      3|
|slab  |        0|         4.3e+00|         31.1|   6.1|               6.85e-01|                   0.41|      3|
|slab  |        0|         6.0e-01|         35.2|   8.3|               3.22e-01|                   0.30|      3|
|slab  |        0|         8.3e-02|         40.7|  11.8|               1.58e-01|                   0.20|      3|
|slab  |        0|         1.2e-02|         46.6|  15.0|               7.70e-02|                   0.14|      3|
|slab  |        0|         1.6e-03|         51.4|  16.9|               4.12e-02|                   0.09|      3|
|slab  |        1|         1.6e+03|         22.5|   4.0|               7.16e+00|                   0.61|      1|
|slab  |        1|         2.2e+02|         27.1|  11.3|               1.66e+01|                   0.58|      1|
|slab  |        1|         3.1e+01|         28.2|  12.2|               2.47e+00|                   0.56|      1|
|slab  |        1|         4.3e+00|         30.1|   7.1|               1.24e+00|                   0.54|      1|
|slab  |        1|         6.0e-01|         34.6|   7.8|               5.03e-01|                   0.46|      1|
|slab  |        1|         8.3e-02|         42.9|  13.6|               2.24e-01|                   0.32|      3|
|slab  |        1|         1.2e-02|         50.8|  18.0|               9.75e-02|                   0.20|      3|
|slab  |        1|         1.6e-03|         58.7|  21.4|               5.00e-02|                   0.13|      3|
|slab  |        2|         1.6e+03|         30.0|   5.3|               1.91e+01|                   0.94|      1|
|slab  |        2|         2.2e+02|         30.4|   4.6|               3.15e+00|                   0.91|      1|
|slab  |        2|         3.1e+01|         33.4|   6.7|               1.29e+00|                   0.87|      1|
|slab  |        2|         4.3e+00|         39.7|   9.4|               9.06e-01|                   0.80|      2|
|slab  |        2|         6.0e-01|         48.9|  14.7|               3.95e-01|                   0.61|      2|
|slab  |        2|         8.3e-02|         60.9|  22.0|               1.52e-01|                   0.37|      3|
|slab  |        2|         1.2e-02|         68.9|  25.3|               6.15e-02|                   0.20|      3|
|slab  |        2|         1.6e-03|         74.9|  24.7|               3.81e-02|                   0.14|      3|
|slab  |        3|         1.6e+03|         22.4|   4.0|               3.37e+01|                   1.07|      1|
|slab  |        3|         2.2e+02|         22.5|   4.0|               6.08e+00|                   1.10|      1|
|slab  |        3|         3.1e+01|         28.2|  12.1|               3.59e+00|                   1.05|      1|
|slab  |        3|         4.3e+00|         30.4|   6.8|               2.00e+00|                   1.02|      1|
|slab  |        3|         6.0e-01|         39.8|  11.6|               9.13e-01|                   0.99|      2|
|slab  |        3|         8.3e-02|         52.9|  19.1|               3.38e-01|                   0.67|      2|
|slab  |        3|         1.2e-02|         65.6|  26.7|               1.24e-01|                   0.36|      2|
|slab  |        3|         1.6e-03|         80.5|  33.7|               5.13e-02|                   0.22|      3|
|slab  |        4|         1.6e+03|         25.1|   6.3|               3.44e+00|                   1.55|      1|
|slab  |        4|         2.2e+02|         28.2|   6.0|               2.14e+01|                   1.73|      1|
|slab  |        4|         3.1e+01|         29.9|   7.2|               6.39e+00|                   1.87|      1|
|slab  |        4|         4.3e+00|         33.1|   7.0|               2.24e+00|                   1.68|      1|
|slab  |        4|         6.0e-01|         39.6|  11.8|               9.12e-01|                   1.11|      2|
|slab  |        4|         8.3e-02|         44.0|  13.4|               2.17e-01|                   0.49|      2|
|slab  |        4|         1.2e-02|         43.1|  10.7|               1.12e-01|                   0.31|      3|
|slab  |        4|         1.6e-03|         48.4|  10.8|               6.82e-02|                   0.25|      3|
|slab  |        5|         1.6e+03|         24.4|   5.8|               6.03e+01|                   2.05|      1|
|slab  |        5|         2.2e+02|         24.7|   6.0|               7.22e+00|                   1.92|      1|
|slab  |        5|         3.1e+01|         27.6|   6.8|               4.52e+00|                   1.73|      1|
|slab  |        5|         4.3e+00|         30.0|   7.1|               2.22e+00|                   1.17|      1|
|slab  |        5|         6.0e-01|         39.6|  12.2|               1.41e+00|                   1.71|      2|
|slab  |        5|         8.3e-02|         52.4|  20.0|               6.38e-01|                   1.31|      2|
|slab  |        5|         1.2e-02|         55.8|  20.1|               1.36e-01|                   0.46|      2|
|slab  |        5|         1.6e-03|         57.8|  16.4|               7.96e-02|                   0.29|      3|
|slab  |        6|         1.6e+03|         31.4|   5.4|               2.83e+01|                   3.21|      1|
|slab  |        6|         2.2e+02|         32.5|   6.2|               7.40e+00|                   3.07|      1|
|slab  |        6|         3.1e+01|         36.5|   8.9|               3.45e+00|                   2.85|      1|
|slab  |        6|         4.3e+00|         44.0|  12.2|               1.84e+00|                   2.39|      2|
|slab  |        6|         6.0e-01|         54.7|  18.7|               7.04e-01|                   1.44|      2|
|slab  |        6|         8.3e-02|         55.7|  17.8|               1.36e-01|                   0.44|      2|
|slab  |        6|         1.2e-02|         54.5|  13.1|               1.06e-01|                   0.36|      3|
|slab  |        6|         1.6e-03|         68.4|  13.4|               7.39e-02|                   0.32|      3|
|slab  |        7|         1.6e+03|         28.1|  12.0|               1.04e+02|                   2.29|      1|
|slab  |        7|         2.2e+02|         28.4|  12.3|               1.38e+01|                   2.35|      1|
|slab  |        7|         3.1e+01|         30.0|   7.1|               5.71e+00|                   2.19|      1|
|slab  |        7|         4.3e+00|         34.7|   7.9|               2.25e+00|                   2.01|      1|
|slab  |        7|         6.0e-01|         44.3|  14.6|               1.37e+00|                   2.09|      2|
|slab  |        7|         8.3e-02|         60.3|  23.8|               6.14e-01|                   1.59|      2|
|slab  |        7|         1.2e-02|         79.6|  34.3|               1.94e-01|                   0.91|      2|
|slab  |        7|         1.6e-03|         78.3|  26.1|               7.63e-02|                   0.48|      2|

Table: Summary of the kinetic prefactor $Z_\mathrm{ri}$, 660 structure (displacement and width), maximum reaction rate $\dot{X}_\mathrm{max}$, and maximum vertical velocity through the 660 $\vec{v}_\mathrm{max}$ evaluated in plume and slab simulations after 50 and 100 Ma of evolution, respectively. Kinetic regimes correspond to 1: quasi-equilibrium, 2: intermediate, 3: stagnation. Units are $Z_\mathrm{ri}$: mol$^2$ J$^{-2}$ s$^{-1}$, displacement: km, width: km, $\dot{X}_\mathrm{max}$: Ma$^{-1}$, $\vec{v}_\mathrm{max}$: cm yr$^{-1}$. Note that displacement values are signed: positive values indicate downward displacement of the 660 below the nominal equilibrium depth, while negative values indicate upward displacement above the nominal equilibrium depth. {#tbl:depth-profile-summary}

\clearpage

# References {.unnumbered #sec:references}

::: {#refs}
:::
