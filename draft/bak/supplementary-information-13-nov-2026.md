# Contents of this file {.unnumbered #sec:contents}

1. Figures -@fig:material-property-profiles to -@fig:slab-scen11-set2
2. @tbl:depth-profile-summary

\clearpage

# Introduction {.unnumbered #sec:introduction}

This supplementary information provides 18 figures and one table that support the material model, kinetic calibration, and quantitative simulation results described in the main text.

Figures -@fig:material-property-profiles and -@fig:thermodynamic-property-profiles show the reference material and thermodynamic properties used to initialize and drive the compressible mantle flow simulations. These profiles give the density, thermal expansivity, compressibility, and specific heat capacity of each mantle phase across the transition zone, along with the Gibbs free energy, entropy, and volume changes that govern the 410, 520, and 660 phase transitions.

@fig:regression presents the Monte Carlo regression used to calibrate the ringwoodite decomposition kinetic rate equation against the high-overpressure experimental dataset of @kubo2002. This regression constrains the activation energy and growth-rate prefactor within the uncertainties reported in the main text. @fig:kubo-parameter-ranges projects the $\pm$ 2$\sigma$ uncertainty in $\ln(K^{\prime})$ onto the kinetic prefactor $Z_\mathrm{ri}$ across grain sizes of 1--10 mm (1.7e-11 to 2.6e9 mol$^2$ J$^{-2}$ s$^{-1}$) and shows that both the *Sluggish Kinetics / Warm Slabs* (SW; 5.08e-11 to 5.08e-5 mol$^2$ J$^{-2}$ s$^{-1}$) and *Nominal Kinetics / Cold Slabs* (NC; 1.6e-3 to 1.6e3 mol$^2$ J$^{-2}$ s$^{-1}$) suites fall within the 95% confidence interval.

Figures -@fig:slab-scen04-set2 to -@fig:slab-scen11-set2 show representative slab simulation snapshots spanning slow, intermediate, and fast $Z_\mathrm{ri}$ after 100 Ma across four kinematic and rheological scenarios in each suite: scenarios 4, 0, 6, and 3 in the SW suite (Figures -@fig:slab-scen04-set2 to -@fig:slab-scen03-set2) and scenarios 12, 8, 14, and 11 in the NC suite (Figures -@fig:slab-scen12-set2 to -@fig:slab-scen11-set2). Together with the reference snapshots for scenarios 4 and 12 in the main text (Figures 3 and 4), each scenario is presented in two field sets showing dynamic temperature $\hat{T}$, dynamic density $\hat{\rho}$, and vertical velocity $\vec{u}_y$, and dynamic temperature $\hat{T}$, log viscosity $\eta$, and post-spinel volume fraction $X_\mathrm{ps}$. These snapshots illustrate how the three kinetic regimes at the 660 (quasi-equilibrium, intermediate, and stagnation) interact with inflow velocity, slab strength, and lower-mantle viscosity contrast across both suites.

@tbl:depth-profile-summary reports the kinetic prefactor $Z_\mathrm{ri}$, total 660 displacement ($\delta z$) and transition width ($\delta w$), maximum reaction rate ($\dot{X}_\mathrm{max}$), maximum descent velocity through the 660 ($\vec{v}_\mathrm{max}$), thermal ($\delta z_t$) and kinetic ($\delta z_k$) displacement contributions, and kinetic regime for all 132 slab simulations across scenarios 0--19 (Table 1 in the main text). These values underlie the quantitative trends and figures discussed in the main text.

\clearpage

# Material Model (Figures S1--S4) {.unnumbered #sec:material-model}

![Reference material properties used in ASPECT simulations showing density ($\bar{\rho}$), thermal expansivity ($\bar{\alpha}$), compressibility ($\bar{\beta}$), and specific heat capacity ($\bar{C}_p$). Colored profiles are for pure Mg olivine (ol), wadsleyite (wd), ringwoodite (ri), and the post-spinel (ps) assemblage bridgmanite + periclase. Profiles are computed using the methods described in Section 2.2.1 in the main text. Gray bands indicate the 410, 520, and 660 transitions.](../figs/adiabat/material-property-profiles.png){#fig:material-property-profiles width=100%}

![Reference thermodynamic properties used in our ASPECT simulations. Colored profiles are for pure Mg olivine (ol), wadsleyite (wd), ringwoodite (ri), and the post-spinel (ps) assemblage bridgmanite + periclase. Profiles are computed using the same methods as described in @fig:material-property-profiles (see Section 2.2.1 in the main text). Gray bands indicate the 410, 520, and 660 transitions.](../figs/adiabat/thermodynamic-property-profiles.png){#fig:thermodynamic-property-profiles width=80%}

![Monte Carlo regression of high-overpressure experimental data from @kubo2002. The best-fit activation energy $E^{\ast}$ = 310 $\pm$ 233 kJ mol$^{-1}$ (2$\sigma$) and growth-rate prefactor $\ln(K^{\prime})$ = -29.8 $\pm$ 22.1 are both consistent with @kubo2002 within uncertainty. The large uncertainties in $E^{\ast}$ and $\ln(K^{\prime})$ reflect the small number of data points and relatively large experimental $T$ uncertainties.](../figs/kubo/regression.png){#fig:regression width=68%}

![Permitted $Z_\mathrm{ri}$ range across grain size $d$ derived from the Monte Carlo regression in @fig:regression ($Z_\mathrm{ri} = \text{6.67}\, K^{\prime}\, /\, d\, \bar{V}_\mathrm{ps}^2$, with $\ln(K^{\prime})$ = -29.8 $\pm$ 22.1 at 2$\sigma$ and $\bar{V}_\mathrm{ps}$ = 3.381e-5 m$^3$ mol$^{-1}$). The gray band and dashed lines mark the 95% confidence interval (1.7e-11 to 2.6e9 mol$^2$ J$^{-2}$ s$^{-1}$ across $d$ = 1--10 mm), and the solid black line shows the best-fit trend ($Z_\mathrm{ri} \sim$ 0.07--0.7 mol$^2$ J$^{-2}$ s$^{-1}$). Red and blue shaded bands indicate the six-order-of-magnitude $Z_\mathrm{ri}$ ranges sampled in the SW (5.08e-11 to 5.08e-5 mol$^2$ J$^{-2}$ s$^{-1}$) and NC (1.6e-3 to 1.6e3 mol$^2$ J$^{-2}$ s$^{-1}$) suites.](../figs/kubo/kubo-parameter-ranges.png){#fig:kubo-parameter-ranges width=63%}

\clearpage

# Simulation Snapshots: Slabs (Figures S5--S18) {.unnumbered #sec:simulation-snapshots}

![SW suite simulations for scenario 4 ($\Delta T_0$ = -500 K, $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$, $B$ = 5, $b$ = 1; Table 1 in the main text) after 100 Ma, showing dynamic temperature $\hat{T}$ (left column), log viscosity $\eta$ (middle column), and post-spinel volume fraction $X_\mathrm{ps}$ (right column) across stagnation (top row: $Z_\mathrm{ri}$ = 5.08e-11 mol$^2$ J$^{-2}$ s$^{-1}$), intermediate (middle row: $Z_\mathrm{ri}$ = 1.90e-8 mol$^2$ J$^{-2}$ s$^{-1}$), and quasi-equilibrium (bottom row: $Z_\mathrm{ri}$ = 5.08e-5 mol$^2$ J$^{-2}$ s$^{-1}$) kinetic regimes (companion to Figure 3 in the main text). Thick black lines highlight the 10% and 90% wadsleyite and post-spinel volume fraction contours used to define 410 and 660 displacement ($\delta z$) and width ($\delta w$). The background grid indicates ASPECT's adaptive mesh refinement near high thermal gradients and phase transitions. The white trace indicates the representative depth profile used to extract data, and the white arrows mark where transition structure is evaluated.](../figs/simulation/compositions/slab-set2-composition-scen04-0100.png){#fig:slab-scen04-set2 width=100%}

\clearpage

![SW suite simulations for scenario 0 ($\Delta T_0$ = -500 K, $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$, $B$ = 5, $b$ = 50) after 100 Ma, showing dynamic temperature $\hat{T}$ (left column), dynamic density $\hat{\rho}$ (middle column), and vertical velocity $\vec{u}_y$ (right column). All other annotations follow @fig:slab-scen04-set2. The 50-fold lower-mantle viscosity jump slows descent below the 0.5 cm yr$^{-1}$ stagnation threshold across all three rows.](../figs/simulation/compositions/slab-set1-composition-scen00-0100.png){#fig:slab-scen00-set1 width=100%}

\clearpage

![SW suite simulations for scenario 0 ($\Delta T_0$ = -500 K, $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$, $B$ = 5, $b$ = 50) after 100 Ma, showing $\hat{T}$, $\eta$, and $X_\mathrm{ps}$ (companion to @fig:slab-scen00-set1; annotations follow @fig:slab-scen04-set2).](../figs/simulation/compositions/slab-set2-composition-scen00-0100.png){#fig:slab-scen00-set2 width=100%}

\clearpage

![SW suite simulations for scenario 6 ($\Delta T_0$ = -500 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 5, $b$ = 1) after 100 Ma, showing $\hat{T}$, $\hat{\rho}$, and $\vec{u}_y$ (annotations follow @fig:slab-scen04-set2). Faster inflow advects more metastable ringwoodite to depth, broadening and deepening the 660 across stagnation (top row), intermediate (middle row), and quasi-equilibrium (bottom row) regimes.](../figs/simulation/compositions/slab-set1-composition-scen06-0100.png){#fig:slab-scen06-set1 width=100%}

\clearpage

![SW suite simulations for scenario 6 ($\Delta T_0$ = -500 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 5, $b$ = 1) after 100 Ma, showing $\hat{T}$, $\eta$, and $X_\mathrm{ps}$ (companion to @fig:slab-scen06-set1; annotations follow @fig:slab-scen04-set2).](../figs/simulation/compositions/slab-set2-composition-scen06-0100.png){#fig:slab-scen06-set2 width=100%}

\clearpage

![SW suite simulations for scenario 3 ($\Delta T_0$ = -500 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 10, $b$ = 50) after 100 Ma, showing $\hat{T}$, $\hat{\rho}$, and $\vec{u}_y$ (annotations follow @fig:slab-scen04-set2). High slab strength and fast inflow produce the deepest ($\delta z$ = 80.5 km, $\delta z_k$ = 64.1 km) and widest ($\delta w$ = 33.7 km) 660 in the stagnation regime (top row) while maintaining penetration in the intermediate (middle row) and quasi-equilibrium (bottom row) regimes despite $b$ = 50.](../figs/simulation/compositions/slab-set1-composition-scen03-0100.png){#fig:slab-scen03-set1 width=100%}

\clearpage

![SW suite simulations for scenario 3 ($\Delta T_0$ = -500 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 10, $b$ = 50) after 100 Ma, showing $\hat{T}$, $\eta$, and $X_\mathrm{ps}$ (companion to @fig:slab-scen03-set1; annotations follow @fig:slab-scen04-set2).](../figs/simulation/compositions/slab-set2-composition-scen03-0100.png){#fig:slab-scen03-set2 width=100%}

\clearpage

![NC suite simulations for scenario 12 ($\Delta T_0$ = -1000 K, $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$, $B$ = 5, $b$ = 1) after 100 Ma, showing $\hat{T}$, $\eta$, and $X_\mathrm{ps}$ across $Z_\mathrm{ri}$ = 1.6e-3 (top row), 6.0e-1 (middle row), and 1.6e3 (bottom row) mol$^2$ J$^{-2}$ s$^{-1}$ (companion to Figure 4 in the main text; annotations follow @fig:slab-scen04-set2).](../figs/simulation/compositions/slab-set2-composition-scen12-0100.png){#fig:slab-scen12-set2 width=100%}

\clearpage

![NC suite simulations for scenario 8 ($\Delta T_0$ = -1000 K, $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$, $B$ = 5, $b$ = 50) after 100 Ma, showing $\hat{T}$, $\hat{\rho}$, and $\vec{u}_y$ (annotations follow @fig:slab-scen04-set2). The 50-fold lower-mantle viscosity jump slows and folds the cold slab without inducing kinetic broadening or stagnation across any tested $Z_\mathrm{ri}$.](../figs/simulation/compositions/slab-set1-composition-scen08-0100.png){#fig:slab-scen08-set1 width=100%}

\clearpage

![NC suite simulations for scenario 8 ($\Delta T_0$ = -1000 K, $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$, $B$ = 5, $b$ = 50) after 100 Ma, showing $\hat{T}$, $\eta$, and $X_\mathrm{ps}$ (companion to @fig:slab-scen08-set1; annotations follow @fig:slab-scen04-set2).](../figs/simulation/compositions/slab-set2-composition-scen08-0100.png){#fig:slab-scen08-set2 width=100%}

\clearpage

![NC suite simulations for scenario 14 ($\Delta T_0$ = -1000 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 5, $b$ = 1) after 100 Ma, showing $\hat{T}$, $\hat{\rho}$, and $\vec{u}_y$ (annotations follow @fig:slab-scen04-set2). Fast descent ($\vec{v}_\mathrm{max}$ = 4.8--6.6 cm yr$^{-1}$) drives the slowest nominal $Z_\mathrm{ri}$ (top row: $Z_\mathrm{ri}$ = 1.6e-3 mol$^2$ J$^{-2}$ s$^{-1}$) into the intermediate regime ($L$ = 13.0 km, $\delta z_k$ = 22.3 km, $\delta w$ = 13.1 km), while faster $Z_\mathrm{ri}$ rows (middle and bottom) remain in quasi-equilibrium.](../figs/simulation/compositions/slab-set1-composition-scen14-0100.png){#fig:slab-scen14-set1 width=100%}

\clearpage

![NC suite simulations for scenario 14 ($\Delta T_0$ = -1000 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 5, $b$ = 1) after 100 Ma, showing $\hat{T}$, $\eta$, and $X_\mathrm{ps}$ (companion to @fig:slab-scen14-set1; annotations follow @fig:slab-scen04-set2).](../figs/simulation/compositions/slab-set2-composition-scen14-0100.png){#fig:slab-scen14-set2 width=100%}

\clearpage

![NC suite simulations for scenario 11 ($\Delta T_0$ = -1000 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 10, $b$ = 50) after 100 Ma, showing $\hat{T}$, $\hat{\rho}$, and $\vec{u}_y$ (annotations follow @fig:slab-scen04-set2). All three rows remain in the quasi-equilibrium regime with $\delta z_k$ = 5.8--7.3 km.](../figs/simulation/compositions/slab-set1-composition-scen11-0100.png){#fig:slab-scen11-set1 width=100%}

\clearpage

![NC suite simulations for scenario 11 ($\Delta T_0$ = -1000 K, $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$, $B$ = 10, $b$ = 50) after 100 Ma, showing $\hat{T}$, $\eta$, and $X_\mathrm{ps}$ (companion to @fig:slab-scen11-set1; annotations follow @fig:slab-scen04-set2).](../figs/simulation/compositions/slab-set2-composition-scen11-0100.png){#fig:slab-scen11-set2 width=100%}

\clearpage

# Structure of the 660: Displacement, Width, and Thermal-Kinetic Contributions {.unnumbered #sec:structure-of-the-660}

|Suite | Scenario| $Z_\mathrm{ri}$|   $\delta z$| $\delta w$| $\dot{X}_\mathrm{max}$| $\vec{v}_\mathrm{max}$| $\delta z_t$| $\delta z_k$| Regime|
|:-----|--------:|---------------:|------------:|----------:|----------------------:|----------------------:|------------:|------------:|------:|
|SW    |        0|         5.1e-05|         26.7|       11.0|               1.35e+02|                   0.49|         18.0|          8.7|      3|
|SW    |        0|         7.0e-06|         27.3|       11.5|               1.75e+01|                   0.48|         18.0|          9.3|      3|
|SW    |        0|         9.8e-07|         29.0|        6.5|               1.67e+00|                   0.32|         17.9|         11.1|      3|
|SW    |        0|         1.4e-07|         31.1|        6.1|               6.85e-01|                   0.41|         17.7|         13.3|      3|
|SW    |        0|         1.9e-08|         35.2|        8.3|               3.22e-01|                   0.30|         17.7|         17.5|      3|
|SW    |        0|         2.6e-09|         40.7|       11.8|               1.58e-01|                   0.20|         17.1|         23.6|      3|
|SW    |        0|         3.8e-10|         46.6|       15.0|               7.70e-02|                   0.14|         15.5|         31.1|      3|
|SW    |        0|         5.1e-11|         51.4|       16.9|               4.12e-02|                   0.09|         12.8|         38.6|      3|
|SW    |        1|         5.1e-05|         22.5|        4.0|               7.16e+00|                   0.61|         15.7|          6.7|      1|
|SW    |        1|         7.0e-06|         27.1|       11.3|               1.66e+01|                   0.58|         16.9|         10.1|      1|
|SW    |        1|         9.8e-07|         28.2|       12.2|               2.47e+00|                   0.56|         16.9|         11.3|      1|
|SW    |        1|         1.4e-07|         30.1|        7.1|               1.24e+00|                   0.54|         16.5|         13.6|      1|
|SW    |        1|         1.9e-08|         34.6|        7.8|               5.03e-01|                   0.46|         16.8|         17.8|      3|
|SW    |        1|         2.6e-09|         42.9|       13.6|               2.24e-01|                   0.32|         16.8|         26.1|      3|
|SW    |        1|         3.8e-10|         50.8|       18.0|               9.75e-02|                   0.20|         15.9|         35.0|      3|
|SW    |        1|         5.1e-11|         58.7|       21.4|               5.00e-02|                   0.13|         13.6|         45.1|      3|
|SW    |        2|         5.1e-05|         30.0|        5.3|               1.91e+01|                   0.94|         20.3|          9.7|      1|
|SW    |        2|         7.0e-06|         30.4|        4.6|               3.15e+00|                   0.91|         20.2|         10.2|      1|
|SW    |        2|         9.8e-07|         33.4|        6.7|               1.29e+00|                   0.87|         20.9|         12.4|      2|
|SW    |        2|         1.4e-07|         39.7|        9.4|               9.06e-01|                   0.80|         21.1|         18.6|      2|
|SW    |        2|         1.9e-08|         48.9|       14.7|               3.95e-01|                   0.61|         21.2|         27.7|      2|
|SW    |        2|         2.6e-09|         60.9|       22.0|               1.52e-01|                   0.37|         21.1|         39.8|      3|
|SW    |        2|         3.8e-10|         68.9|       25.3|               6.15e-02|                   0.20|         19.6|         49.2|      3|
|SW    |        2|         5.1e-11|         74.9|       24.7|               3.81e-02|                   0.14|         16.4|         58.5|      3|
|SW    |        3|         5.1e-05|         22.4|        4.0|               3.37e+01|                   1.07|         14.6|          7.9|      1|
|SW    |        3|         7.0e-06|         22.5|        4.0|               6.08e+00|                   1.10|         14.5|          8.0|      1|
|SW    |        3|         9.8e-07|         28.2|       12.1|               3.59e+00|                   1.05|         16.3|         11.9|      1|
|SW    |        3|         1.4e-07|         30.4|        6.8|               2.00e+00|                   1.02|         15.7|         14.7|      2|
|SW    |        3|         1.9e-08|         39.8|       11.6|               9.13e-01|                   0.99|         17.2|         22.7|      2|
|SW    |        3|         2.6e-09|         52.9|       19.1|               3.38e-01|                   0.67|         17.9|         35.0|      2|
|SW    |        3|         3.8e-10|         65.6|       26.7|               1.24e-01|                   0.36|         17.7|         47.9|      3|
|SW    |        3|         5.1e-11|         80.5|       33.7|               5.13e-02|                   0.22|         16.4|         64.1|      3|
|SW    |        4|         5.1e-05|         25.1|        6.3|               3.44e+00|                   1.55|         16.5|          8.6|      1|
|SW    |        4|         7.0e-06|         28.2|        6.0|               2.14e+01|                   1.73|         16.7|         11.5|      1|
|SW    |        4|         9.8e-07|         29.9|        7.2|               6.39e+00|                   1.87|         16.9|         13.1|      1|
|SW    |        4|         1.4e-07|         33.1|        7.0|               2.24e+00|                   1.68|         17.0|         16.1|      2|
|SW    |        4|         1.9e-08|         39.6|       11.8|               9.12e-01|                   1.11|         17.1|         22.4|      2|
|SW    |        4|         2.6e-09|         44.0|       13.4|               2.17e-01|                   0.49|         17.2|         26.9|      3|
|SW    |        4|         3.8e-10|         43.1|       10.7|               1.12e-01|                   0.31|         13.4|         29.7|      3|
|SW    |        4|         5.1e-11|         48.4|       10.8|               6.82e-02|                   0.25|         11.0|         37.4|      3|
|SW    |        5|         5.1e-05|         24.4|        5.8|               6.03e+01|                   2.05|         15.0|          9.5|      1|
|SW    |        5|         7.0e-06|         24.7|        6.0|               7.22e+00|                   1.92|         15.2|          9.5|      1|
|SW    |        5|         9.8e-07|         27.6|        6.8|               4.52e+00|                   1.73|         15.7|         11.9|      1|
|SW    |        5|         1.4e-07|         30.0|        7.1|               2.22e+00|                   1.17|         15.6|         14.4|      2|
|SW    |        5|         1.9e-08|         39.6|       12.2|               1.41e+00|                   1.71|         16.2|         23.4|      2|
|SW    |        5|         2.6e-09|         52.4|       20.0|               6.38e-01|                   1.31|         16.3|         36.1|      2|
|SW    |        5|         3.8e-10|         55.8|       20.1|               1.36e-01|                   0.46|         16.0|         39.8|      3|
|SW    |        5|         5.1e-11|         57.8|       16.4|               7.96e-02|                   0.29|         12.1|         45.7|      3|
|SW    |        6|         5.1e-05|         31.4|        5.4|               2.83e+01|                   3.21|         20.6|         10.7|      1|
|SW    |        6|         7.0e-06|         32.5|        6.2|               7.40e+00|                   3.07|         20.7|         11.9|      1|
|SW    |        6|         9.8e-07|         36.5|        8.9|               3.45e+00|                   2.85|         20.7|         15.8|      2|
|SW    |        6|         1.4e-07|         44.0|       12.2|               1.84e+00|                   2.39|         20.9|         23.2|      2|
|SW    |        6|         1.9e-08|         54.7|       18.7|               7.04e-01|                   1.44|         21.1|         33.7|      2|
|SW    |        6|         2.6e-09|         55.7|       17.8|               1.36e-01|                   0.44|         20.6|         35.1|      3|
|SW    |        6|         3.8e-10|         54.5|       13.1|               1.06e-01|                   0.36|         15.9|         38.5|      3|
|SW    |        6|         5.1e-11|         68.4|       13.4|               7.39e-02|                   0.32|         13.9|         54.5|      3|
|SW    |        7|         5.1e-05|         28.1|       12.0|               1.04e+02|                   2.29|         17.4|         10.7|      1|
|SW    |        7|         7.0e-06|         28.4|       12.3|               1.38e+01|                   2.35|         17.4|         11.1|      1|
|SW    |        7|         9.8e-07|         30.0|        7.1|               5.71e+00|                   2.19|         17.1|         12.9|      1|
|SW    |        7|         1.4e-07|         34.7|        7.9|               2.25e+00|                   2.01|         17.7|         17.0|      2|
|SW    |        7|         1.9e-08|         44.3|       14.6|               1.37e+00|                   2.09|         17.5|         26.8|      2|
|SW    |        7|         2.6e-09|         60.3|       23.8|               6.14e-01|                   1.59|         17.7|         42.6|      2|
|SW    |        7|         3.8e-10|         79.6|       34.3|               1.94e-01|                   0.91|         18.3|         61.4|      2|
|SW    |        7|         5.1e-11|         78.3|       26.1|               7.63e-02|                   0.48|         14.9|         63.5|      3|
|NC    |        8|         1.6e+03|         35.8|        5.9|               9.49e+03|                   0.98|         30.2|          5.6|      1|
|NC    |        8|         2.2e+02|         35.9|        6.0|               6.82e+03|                   0.99|         29.9|          6.0|      1|
|NC    |        8|         3.1e+01|         39.0|        5.4|               9.14e+04|                   1.04|         30.7|          8.4|      1|
|NC    |        8|         4.3e+00|         39.0|        5.4|               1.11e+04|                   1.01|         30.8|          8.2|      1|
|NC    |        8|         6.0e-01|         39.0|        5.4|               1.67e+03|                   1.01|         30.7|          8.3|      1|
|NC    |        8|         8.3e-02|         39.0|        5.4|               2.35e+02|                   1.01|         30.7|          8.3|      1|
|NC    |        8|         1.2e-02|         39.0|        5.4|               3.41e+01|                   1.02|         30.7|          8.3|      1|
|NC    |        8|         1.6e-03|         39.3|        5.7|               4.72e+00|                   1.02|         30.8|          8.6|      1|
|NC    |        9|         1.6e+03|         27.9|       12.0|               2.27e+09|                   1.03|         20.8|          7.1|      1|
|NC    |        9|         2.2e+02|         28.1|       12.2|               3.18e+08|                   0.98|         21.0|          7.1|      1|
|NC    |        9|         3.1e+01|         27.9|       12.0|               4.53e+07|                   0.96|         21.0|          7.0|      1|
|NC    |        9|         4.3e+00|         29.8|       13.8|               5.79e+06|                   0.97|         20.8|          9.0|      1|
|NC    |        9|         6.0e-01|         27.9|       12.0|               8.81e+05|                   0.93|         20.9|          7.0|      1|
|NC    |        9|         8.3e-02|         27.9|       11.9|               1.11e+05|                   0.96|         21.0|          7.0|      1|
|NC    |        9|         1.2e-02|         29.3|       13.2|               1.51e+04|                   1.00|         20.8|          8.4|      1|
|NC    |        9|         1.6e-03|         29.7|        4.8|               9.72e+02|                   1.09|         20.5|          9.2|      1|
|NC    |       10|         1.6e+03|         36.4|        3.2|               1.21e+07|                   1.55|         29.6|          6.8|      1|
|NC    |       10|         2.2e+02|         36.4|        3.2|               1.51e+06|                   1.51|         29.1|          7.3|      1|
|NC    |       10|         3.1e+01|         38.6|        5.0|               1.53e+04|                   1.69|         32.0|          6.5|      1|
|NC    |       10|         4.3e+00|         38.6|        5.0|               1.83e+03|                   1.67|         32.1|          6.4|      1|
|NC    |       10|         6.0e-01|         38.6|        5.0|               2.39e+02|                   1.73|         32.2|          6.4|      1|
|NC    |       10|         8.3e-02|         38.8|        5.2|               7.66e+00|                   1.61|         33.2|          5.6|      1|
|NC    |       10|         1.2e-02|         45.5|        6.7|               4.57e+00|                   1.49|         35.2|         10.2|      1|
|NC    |       10|         1.6e-03|         46.2|        5.3|               3.99e+00|                   1.56|         33.7|         12.5|      1|
|NC    |       11|         1.6e+03|         22.6|        4.1|               7.27e+06|                   1.50|         16.7|          5.8|      1|
|NC    |       11|         2.2e+02|         22.8|        4.3|               2.00e+05|                   1.67|         16.7|          6.2|      1|
|NC    |       11|         3.1e+01|         22.8|        4.3|               5.46e+04|                   1.55|         16.7|          6.2|      1|
|NC    |       11|         4.3e+00|         22.7|        4.2|               2.02e+04|                   1.59|         16.6|          6.1|      1|
|NC    |       11|         6.0e-01|         22.5|        4.0|               1.15e+03|                   1.51|         16.7|          5.8|      1|
|NC    |       11|         8.3e-02|         22.8|        4.3|               2.62e+02|                   1.53|         16.6|          6.2|      1|
|NC    |       11|         1.2e-02|         27.8|       11.9|               1.86e+04|                   1.85|         20.4|          7.3|      1|
|NC    |       11|         1.6e-03|         27.6|       11.4|               2.07e+03|                   1.56|         20.3|          7.3|      1|
|NC    |       12|         1.6e+03|         37.4|        8.1|               3.26e+07|                   3.04|         29.6|          7.8|      1|
|NC    |       12|         2.2e+02|         37.4|        8.1|               4.49e+06|                   3.04|         29.6|          7.8|      1|
|NC    |       12|         3.1e+01|         37.4|        8.1|               6.32e+05|                   3.04|         29.6|          7.8|      1|
|NC    |       12|         4.3e+00|         37.4|        8.1|               8.78e+04|                   3.06|         29.6|          7.8|      1|
|NC    |       12|         6.0e-01|         37.4|        8.1|               1.22e+04|                   3.05|         29.6|          7.8|      1|
|NC    |       12|         8.3e-02|         37.4|        8.1|               1.69e+03|                   3.02|         29.6|          7.8|      1|
|NC    |       12|         1.2e-02|         38.4|        7.5|               1.93e+02|                   3.04|         29.6|          8.9|      1|
|NC    |       12|         1.6e-03|         40.1|        6.3|               2.44e+01|                   2.96|         29.6|         10.5|      1|
|NC    |       13|         1.6e+03|         32.6|        6.2|               6.54e+08|                   2.93|         21.8|         10.8|      1|
|NC    |       13|         2.2e+02|         32.6|        6.2|               9.05e+07|                   2.93|         21.8|         10.8|      1|
|NC    |       13|         3.1e+01|         32.6|        6.2|               1.26e+07|                   2.91|         21.8|         10.8|      1|
|NC    |       13|         4.3e+00|         32.6|        6.2|               1.77e+06|                   2.93|         21.8|         10.8|      1|
|NC    |       13|         6.0e-01|         32.6|        6.2|               2.46e+05|                   2.92|         21.8|         10.8|      1|
|NC    |       13|         8.3e-02|         32.6|        6.2|               3.38e+04|                   2.92|         21.8|         10.8|      1|
|NC    |       13|         1.2e-02|         32.6|        6.2|               4.85e+03|                   2.94|         21.8|         10.8|      1|
|NC    |       13|         1.6e-03|         32.6|        6.2|               6.38e+02|                   2.92|         21.8|         10.8|      1|
|NC    |       14|         1.6e+03|         45.7|        8.3|               9.47e+04|                   6.34|         38.8|          6.9|      1|
|NC    |       14|         2.2e+02|         45.7|        8.3|               1.33e+04|                   6.31|         38.8|          6.9|      1|
|NC    |       14|         3.1e+01|         45.9|        8.3|               1.64e+03|                   6.62|         39.0|          6.9|      1|
|NC    |       14|         4.3e+00|         46.6|        7.6|               1.86e+02|                   6.39|         38.8|          7.8|      1|
|NC    |       14|         6.0e-01|         46.7|        7.3|               4.47e+01|                   5.53|         38.1|          8.6|      1|
|NC    |       14|         8.3e-02|         48.1|        6.5|               1.46e+01|                   5.37|         38.0|         10.1|      1|
|NC    |       14|         1.2e-02|         53.8|       10.2|               7.02e+00|                   5.52|         38.3|         15.5|      2|
|NC    |       14|         1.6e-03|         60.1|       13.1|               3.72e+00|                   4.83|         37.8|         22.3|      2|
|NC    |       15|         1.6e+03|         29.3|       12.8|               2.09e+09|                   4.58|         21.0|          8.3|      1|
|NC    |       15|         2.2e+02|         29.3|       12.8|               2.86e+08|                   4.59|         21.0|          8.2|      1|
|NC    |       15|         3.1e+01|         29.3|       12.8|               4.01e+07|                   4.63|         21.1|          8.2|      1|
|NC    |       15|         4.3e+00|         29.3|       12.8|               5.59e+06|                   4.62|         21.0|          8.3|      1|
|NC    |       15|         6.0e-01|         29.3|       12.8|               7.80e+05|                   4.57|         21.1|          8.2|      1|
|NC    |       15|         8.3e-02|         29.2|       12.7|               1.09e+05|                   4.50|         21.0|          8.2|      1|
|NC    |       15|         1.2e-02|         29.4|        6.8|               1.53e+04|                   4.51|         21.0|          8.4|      1|
|NC    |       15|         1.6e-03|         31.0|        6.4|               1.02e+03|                   4.56|         21.0|         10.1|      1|
|T1    |       16|         6.0e-01|         37.5|        7.7|               1.14e+04|                   3.10|         29.8|          7.8|      1|
|T2    |       17|         6.0e-01|         37.5|        7.9|               1.18e+04|                   3.05|         29.7|          7.8|      1|
|T3    |       18|         6.0e-01|         44.0|        7.2|               1.32e+02|                   5.46|         35.9|          8.1|      1|
|T4    |       19|         6.0e-01|         43.9|       11.8|               1.19e+02|                   3.96|         37.0|          6.8|      1|

Table: Summary of kinetic prefactor $Z_\mathrm{ri}$, total 660 displacement ($\delta z$) and transition width ($\delta w$), maximum reaction rate ($\dot{X}_\mathrm{max}$), maximum descent velocity through the 660 ($\vec{v}_\mathrm{max}$), thermal ($\delta z_t$) and kinetic ($\delta z_k$) displacement contributions, and kinetic regime across all 20 scenarios (SW: *Sluggish Kinetics / Warm Slabs*, scenarios 0--7; NC: *Nominal Kinetics / Cold Slabs*, scenarios 8--15; T1--T4: sluggish-410 sensitivity tests, scenarios 16--19; see Table 1 in the main text). Units are $Z_\mathrm{ri}$: mol$^2$ J$^{-2}$ s$^{-1}$; $\delta z$, $\delta w$, $\delta z_t$, and $\delta z_k$: km; $\dot{X}_\mathrm{max}$: Ma$^{-1}$; $\vec{v}_\mathrm{max}$: cm yr$^{-1}$. Regimes correspond to 1: quasi-equilibrium, 2: intermediate, and 3: stagnation. {#tbl:depth-profile-summary}

\clearpage

# References {.unnumbered #sec:references}

::: {#refs}
:::
