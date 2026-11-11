<!--
# Abstract {.unnumbered #sec:abstract}

The 660 km seismic discontinuity ('660') beneath some subduction zones exhibits 30--60 km deep, broad transitions far exceeding the $\sim$ 3--16 km displacements predicted by cold slab temperatures and experimentally-determined Clapeyron slopes (-0.4 to -1.3 MPa K$^{-1}$). Recent studies emphasize compositional or hydration effects, leaving the impact of diffusion-controlled ringwoodite decomposition kinetics unexplored. Here we couple experimentally calibrated olivine $\Leftrightarrow$ wadsleyite $\Leftrightarrow$ ringwoodite $\Leftrightarrow$ post-spinel kinetics to 2D compressible subduction simulations, varying the ringwoodite $\Leftrightarrow$ post-spinel kinetic prefactor $Z_\mathrm{ri}$ alongside slab temperature, strength, inflow velocity, and lower-mantle viscosity jump. Under the most sluggish kinetics permitted by experimental uncertainty, delayed ringwoodite decomposition amplifies thermal displacements of the 660 by 2--5 times and independently promotes slab stagnation, even in warm slabs. As reaction rates decrease, buoyant metastable ringwoodite drives slabs from penetration to stagnation, slowing descent up to tenfold, broadening the 660 to 34 km, and adding up to 64 km of kinetic displacement (80 km total). Kinetic stagnation at the 660 is progressive and persistent, a behavior essential for interpreting transition-zone seismic signatures and slab morphologies. Under nominal ringwoodite kinetics ($Z_\mathrm{ri}$ best-fit to experimental data), rapid ringwoodite decomposition holds the 660 near its equilibrium depth (6--12 km kinetic displacement), even in cold slabs. While nominal ringwoodite kinetics imply mostly thermal and/or compositional effects displacing the 660, sluggish ringwoodite kinetics reconcile 30--60 km depressions with modest Clapeyron slopes, motivating new experiments to address large laboratory uncertainties and natural variations in grain-size, water, and Fe-Mg content in slabs.

\clearpage

# Plain Language Summary {.unnumbered #sec:plain-language-summary}

Near 660 kilometers beneath Earth's surface, the mineral ringwoodite breaks down into denser lower-mantle minerals, creating a global seismic boundary. Beneath some sinking tectonic plates (slabs), seismic studies image this boundary 30 to 60 kilometers deeper and much thicker than normal, far exceeding the 3 to 16 kilometer shift expected from cold slab temperatures alone. Recent explanations emphasize rock composition or water, but here we use computer simulations of sinking slabs to test the impact of ringwoodite reaction speeds (kinetics). Under the slowest reaction speeds permitted by experimental uncertainty, delayed ringwoodite breakdown amplifies thermal displacements of the 660 boundary by 2--5 times and independently promotes stalling, even in warm slabs. As reaction speeds decrease, buoyant untransformed ringwoodite slows descent up to tenfold, progressively driving slabs from sinking to persistent stalling, broadening the boundary to 34 kilometers, and adding up to 64 kilometers of delay (80 kilometers total). Under nominal reaction speeds (best-fit to experimental data), rapid ringwoodite breakdown holds the seismic boundary near its equilibrium depth, even in cold slabs. While nominal reaction speeds imply mostly thermal or compositional shifts, sluggish kinetics independently explain 30 to 60 kilometer displacements, motivating new experiments to reduce laboratory uncertainties.

# Keypoints {.unnumbered #sec:keypoints}

- Sluggish ringwoodite kinetics amplify thermal displacements 2--5 times, reconciling 30--60 km depressions with modest Clapeyron slopes.
- Metastable ringwoodite drives progressive, persistent 660 stagnation, essential for interpreting diverse MTZ seismic and slab structures.
- Large experimental uncertainties and unresolved grain-size, water, and Fe-Mg effects motivate new experiments on 660 reaction kinetics.
-->

\clearpage

# Definition of Symbols {.unnumbered #sec:definition-of-symbols}

|Parameter|Symbol|Unit|Equations|
|:--------|:-----|:---|:--------|
|Activation energy|$E^{\ast}$|J mol$^{-1}$|[-@eq:growth-rate-660; -@eq:reaction-rate-660]|
|Activation enthalpy|$H^{\ast}$|J mol$^{-1}$|[-@eq:reaction-rate-410]|
|Activation volume|$V^{\ast}$|m$^3$ mol$^{-1}$|[-@eq:reaction-rate-410]|
|Activation factor (rheology)|$B$|-|[-@eq:rheological-model]|
|Clapeyron slope|$\gamma$|Pa K$^{-1}$|[-@eq:thermal-displacement]|
|Compressibility (reference)|$\bar{\beta}$|Pa$^{-1}$|[-@eq:density-ala]|
|Density|$\rho$|kg m$^{-3}$|[-@eq:navier-stokes-no-inertia; -@eq:continuity-compressible; -@eq:energy; -@eq:continuity-expanded; -@eq:density-ala; -@eq:thermal-displacement]|
|Density (reference)|$\bar{\rho}$|kg m$^{-3}$|[-@eq:adiabatic-pressure; -@eq:density-ala]|
|Density (dynamic)|$\hat{\rho}$|kg m$^{-3}$|-|
|Depth coordinate|$y$|m|[-@eq:adiabatic-temperature; -@eq:adiabatic-pressure]|
|Deviatoric stress tensor|$\sigma^{\prime}$|Pa|[-@eq:navier-stokes-no-inertia; -@eq:energy]|
|Deviatoric strain rate tensor|$\dot{\epsilon}^{\prime}$|s$^{-1}$|[-@eq:energy]|
|Displacement (total)|$\delta z$|km|[-@eq:kinetic-displacement]|
|Displacement (kinetic contribution)|$\delta z_k$|km|[-@eq:kinetic-displacement]|
|Displacement (thermal contribution)|$\delta z_t$|km|[-@eq:thermal-displacement; -@eq:kinetic-displacement]|
|Gas constant|$R$|J mol$^{-1}$ K$^{-1}$|[-@eq:reaction-rate-410; -@eq:growth-rate-660; -@eq:reaction-rate-660]|
|Gibbs width factor|$w$|J mol$^{-1}$|[-@eq:transition-function]|
|Grain size|$d$|m|-|
|Gravitational acceleration|$g$|m s$^{-2}$|[-@eq:navier-stokes-no-inertia; -@eq:adiabatic-temperature; -@eq:adiabatic-pressure; -@eq:thermal-displacement]|
|Growth rate|$\dot{x}$|m s$^{-1}$|[-@eq:volume-fraction; -@eq:volume-transformation-rate; -@eq:growth-rate-660]|
|Growth rate prefactor|$K^{\prime}$|m$^7$ J$^{-2}$ s$^{-1}$|[-@eq:growth-rate-660]|
|Interlamellar spacing|$\lambda$|m|-|
|Kinetic prefactor (olivine $\Leftrightarrow$ wadsleyite)|$Z_\mathrm{ol}$|K s$^{-1}$|[-@eq:reaction-rate-410]|
|Kinetic prefactor (wadsleyite $\Leftrightarrow$ ringwoodite)|$Z_\mathrm{wd}$|K s$^{-1}$|[-@eq:reaction-rate-410]|
|Kinetic prefactor (ringwoodite $\Leftrightarrow$ bridgmanite + periclase)|$Z_\mathrm{ri}$|mol$^2$ J$^{-2}$ s$^{-1}$|[-@eq:reaction-rate-660]|
|Latent heat|$Q_L$|J kg$^{-1}$|[-@eq:energy]|
|Molar entropy|$\bar{S}$|J mol$^{-1}$ K$^{-1}$|[-@eq:gibbs]|
|Molar Gibbs free energy|$\Delta G$; $\bar{G}$|J mol$^{-1}$|[-@eq:reaction-rate-410; -@eq:gibbs; -@eq:growth-rate-660; -@eq:reaction-rate-660; -@eq:transition-function]|
|Molar volume|$\bar{V}$|m$^{3}$ mol$^{-1}$|[-@eq:gibbs; -@eq:growth-rate-660]|
|Nucleation site factor|$N$|m$^{-1}$|[-@eq:volume-fraction; -@eq:volume-transformation-rate]|
|Pressure|$P$|Pa|[-@eq:navier-stokes-no-inertia; -@eq:energy; -@eq:reaction-rate-410]|
|Pressure (reference)|$\bar{P}$|Pa|[-@eq:adiabatic-pressure]|
|Pressure (dynamic)|$\hat{P}$|Pa|[-@eq:density-ala; -@eq:gibbs]|
|Reaction rate|$\frac{dX}{dt}$; $\dot{X}$|s$^{-1}$|[-@eq:volume-transformation-rate; -@eq:reaction-rate-410; -@eq:reaction-rate-660; -@eq:composition]|
|Reaction rate (maximum at 660)|$\dot{X}_\mathrm{max}$|Ma$^{-1}$|[-@eq:reaction-timescale; -@eq:characteristic-length-scale]|
|Reaction completion timescale|$\tau$|Ma|[-@eq:reaction-timescale]|
|Reaction completion length scale|$L$|km|[-@eq:characteristic-length-scale]|
|Specific heat capacity (reference)|$\bar{C}_p$|J kg$^{-1}$ K$^{-1}$|[-@eq:energy; -@eq:adiabatic-temperature]|
|Temperature|$T$|K|[-@eq:energy; -@eq:reaction-rate-410; -@eq:growth-rate-660; -@eq:reaction-rate-660]|
|Temperature (reference)|$\bar{T}$|K|[-@eq:adiabatic-temperature; -@eq:rheological-model]|
|Temperature (dynamic)|$\hat{T}$|K|[-@eq:density-ala; -@eq:gibbs; -@eq:rheological-model; -@eq:thermal-displacement]|
|Temperature anomaly (inflow)|$\Delta T_0$|K|-|
|Thermal conductivity (reference)|$\bar{k}$|W m$^{-1}$ K$^{-1}$|[-@eq:energy]|
|Thermal expansivity (reference)|$\bar{\alpha}$|K$^{-1}$|[-@eq:energy; -@eq:adiabatic-temperature; -@eq:density-ala]|
|Time|$t$|s|[-@eq:continuity-compressible; -@eq:energy; -@eq:continuity-expanded; -@eq:volume-fraction; -@eq:composition]|
|Transition function|$f_j$|-|[-@eq:transition-function; -@eq:equilibrium-fractions]|
|Velocity (field)|$\vec{u}$|m s$^{-1}$|[-@eq:continuity-compressible; -@eq:energy; -@eq:continuity-expanded; -@eq:composition]|
|Velocity (boundary)|$\vec{u}_\mathrm{in}$|cm yr$^{-1}$|-|
|Velocity (compressional wave)|$V_p$|km s$^{-1}$|-|
|Velocity (maximum through 660)|$\vec{v}_\mathrm{max}$|cm yr$^{-1}$|[-@eq:characteristic-length-scale]|
|Velocity (vertical component)|$\vec{u}_y$|cm yr$^{-1}$|-|
|Viscosity|$\eta$|Pa s|[-@eq:rheological-model]|
|Viscosity (reference)|$\bar{\eta}$|Pa s|[-@eq:rheological-model]|
|Viscosity jump factor (lower mantle)|$b$|-|[-@eq:rheological-model; -@eq:rheological-jump-factor]|
|Viscosity prefactor (phase $i$)|$\nu$|-|[-@eq:rheological-jump-factor]|
|Volume fraction (actual)|$X$|-|[-@eq:volume-fraction; -@eq:volume-transformation-rate; -@eq:reaction-rate-410; -@eq:reaction-rate-660; -@eq:composition]|
|Volume fraction (equilibrium)|$\phi$|-|[-@eq:equilibrium-fractions; -@eq:rheological-jump-factor]|
|Width (660 transition)|$\delta w$|km|-|

\clearpage

# Introduction {#sec:introduction}

Earth's 660 km seismic discontinuity (hereafter the '660') marks the base of the mantle transition zone (MTZ), where ringwoodite decomposes into bridgmanite and periclase (the 'post-spinel' reaction). Two shallower discontinuities, near 410 and 520 km depth (hereafter the '410' and '520'), mark the olivine $\Leftrightarrow$ wadsleyite and wadsleyite $\Leftrightarrow$ ringwoodite transitions that further define the MTZ. High-pressure experiments constrain the Clapeyron slope of the post-spinel reaction to -0.4 to -1.3 MPa K$^{-1}$ [@katsura2003; @fei2004; @litasov2005; @kojitani2016; @ishii2018], while steeper values up to -3 MPa K$^{-1}$ were obtained from earlier calibrations [@ito1989; @bina1994] or hydrous compositions [@ghosh2013]. This negative Clapeyron slope deepens the phase transition beneath cold subducting slabs and has long been recognized as a potential barrier to whole-mantle convection [@ringwood1991; @ita1992].

Equilibrium thermodynamics explains the 660's first-order behavior, but two observations show it is incomplete. First, 660 structure varies more than thermal effects alone predict. While global seismic studies show patterns broadly consistent with the thermal modulation expected from a negative Clapeyron slope [e.g., @flanagan1998; @lebedev2002], amplitude variations point to additional compositional heterogeneity [@waszek2021; @goes2022; @yu2023], and local 660 structures in many subduction zones show displacements of up to 30--60 km [e.g., @fukao2013; @tang2014; @cottaar2016; @ba2025] that far exceed the $\sim$ 3--16 km thermal displacement predicted by modest Clapeyron slopes of -0.4 to -1.3 MPa K$^{-1}$. Proposed explanations include water in ringwoodite [@muir2021], the akimotoite $\Leftrightarrow$ bridgmanite transition [@chanyshev2022; @cottaar2016], and grain-size-dependent viscosity reduction [@kubo2000; @mao2021; @yamazaki2005]. Second, slab dynamics at the 660 depend on more than the Clapeyron slope alone. Numerical geodynamic studies show that slab stagnation above the 660 requires a negative Clapeyron slope, a lower-mantle viscosity increase, and trench retreat acting jointly [@garel2014; @goes2017; @agrusta2017]. Whether reaction kinetics can independently explain these observations has not been evaluated. Few studies have moved beyond thermodynamic equilibrium to test how much microscale reaction kinetics influence macroscale flow dynamics and seismic structures across the MTZ. Building from previous work on metastable olivine [@rubie1994; @dassler1996; @riedel1997; @devaux1997; @hosoya2005; @kerswell2026; @li2026], the reaction-kinetics hypothesis offers a critical avenue of inquiry that may independently account for both deep, broad 660 discontinuities and slab stagnation where equilibrium models fall short.

Laboratory experiments establish that the 410 olivine $\Leftrightarrow$ wadsleyite reaction and the 660 post-spinel reaction are governed by fundamentally different physical mechanisms [@hosoya2005; @kubo2002; @dobson2014; @lessing2022], which translate into different semi-empirical kinetic rate equations with distinct mathematical formulations and parameter dependencies. In a companion study, @kerswell2026 coupled *interface-controlled* olivine $\Leftrightarrow$ wadsleyite kinetics to compressible mantle flow simulations and identified three distinct kinetic regimes in cold slabs with diagnostic seismic signatures at the 410. Because *diffusion-controlled* ringwoodite decomposition kinetics take a different mathematical form, it is expected to produce qualitatively different dynamic behavior at the 660. The reverse post-spinel reaction in upwelling mantle follows a distinct mechanism and proceeds much more slowly below 2000 K [@dobson2014; @lessing2022], so we restrict this study to forward ringwoodite decomposition in subducting slabs. Whether interface-controlled and diffusion-controlled mechanisms produce different flow dynamics and discontinuity structures in subducting slabs, and under what thermal and kinetic conditions reaction kinetics at the 660 control large-scale mantle flow, has not been systematically evaluated in geodynamic simulations of Earth's upper mantle.

Here, we couple experimentally calibrated olivine $\Leftrightarrow$ wadsleyite $\Leftrightarrow$ ringwoodite $\Leftrightarrow$ post-spinel kinetics [after @hosoya2005; @kubo2002] to compressible mantle flow simulations using ASPECT [@kronbichler2012; @heister2017]. Our simulations simultaneously resolve the 410, 520, and 660 transitions, enabling the first direct comparison between reaction mechanisms in a consistent dynamic framework. We hypothesize that ringwoodite decomposition kinetics control whether slabs penetrate or stagnate at the 660, depending on how fast reaction rates are relative to slab descent. Sluggish ringwoodite decomposition should sustain a buoyant metastable zone that impedes descent, whereas faster reaction rates should facilitate continuous penetration. We further hypothesize that sluggish ringwoodite decomposition should thicken and flatten slabs above the 660, amplifying thermal displacements into seismically broad, deeply depressed discontinuities. These hypotheses motivate three specific questions:

1. Under what thermal and kinetic conditions do ringwoodite decomposition kinetics control 660 structure and slab dynamics, and how do these effects differ from those at the 410?
2. How do rheological strength contrasts and slab kinematics modulate thermal and kinetic contributions to 660 structure?
3. Can seismic observations of 660 structure independently constrain ringwoodite decomposition kinetics?

To separate kinetic inhibition from thermal displacement, we compare two end-member simulation suites that both fall within the 95% confidence envelope of the @kubo2002 calibration. We define a *Sluggish Kinetics / Warm Slabs* suite (SW) with 500 K slab thermal anomalies and sluggish kinetic prefactors matching the effective dry, coarse-grained conditions of @kerswell2026. We also define a *Nominal Kinetics / Cold Slabs* suite (NC) with 1000 K slab thermal anomalies and nominal kinetic prefactors ($Z_\mathrm{ri}$ best-fit to experimental data), analogous to classic studies of metastable olivine [@rubie1994; @dassler1996; @riedel1997; @devaux1997; @hosoya2005]. Across both suites, we vary the ringwoodite $\Leftrightarrow$ post-spinel kinetic prefactor $Z_\mathrm{ri}$ over six orders of magnitude alongside rheological strength contrasts, inflow velocities, and lower-mantle viscosity contrasts, and decompose total 660 displacement into its thermal and kinetic contributions. In the NC suite, the 660 stays near equilibrium across all six orders of magnitude in $Z_\mathrm{ri}$. As $Z_\mathrm{ri}$ decreases within the SW suite, slabs progressively slow and amplify the thermal 660 signal, without any abrupt thresholds like the 410 [@kerswell2026]. We discuss why the two reaction mechanisms respond differently to cold slab temperatures, how jointly observing the 410 and 660 in the same slab column helps separate kinetic from thermal and compositional contributions to MTZ structure, and why new experiments that reduce laboratory uncertainties are necessary to resolve the role of kinetics in Earth's mantle.

# Methods {#sec:methods}

## Governing Equations for Compressible Mantle Flow {#sec:governing-equations-for-compressible-mantle-flow}

We solve the same governing equations for compressible mantle flow as @kerswell2026, summarized here for completeness. We simulate mantle flow using the finite-element geodynamic code ASPECT v3.1.0 [@aspect-doi-v3.1.0; @aspectmanual; @gassmoller2018; @clevenger2021] to determine the velocity $\vec{u}$, pressure $P$, and temperature $T$ fields that satisfy the following equations:

$$
  \nabla P - \nabla \cdot \sigma^{\prime} = \rho\, g
$$ {#eq:navier-stokes-no-inertia}

$$
  \frac{\partial \rho}{\partial t} + \nabla \cdot (\rho\, \vec{u}) = 0
$$ {#eq:continuity-compressible}

$$
  \rho\, \bar{C}_p \left(\frac{\partial T}{\partial t} + \vec{u} \cdot \nabla T \right) - \nabla \cdot \left(\bar{k}\, \nabla T \right) = \sigma^{\prime} : \dot{\epsilon}^{\prime} + \bar{\alpha}\, T \left(\vec{u} \cdot \nabla P \right) + Q_L
$$ {#eq:energy}

where $\sigma^{\prime}$ is the deviatoric stress tensor, $\dot{\epsilon}^{\prime}$ is the deviatoric strain rate tensor, $\rho$ is density, $g$ is gravitational acceleration, $t$ is time, and $\bar{C}_p$, $\bar{k}$, $\bar{\alpha}$ are reference specific heat capacity, thermal conductivity, and thermal expansivity, respectively. The term $Q_L$ captures latent heat from phase transitions. We adopt the projected density approximation [@gassmoller2020], reformulating @eq:continuity-compressible as:

$$
  \frac{1}{\rho} \frac{\partial \rho}{\partial t} + \nabla \cdot \vec{u} + \left(\frac{1}{\rho} \nabla \rho \right) \cdot \vec{u} = 0
$$ {#eq:continuity-expanded}

The projected density $\rho(T, P, X)$ varies with temperature, pressure, and volume fractions of the relevant mineral phases, ensuring that local density changes from both pressure-temperature (PT) variations and phase transitions influence the flow through buoyancy, volumetric expansion, and compression. See @gassmoller2020 for a detailed discussion of this compressible formulation.

## Numerical Setup {#sec:numerical-setup}

### Adiabatic Reference Conditions {#sec:adiabatic-reference-conditions}

We compute adiabatic reference conditions using the same approach as @kerswell2026, extended to encompass the full MTZ and uppermost lower mantle (@fig:PYR-material-table). We evaluate entropy changes over a PT range of 1053--2673 K and 0.001--43 GPa using Gibbs free energy minimization with Perple_X [v7.0.9, @connolly2009], assuming a dry pyrolitic bulk composition [@green1979] in the Na$_2$O-CaO-FeO-MgO-Al$_2$O$_3$-SiO$_2$ (NCFMAS) chemical system with the equations of state and solution models of @stixrude2022. We determine an isentropic adiabat using the Newton-Raphson method and evaluate reference material properties ($\bar{\rho}$, $\bar{\alpha}$, $\bar{C}_p$, $\bar{\beta}$) along the adiabat using BurnMan [@cottaar2014; @myhill2023] with equations of state from @stixrude2022 for pure Mg ringwoodite, bridgmanite, and periclase (Figure S1).

![Entropy (left) and density (right) changes across Earth's MTZ under thermodynamic equilibrium and hydrostatic stress conditions. The black box indicates the approximate PT range within our ASPECT simulations. The white line indicates the isentropic adiabat used to calculate reference material properties.](../figs/adiabat/PYR-material-table.png){#fig:PYR-material-table width=70%}

### Initialization and Boundary Conditions {#sec:initialization-and-boundary-conditions}

We conduct simulations in a 1500 $\times$ 1000 km rectangular model domain initialized with equilibrium mineral assemblages across the olivine, wadsleyite, ringwoodite, and post-spinel stability fields. An applied surface pressure of 10 GPa and surface temperature of 1706 K places the 410, 520, and 660 transitions at approximately the center of the model domain (@fig:initial-setup-diagram). We compute initial adiabatic PT profiles by numerically integrating:

$$
  \frac{d\bar{T}}{dy} = \frac{\bar{\alpha}\, \bar{T}\, g}{\bar{C}_p}
$$ {#eq:adiabatic-temperature}

$$
  \frac{d\bar{P}}{dy} = \bar{\rho}\, g
$$ {#eq:adiabatic-pressure}

where the material properties $\bar{\rho}$, $\bar{\alpha}$, and $\bar{C}_p$ are determined from the stable equilibrium assemblage evaluated along the adiabatic reference conditions (Figure S1).

We superimpose Gaussian thermal anomalies of -500 K (SW suite) or -1000 K (NC suite) on the adiabatic profile using linear features with 15 km half-width Gaussian cross-sections and 5 km tanh-tapered ends. Slab anomalies extend 105 km horizontally and 175 km downward from the top boundary. We prescribe constant inflow velocities $\vec{u}_\mathrm{in}$ of 5 or 10 cm yr$^{-1}$ parallel to the thermal anomalies (plus 20 cm yr$^{-1}$ in two sluggish-410 sensitivity tests; @sec:numerical-experiment-design-and-postprocessing). Boundary conditions on lateral walls apply zero horizontal velocity with a lithostatic normal traction, and the (open) top and bottom boundaries apply constant normal traction equal to the initial lithostatic pressure.

![Initial setup for slab simulations follows @kerswell2026, but with an extended 1500 $\times$ 1000 km model domain and additional phase transitions (410, 520, and 660; gray bands). Slab anomalies (-500 K in the SW suite shown here, or -1000 K in the NC suite) extend 105 km horizontally and 175 km downward from the top boundary. All other boundary conditions are consistent with @kerswell2026.](../figs/setup/initial-setup-diagram.png){#fig:initial-setup-diagram width=50%}

### Material Model {#sec:material-model}

#### Material Properties {#sec:material-properties}

We compute material properties with BurnMan using equations of state from @stixrude2022 for pure Mg ringwoodite, bridgmanite, and periclase (see @sec:adiabatic-reference-conditions), and all properties except density are held at their adiabatic reference values (Figure S1). We correct density using a first-order Taylor expansion:

$$
  \rho \approx \bar{\rho} \left(1 + \bar{\beta}\, \hat{P} - \bar{\alpha}\, \hat{T} \right)
$$ {#eq:density-ala}

where $\hat{P} = P - \bar{P}$ and $\hat{T} = T - \bar{T}$ are the dynamic pressure and temperature. The volume fraction fields $X_\mathrm{wd}$, $X_\mathrm{ri}$, and $X_\mathrm{ps}$ account for phase-transition density jumps and evolve according to the kinetic models described in @sec:reaction-kinetics. We hold thermal conductivity $\bar{k}$ = 4.0 W m$^{-1}$K$^{-1}$ constant in all numerical experiments.

#### Reaction Kinetics {#sec:reaction-kinetics}

We treat reaction rates for all three MTZ phase transitions using the site-saturated nucleation framework of @cahn1956:

$$
  X = 1 - \exp\!\left(-N\, \dot{x}\, t \right)
$$ {#eq:volume-fraction}

$$
  \dot{X} = N\, \dot{x}\, \left(1 - X \right)
$$ {#eq:volume-transformation-rate}

where $X$ is the volume fraction of the product phase, $\dot{X}$ is the volume transformation rate, $N = \text{6.67}\, /\, d$ m$^{-1}$ is a geometric factor accounting for grain-boundary nucleation sites with grain size $d$, $\dot{x}$ is the phase-specific growth rate, and $t$ is elapsed time after site saturation.

We formulate the 410 and 520 transitions using the interface-controlled growth model of @hosoya2005, with macroscopic reaction rates governed by:

$$
  \dot{X} = Z_\mathrm{ol}\, T\, \exp\!\left(-\frac{H^{\ast} + P V^{\ast}}{R\, T}\right) \left(1 - \exp\!\left[-\frac{\Delta G}{R\, T}\right] \right)\, \left(1 - X \right)
$$ {#eq:reaction-rate-410}

where $H^{\ast}$ = 274 kJ mol$^{-1}$ and $V^{\ast}$ = 3.0e-6 m$^3$ mol$^{-1}$. We hold the kinetic prefactors fixed at their nominal value of $Z_\mathrm{ol}$ = $Z_\mathrm{wd}$ = 1.4e4 K s$^{-1}$ in the NC suite and at $Z_\mathrm{ol}$ = $Z_\mathrm{wd}$ = 4.44e-4 K s$^{-1}$ in the SW suite, which reflect intermediate 410 kinetics [@kerswell2026]. At their respective slab temperatures (-1000 K and -500 K inflow anomalies), both choices produce relatively fast, near-equilibrium 410 and 520 reaction rates [@kerswell2026] so that shallower transitions do not mask the kinetic signal investigated at the 660.

The molar Gibbs free energy difference for each phase transformation is approximated by:

$$
  \Delta G \approx \Delta \bar{G} + \hat{P}\, \Delta \bar{V} - \hat{T}\, \Delta \bar{S}
$$ {#eq:gibbs}

where we compute the thermodynamic quantities $\Delta \bar{G}$, $\Delta \bar{V}$, and $\Delta \bar{S}$ for each major reaction along the adiabatic reference profile (Figure S2).

The 660 post-spinel reaction requires a fundamentally different kinetic formulation. Because one phase breaks down to two phases of different compositions, diffusion must play a role regardless of whether interface control has an effect. Microstructural observations show that the forward ringwoodite $\Rightarrow$ bridgmanite + periclase transformation proceeds via diffusion-controlled eutectoid decomposition, in which bridgmanite and periclase lamellae nucleate rapidly at grain boundaries and grow at rates limited by silicon self-diffusion (grain-boundary and volume) through the parent ringwoodite [@zener1946; @kubo2002; @dobson2014; @yamazaki2005]. In classical and modern treatments of diffusion-controlled lamellar growth [@zener1946; @hillert1957; @burke1965; @hillert1969; @christian2007; @porter2009], the chemical-potential gradient driving diffusion across the advancing reaction front scales with $\Delta G / \lambda$, while the interlamellar spacing $\lambda$ that balances free-energy release against interfacial energy scales inversely with overstepping ($\lambda \propto 1 / \Delta G$). Combining these two factors yields a growth rate proportional to $\Delta G^2$:

$$
  \dot{x} = K^{\prime}\, \exp\!\left(-\frac{E^{\ast}}{R\, T}\right)\, \frac{\Delta G^2}{\bar{V}_\mathrm{ps}^2}
$$ {#eq:growth-rate-660}

where $K^{\prime}$ is the growth rate prefactor, $E^{\ast}$ is the activation energy for Si self-diffusion, and $\bar{V}_\mathrm{ps}^2 = (\bar{V}_\mathrm{bg} + \bar{V}_\mathrm{pe})^2$ is the squared molar volume of the post-spinel assemblage. We refactor $\Delta G^2 = \Delta G \cdot |\Delta G|$ as the thermodynamic driving force term, which preserves the sign of $\Delta G$ for reverse reactions when $\Delta G$ $<$ 0.

Combining $N$, $K^{\prime}$, and $\bar{V}_\mathrm{ps}^2$ into a single kinetic prefactor $Z_\mathrm{ri} = \text{6.67}\, K^{\prime}\, /\, d\, \bar{V}_\mathrm{ps}^2$, the macroscopic reaction rate for ringwoodite $\Leftrightarrow$ bridgmanite + periclase becomes:

$$
  \dot{X} = Z_\mathrm{ri}\, \exp\!\left(-\frac{E^{\ast}}{R\, T}\right)\, \Delta G \cdot |\Delta G| \left(1 - X \right)
$$ {#eq:reaction-rate-660}

@eq:reaction-rate-660 introduces a fundamental shift from the interface-controlled reaction mechanism at the 410 and 520 (@eq:reaction-rate-410) to a diffusion-controlled reaction mechanism at the 660. Mathematically, the driving force at the 660 is quadratic ($\Delta G^2$), whereas the 410 and 520 follow a linear approximation near equilibrium ($\Delta G\,/\,RT \approx$ 0) before saturating at high overstepping. Physically, this quadratic dependence more aggressively suppresses reaction rates near equilibrium for the 660 transition. Conversely, the lack of exponential saturation means the 660 reaction rate remains sensitive to the magnitude of overstepping even far from equilibrium, unlike the 410 and 520 where the driving force term trends towards unity. These divergent behaviors underpin the distinct structural and dynamic signatures discussed in Sections -@sec:results and -@sec:discussion.

We calibrate $Z_\mathrm{ri}$ against the high-overpressure experimental dataset of @kubo2002 using Monte Carlo regression with a post-spinel molar volume of $\bar{V}_\mathrm{ps}$ = 3.381e-5 m$^3$ mol$^{-1}$ (Figure S3). Our regression yields $E^{\ast}$ = 310 $\pm$ 233 kJ mol$^{-1}$ and $\ln(K^{\prime})$ = -29.8 $\pm$ 22.1 (2$\sigma$), both consistent with @kubo2002 within uncertainty. Propagating the $\pm$ 2$\sigma$ uncertainty in $\ln(K^{\prime})$ across typical mantle grain sizes of $d \in$ [1e-3, 10e-3] m [@karato1984; @karato2008] yields a 95% confidence range of $Z_\mathrm{ri} \in$ [1.7e-11, 2.6e9] mol$^2$ J$^{-2}$ s$^{-1}$ (Figure S4). This wide 2$\sigma$ envelope reflects both systematic error (experimental uncertainties in controlling and measuring temperature, pressure, and transformation progress under extreme multi-anvil conditions) and random error (natural rock variability arising from differences in grain size, defect structure, and minor-element or volatile composition). Within this uncertainty envelope, we fix $E^{\ast}$ = 355 kJ mol$^{-1}$ [after @kubo2002] and sample two six-order-of-magnitude brackets (Figure S4). The NC suite uses $\ln(K^{\prime}) \in$ [-33.5, -22.0] and $d \in$ [1e-3, 10e-3] m to span $Z_\mathrm{ri} \in$ [1.6e-3, 1.6e3] mol$^2$ J$^{-2}$ s$^{-1}$, while the SW suite spans $Z_\mathrm{ri} \in$ [5.08e-11, 5.08e-5] mol$^2$ J$^{-2}$ s$^{-1}$ (near the lower bound of the 95% confidence interval in Figure S4). Both suites therefore sample physically permitted kinetic conditions ranging from slow decomposition in coarse-grained, dry rocks to fast decomposition in fine-grained rocks.

#### Operator Splitting {#sec:operator-splitting}

Since reaction rates for the 410, 520, and 660 transitions can exceed advective timescales, we employ the first-order operator splitting scheme to decouple reaction from advection. Volume fractions are updated in two sequential steps per advection timestep $\Delta t$: 1) a reaction substep integrating Equations -@eq:reaction-rate-410 and -@eq:reaction-rate-660 over the full $\Delta t$ using the ARKODE adaptive Runge-Kutta integrator [@reynolds2023; @hindmarsh2005] with relative tolerance 1e-6; and 2) an advection step:

$$
  \frac{\partial X}{\partial t} + \vec{u} \cdot \nabla X = 0
$$ {#eq:composition}

The three kinetically active transitions require simultaneous integration during the reaction step, with the ARKODE substep size selected adaptively to satisfy the tolerance across all three reaction systems.

### Rheological Model {#sec:rheological-model}

While the volume fractions $X_\mathrm{ol}$, $X_\mathrm{wd}$, $X_\mathrm{ri}$, and $X_\mathrm{ps}$ track the actual mineralogy for the purpose of density and buoyancy (including metastable phases), we also define equilibrium fractions $\phi_\mathrm{ol}$, $\phi_\mathrm{wd}$, $\phi_\mathrm{ri}$, and $\phi_\mathrm{ps}$. These fractions represent the thermodynamic state along the reference adiabat and facilitate smooth transitions in background viscosity. We define a transition function $f_j$ for each reaction $j$:

$$
  f_j = \frac{1}{2} \left[ 1 - \tanh \left( \frac{\Delta G_j}{w} \right) \right]
$$ {#eq:transition-function}

where $w$ = 1000 J mol$^{-1}$ is a "Gibbs width" that smooths the equilibrium fractions $\phi$ over a few kilometers, avoiding discontinuous jumps in background viscosity at sharp equilibrium phase boundaries. To ensure mass conservation $\sum \phi_i = \text{1}$, we partition the stability fractions as follows:

$$
  \begin{aligned}
    \phi_\mathrm{ol} &= 1 - f_\mathrm{wd} \\
    \phi_\mathrm{wd} &= f_\mathrm{wd}\, (1 - f_\mathrm{ri}) \\
    \phi_\mathrm{ri} &= f_\mathrm{wd}\, f_\mathrm{ri}\, (1 - f_\mathrm{ps}) \\
    \phi_\mathrm{ps} &= f_\mathrm{wd}\, f_\mathrm{ri}\, f_\mathrm{ps}
  \end{aligned}
$$ {#eq:equilibrium-fractions}

The rheological model incorporates phase-dependent viscosity transitions as a function of the equilibrium fractions $\phi$ computed in @eq:equilibrium-fractions. We use a temperature-dependent Arrhenius viscosity modified by a phase-dependent viscosity jump prefactor $b$:

$$
  \eta = b\, \bar{\eta}\, \exp\!\left(-B\,\frac{\hat{T}}{\bar{T}}\right)
$$ {#eq:rheological-model}

where $\bar{\eta}$ = 1e21 Pa s is the background viscosity, $\bar{T}$ is the reference adiabatic temperature, and $\hat{T} = T - \bar{T}$ is the nonadiabatic temperature anomaly. We vary the activation factor $B$ between 5 and 10 to control thermal sensitivity.

We calculate the viscosity jump prefactor $b$ via a log-linear average of per-phase viscosity prefactors ($\nu_\mathrm{ol}, \nu_\mathrm{wd}, \nu_\mathrm{ri}, \nu_\mathrm{ps}$), weighted by the equilibrium fractions $\phi$ defined in @eq:equilibrium-fractions:

$$
  \ln(b) = \sum_{i} \phi_i \ln(\nu_i)
$$ {#eq:rheological-jump-factor}

We adopt this log-linear (geometric) average because it is commonly used for viscosity contrasts across mineral phase mixtures and avoids the sensitivity to the single weakest phase that a harmonic (Reuss) average would introduce [@ji2004]. By anchoring viscosity jumps to the equilibrium fractions $\phi$ rather than the actual (metastable) mineralogy $X$, the viscosity structure remains a function of the adiabatic reference condition. This decoupling prevents spurious viscosity patches arising from metastable phases within cold slabs, allowing us to isolate the kinetic contribution to slab impedance via buoyancy from rheological effects. To maintain numerical stability, we impose a global viscosity floor and ceiling of 1e19 and 1e24 Pa s, respectively.

### Numerical Stabilization of Dynamic Pressure Oscillations {#sec:numerical-stabilization-of-dynamic-pressure-oscillations}

Following @gassmoller2020 and @kerswell2026, we exclude the dynamic pressure $\hat{P}$ contribution to $\Delta G$ in the kinetic rate equations (Equations -@eq:reaction-rate-410 and -@eq:reaction-rate-660) while retaining it in the density formulation (@eq:density-ala). In practice, this means applying $\Delta G \approx \Delta \bar{G} - \hat{T}\, \Delta \bar{S}$ to the kinetic rate equations, which preserves the primary thermal control of the reactions while eliminating pressure-wave feedback. The quadratic $\Delta G \cdot |\Delta G|$ driving force amplifies pressure-wave sensitivity relative to the exponential form used at the 410 and 520, making this stabilization particularly important for the 660. Limitations of this approximation are discussed in @sec:uncertainties-and-model-limitations.

### Numerical Experiment Design and Postprocessing {#sec:numerical-experiment-design-and-postprocessing}

We explore the ringwoodite decomposition kinetic parameter space across 16 baseline scenario configurations spanning slab thermal anomalies ($\Delta T_0$ = -500 and -1000 K), inflow velocities ($\vec{u}_\mathrm{in}$ = 5 and 10 cm yr$^{-1}$), rheological strength contrasts ($B$ = 5 and 10), and lower-mantle viscosity jumps ($b$ = 1 and 50; @tbl:scenarios). Within each of the eight baseline kinematic-rheological scenarios per suite, we sample eight values of $Z_\mathrm{ri}$ across six orders of magnitude, running the SW suite as scenarios 0--7 (64 simulations) and repeating the same kinematic-rheological grid for the NC suite as scenarios 8--15 (64 simulations). We also include four additional test simulations (scenarios 16--19, T1--T4; @tbl:scenarios and Table S1) at $\Delta T_0$ = -1000 K, $B$ = 5, $b$ = 1, $\vec{u}_\mathrm{in}$ = 5 and 20 cm yr$^{-1}$, $Z_\mathrm{ri}$ = 6.0e-1 mol$^2$ J$^{-2}$ s$^{-1}$, and $Z_\mathrm{ol}$ = $Z_\mathrm{wd}$ = 3.0 and 7.0 K s$^{-1}$. As expected, these test simulations reproduced analogous metastable olivine wedges shown in previous studies of very cold slabs [@rubie1994; @dassler1996; @riedel1997; @devaux1997; @hosoya2005].

We characterize 660 structure using two diagnostic measures extracted along a representative depth profile that tracks the slab's thermal-anomaly core across the transition zone in each simulation. 'Displacement' ($\delta z$) is the difference between the depth at which the post-spinel volume fraction $X_\mathrm{ps}$ reaches 0.9 and the nominal equilibrium post-spinel depth (614.7 km along the reference adiabat). 'Width' ($\delta w$) is the depth interval between $X_\mathrm{ps}$ = 0.9 and $X_\mathrm{ps}$ = 0.1. We also report the maximum post-spinel reaction rate $\dot{X}_\mathrm{max}$ and the maximum descent velocity $\vec{v}_\mathrm{max}$ along the same profile, extracted within the phase transition zone (defined by the measured 660 width $\delta w$). From these two quantities, we define a characteristic reaction timescale (in Ma):

$$
  \tau = \frac{1}{\dot{X}_\mathrm{max}}
$$ {#eq:reaction-timescale}

and a characteristic reaction completion length scale (in km):

$$
  L = 10\, \frac{\vec{v}_\mathrm{max}}{\dot{X}_\mathrm{max}}
$$ {#eq:characteristic-length-scale}

which approximates the depth traversed during one characteristic reaction timescale $\tau$. $L$ and the measured 660 width $\delta w$ are related but not identical. $L$ is a local estimate based on the maximum reaction rate and maximum vertical velocity through the 660, while $\delta w$ measures the full spatial extent of the transition between $X_\mathrm{ps}$ = 0.1 and 0.9. The two metrics diverge where reaction rate varies strongly within the phase transition zone.

Because the two suites differ in both imposed thermal anomaly and kinetic prefactor, total displacement $\delta z$ combines thermal displacement with kinetic inhibition. To separate these two contributions at both the 660 and the 410 (nominal reference depth 364.2 km), we interpolate the dynamic temperature $\hat{T}$ along the representative depth profile at the measured $X$ = 0.9 transition depth and compute the equilibrium thermal displacement contribution:

$$
  \delta z_t = \frac{\gamma\, \hat{T}}{\rho\, g}
$$ {#eq:thermal-displacement}

and the excess kinetic displacement contribution:

$$
  \delta z_k = \delta z - \delta z_t
$$ {#eq:kinetic-displacement}

using $\rho$ = 4100 kg m$^{-3}$, $g$ = 9.81 m s$^{-2}$, and the pure-Mg reference Clapeyron slopes $\gamma_{660}$ = -1.869 MPa K$^{-1}$ and $\gamma_{410}$ = +3.090 MPa K$^{-1}$.

We use $L$ and $\vec{v}_\mathrm{max}$ to heuristically classify each slab simulation into three regimes using fixed threshold values. The quasi-equilibrium regime corresponds to $L$ $\leq$ 5 km and $\vec{v}_\mathrm{max}$ $>$ 0.5 cm yr$^{-1}$; the intermediate regime corresponds to $L$ $>$ 5 km and $\vec{v}_\mathrm{max}$ $>$ 0.5 cm yr$^{-1}$; and the stagnation regime corresponds to $\vec{v}_\mathrm{max}$ $\leq$ 0.5 cm yr$^{-1}$.

|Suite|Scenario|$\Delta T_0$|$\vec{u}_\mathrm{in}$|$B$|$b$|$Z_\mathrm{ol},Z_\mathrm{wd}$|low $Z_\mathrm{ri}$|high $Z_\mathrm{ri}$|
|:----|-------:|-----------:|--------------------:|--:|--:|----------------------------:|------------------:|-------------------:|
|SW|0|-500|5|5|50|4.44e-4|5.08e-11|5.08e-5
|SW|1|-500|5|10|50|4.44e-4|5.08e-11|5.08e-5
|SW|2|-500|10|5|50|4.44e-4|5.08e-11|5.08e-5
|SW|3|-500|10|10|50|4.44e-4|5.08e-11|5.08e-5
|SW|4|-500|5|5|1|4.44e-4|5.08e-11|5.08e-5
|SW|5|-500|5|10|1|4.44e-4|5.08e-11|5.08e-5
|SW|6|-500|10|5|1|4.44e-4|5.08e-11|5.08e-5
|SW|7|-500|10|10|1|4.44e-4|5.08e-11|5.08e-5
|NC|8|-1000|5|5|50|1.4e4|1.6e-3|1.6e3
|NC|9|-1000|5|10|50|1.4e4|1.6e-3|1.6e3
|NC|10|-1000|10|5|50|1.4e4|1.6e-3|1.6e3
|NC|11|-1000|10|10|50|1.4e4|1.6e-3|1.6e3
|NC|12|-1000|5|5|1|1.4e4|1.6e-3|1.6e3
|NC|13|-1000|5|10|1|1.4e4|1.6e-3|1.6e3
|NC|14|-1000|10|5|1|1.4e4|1.6e-3|1.6e3
|NC|15|-1000|10|10|1|1.4e4|1.6e-3|1.6e3
|T1|16|-1000|5|5|1|3.0e0|6.0e-1|
|T2|17|-1000|5|5|1|7.0e0|6.0e-1|
|T3|18|-1000|20|5|1|3.0e0|6.0e-1|
|T4|19|-1000|20|5|1|7.0e0|6.0e-1|

Table: Thermal, kinematic, rheological, and kinetic parameters across all simulations. T1--T4 are sluggish-410 sensitivity tests in cold slabs (not shown). Units are $\Delta T_0$: K; $\vec{u}_\mathrm{in}$: cm yr$^{-1}$; $B$: dimensionless; $b$: dimensionless; $Z_\mathrm{ol}, Z_\mathrm{wd}$: K s$^{-1}$; $Z_\mathrm{ri}$: mol$^2$ J$^{-2}$ s$^{-1}$. {#tbl:scenarios}

# Results {#sec:results}

## Simulation Snapshots {#sec:simulation-snapshots}

Representative slab snapshots after 100 Ma demonstrate that sluggish ringwoodite kinetics (SW suite) drive slabs monotonically from penetration to stagnation as $Z_\mathrm{ri}$ decreases, whereas nominal ringwoodite kinetics (NC suite) hold the 660 near its equilibrium depth across all six orders of magnitude in $Z_\mathrm{ri}$ (Figures -@fig:slab-composition-scen04 and -@fig:slab-composition-scen12; scenarios 4 and 12 in @tbl:scenarios; see Supplementary Information for additional representative scenarios).

In the SW suite (@fig:slab-composition-scen04), three kinetic regimes emerge with decreasing $Z_\mathrm{ri}$. In the quasi-equilibrium regime ($Z_\mathrm{ri}$ = 5.08e-5 mol$^2$ J$^{-2}$ s$^{-1}$), the slab descends through the 660 at 1.55 cm yr$^{-1}$ and the 660 remains narrow ($\delta w$ = 6.3 km) and modestly displaced ($\delta z$ = 25.1 km, comprising $\delta z_t$ = 16.5 km and $\delta z_k$ = 8.6 km). In the intermediate regime ($Z_\mathrm{ri}$ = 1.90e-8 mol$^2$ J$^{-2}$ s$^{-1}$), metastable ringwoodite accumulates and slows descent through the 660 to 1.11 cm yr$^{-1}$, deepening the 660 by $\delta z$ = 39.6 km ($\delta z_t$ = 17.1 km, $\delta z_k$ = 22.4 km) and widening it to $\delta w$ = 11.8 km. In the stagnation regime ($Z_\mathrm{ri}$ = 5.08e-11 mol$^2$ J$^{-2}$ s$^{-1}$), persistent metastable buoyancy arrests descent ($\vec{v}_\mathrm{max}$ $\leq$ 0.25 cm yr$^{-1}$) and the slab ponds above the 660, displacing it by $\delta z$ = 48.4 km ($\delta z_t$ = 11.0 km, $\delta z_k$ = 37.4 km) and broadening it to $\delta w$ = 10.8 km.

In the NC suite (@fig:slab-composition-scen12), the slab penetrates continuously into the lower mantle and the 660 remains narrow across the entire six-order-of-magnitude range of $Z_\mathrm{ri}$. Even at the slowest nominal prefactor ($Z_\mathrm{ri}$ = 1.6e-3 mol$^2$ J$^{-2}$ s$^{-1}$), the slab descends through the 660 at 2.96 cm yr$^{-1}$ with a $\delta w$ = 6.3 km wide 660 displaced $\delta z$ = 40.1 km downward, of which $\delta z_t$ = 29.6 km is thermal displacement and only $\delta z_k$ = 10.5 km is kinetic inhibition. Under intermediate and fast nominal kinetics ($Z_\mathrm{ri}$ = 6.0e-1 and 1.6e3 mol$^2$ J$^{-2}$ s$^{-1}$), the slab descends at 3.04--3.05 cm yr$^{-1}$ with a $\delta w$ = 8.1 km wide 660 displaced by $\delta z$ = 37.4 km ($\delta z_t$ = 29.6 km, $\delta z_k$ = 7.8 km). At nominal $Z_\mathrm{ri}$ values from @kubo2002, large overstepping in the slab drives rapid quadratic reaction rates (@eq:reaction-rate-660) that prevent an extended metastable ringwoodite zone from accumulating, even in very cold slab cores ($\hat{T} \approx$ -358 to -839 K at 660 km). This contrasts with the stagnant ponding observed in the SW suite, which is produced by very sluggish kinetics near the lower limit of the 2$\sigma$ experimental uncertainties (Figures S3--S4).

\clearpage

![Reference SW suite snapshots after 100 Ma with moderate inflow velocity, intermediate slab strength, and no lower-mantle viscosity jump (scenario 4; @tbl:scenarios). Simulations show stagnation (top row), intermediate (middle row), and quasi-equilibrium (bottom row) kinetic regimes. Columns show dynamic temperature $\hat{T}$ (left column), dynamic density $\hat{\rho}$ (middle column), and vertical velocity $\vec{u}_y$ (right column). Thick black lines (left column) highlight the 10% and 90% wadsleyite and post-spinel volume fraction contours used to define 410 and 660 displacement ($\delta z$) and width ($\delta w$). The background grid indicates ASPECT's adaptive mesh refinement. White trace (left column) indicates the representative depth profile used to extract data, and the white arrows indicate where transition structure is evaluated.](../figs/simulation/compositions/slab-set1-composition-scen04-0100.png){#fig:slab-composition-scen04 width=100%}

\clearpage

![Reference NC suite snapshots after 100 Ma at identical kinematic and rheological settings (scenario 12; @tbl:scenarios). Simulations span slow (top row), intermediate (middle row), and fast (bottom row) nominal kinetic prefactors. All other annotations follow @fig:slab-composition-scen04. Slabs penetrate continuously into the lower mantle with narrow ($\delta w$ = 6.3--8.1 km), thermally deepened ($\delta z_t$ = 29.6 km, $\delta z_k$ = 7.8--10.5 km) 660s across the entire nominal $Z_\mathrm{ri}$ range.](../figs/simulation/compositions/slab-set1-composition-scen12-0100.png){#fig:slab-composition-scen12 width=100%}

\clearpage

## Structure of the 660: Displacement, Width, and Thermal-Kinetic Contributions {#sec:structure-of-the-660}

Across all 128 slab simulations, total 660 displacements overlap between the two suites (median $\delta z$ = 38.0 km for SW versus 34.2 km for NC), but decomposing $\delta z$ into its kinetic ($\delta z_k$; middle panel) and thermal ($\delta z_t$; right panel) contributions reveals that the SW suite is dominated by progressive kinetic inhibition while the NC suite is dominated by thermal displacement (@fig:contributions).

Evaluating the characteristic reaction completion length scale $L$ (@eq:characteristic-length-scale) against descent velocity through the 660 ($\vec{v}_\mathrm{max}$) separates the simulations into three kinetic regimes bounded by $L$ = 5 km and $\vec{v}_\mathrm{max}$ = 0.5 cm yr$^{-1}$ (@fig:contributions, left panel; see @sec:numerical-experiment-design-and-postprocessing). The SW suite spans all three regimes (20 simulations in quasi-equilibrium, 18 in intermediate, and 26 in stagnation; Table S1). In the quasi-equilibrium regime (region 1 in @fig:contributions, left panel), the characteristic reaction timescale $\tau$ (@eq:reaction-timescale) remains below 2 Ma and slabs descend through the 660 at 0.5--3.2 cm yr$^{-1}$, with the 660 displaced $\delta z$ = 22--33 km downward ($\delta z_k$ = 6.7--13.6 km) and $\delta w$ = 4--12 km wide. In the intermediate regime (region 2 in @fig:contributions, left panel), $\tau$ spans 0.3--5.1 Ma and descent velocities through the 660 of 0.6--2.9 cm yr$^{-1}$ produce continuous but progressively slower slab penetration, with the 660 deepening by $\delta z$ = 30--80 km ($\delta z_k$ = 12.4--61.4 km) and widening to $\delta w$ = 7--34 km. In the stagnation regime (region 3 in @fig:contributions, left panel), descent velocities through the 660 of 0.1--0.5 cm yr$^{-1}$ and $\tau$ up to 26 Ma leave the 660 displaced $\delta z$ = 27--80 km downward ($\delta z_k$ = 8.7--64.1 km) with widths of $\delta w$ = 6--34 km. By contrast, 62 of the 64 NC suite simulations remain in the quasi-equilibrium regime (region 1) with $L \ll$ 5 km and $\vec{v}_\mathrm{max}$ = 0.9--6.6 cm yr$^{-1}$. Only two NC simulations (scenario 14 at $Z_\mathrm{ri}$ = 1.6e-3--1.2e-2 mol$^2$ J$^{-2}$ s$^{-1}$) enter the intermediate regime, and none stagnate.

Decomposing 660 displacement into $\delta z_k$ and $\delta z_t$ (@fig:contributions, middle and right panels) shows that sluggish kinetics amplify thermal displacements by two to five times without an abrupt re-sharpening threshold. In the SW suite (red points), warmer slab-core thermal anomalies at the 660 ($\hat{T} \approx$ -236 to -457 K) produce a narrow band of thermal contributions spanning $\delta z_t$ = 11.0--21.2 km (median 16.9 km). As $\dot{X}_\mathrm{max}$ decreases from 1.35e2 to 3.81e-2 Ma$^{-1}$, the kinetic contribution progresses from $\delta z_k$ = 6.7--10.7 km at the fastest $Z_\mathrm{ri}$ to 37.4--64.1 km at the slowest $Z_\mathrm{ri}$ (suite median 18.2 km), while 660 width progresses from $\delta w$ = 4.0--12.0 to 10.8--33.7 km. In contrast to the abrupt re-sharpening threshold at the 410 [@kerswell2026], $\delta z_k$ and $\delta w$ at the 660 change monotonically with decreasing reaction rate across all three regimes, with no re-sharpening at any tested kinetic prefactor. In the NC suite (blue points), colder slab cores at the 660 ($\hat{T} \approx$ -358 to -839 K) generate larger thermal contributions of $\delta z_t$ = 16.6--39.0 km (median 25.5 km), while $\delta z_k$ remains flat at 5.6--12.5 km (median 8.2 km) with narrow 660 widths of $\delta w$ = 3.2--13.8 km (median 6.5 km) across nearly the entire six-order-of-magnitude range of $Z_\mathrm{ri}$. Both suites collapse onto a single continuous $\delta z_k$ curve (@fig:contributions, middle panel) where the kinetically fastest SW simulations meet the NC quasi-equilibrium baseline near $\delta z_k \approx$ 6--11 km. Only the kinematically fastest, rheologically weakest NC configuration at the slowest nominal $Z_\mathrm{ri}$ (scenario 14; $\delta z_k$ = 15.5--22.3 km) departs from this baseline to overlap the SW suite trend. These two cases are the only NC simulations where rapid descent outpaces ringwoodite transformation.

![Kinetic regime classification (left), kinetic contribution $\delta z_k$ (middle), and thermal contribution $\delta z_t$ (right) to 660 displacement across all 128 slab simulations after 100 Ma (Table S1). Point size scales with 660 width $\delta w$ (3.2--34.3 km), and color distinguishes the SW suite (red) and the NC suite (blue). Left: maximum descent velocity through the 660 ($\vec{v}_\mathrm{max}$) versus characteristic reaction length scale $L$, with dashed lines at $L$ = 5 km and $\vec{v}_\mathrm{max}$ = 0.5 cm yr$^{-1}$ dividing (1) quasi-equilibrium, (2) intermediate, and (3) stagnation regimes. Middle and right: $\delta z_k$ and $\delta z_t$ versus maximum reaction rate $\dot{X}_\mathrm{max}$, showing that both suites collapse onto a single $\delta z_k$ curve while $\delta z_t$ separates into distinct bands governed by slab-core temperature and $\vec{v}_\mathrm{max}$ at the 660.](../figs/structure/contributions.png){#fig:contributions width=100%}

\clearpage

## Interactions Among the Key Physical Parameters {#sec:interactions-among-key-physical-parameters}

Reaction kinetics interact with lower-mantle viscosity jump $b$, inflow velocity $\vec{u}_\mathrm{in}$, and slab strength $B$ to govern where slabs stagnate and how deeply metastable ringwoodite is advected (@fig:interactions; Table S1).

Within the SW suite (@fig:interactions, left column), decreasing $Z_\mathrm{ri}$ from 5.08e-5 to 5.08e-11 mol$^2$ J$^{-2}$ s$^{-1}$ reduces $\dot{X}_\mathrm{max}$ proportionally from 1.35e2 to 3.81e-2 Ma$^{-1}$ (Table S1; @eq:reaction-rate-660), progressively slowing descent through the 660 (top left), amplifying $\delta z_k$ (second row, left) and $\delta w$ (bottom left), and slightly reducing $\delta z_t$ at the lowest $Z_\mathrm{ri}$ as stagnating slabs warm by conduction (third row, left). Within the NC suite (@fig:interactions, right column), decreasing $Z_\mathrm{ri}$ from 1.6e3 to 1.6e-3 mol$^2$ J$^{-2}$ s$^{-1}$ similarly reduces $\dot{X}_\mathrm{max}$ from 2.27e9 to 3.72e0 Ma$^{-1}$, but because reaction timescales remain short ($\tau \ll$ 1 Ma), descent rate, $\delta z_k$, $\delta z_t$, and $\delta w$ remain nearly invariant with $Z_\mathrm{ri}$ and stratify instead by kinematic and rheological settings.

Comparing dashed ($b$ = 50) and solid ($b$ = 1) curves of matching color in @fig:interactions (see also Figures S6--S7 and S13--S14) shows that a 50-fold lower-mantle viscosity jump slows slab descent through the 660 in both suites (top row), but triggers stagnation only when paired with sluggish kinetics (SW suite; top left). In the NC suite (top right), imposing the same viscosity jump reduces $\vec{v}_\mathrm{max}$ from 2.9--6.6 cm yr$^{-1}$ to 0.9--1.9 cm yr$^{-1}$ and folds the slab above the lower mantle (Figures S13--S14 and S17--S18), yet all eight NC scenarios remain above the 0.5 cm yr$^{-1}$ stagnation threshold (gray band), with flat $\delta z_k$ across the $b$ = 50 curves (5.6--12.5 km; second row, right). In the SW suite, where metastable ringwoodite buoyancy already resists descent, the same viscosity jump drives the curves into the gray stagnation zone at up to four orders of magnitude higher $Z_\mathrm{ri}$ (top left). This shift is largest for weak, slow slabs (light-blue circles). Scenario 4 ($b$ = 1, solid light-blue curve) crosses into stagnation at or below $Z_\mathrm{ri}$ = 2.63e-9 mol$^2$ J$^{-2}$ s$^{-1}$, whereas scenario 0 ($b$ = 50, dashed light-blue curve; Figures S6--S7) remains below 0.5 cm yr$^{-1}$ across the entire tested $Z_\mathrm{ri}$ range. For stronger SW slabs ($B$ = 10, dark-blue squares and red triangles), the viscosity jump still reduces $\vec{v}_\mathrm{max}$ by a factor of two to three, but shifts the stagnation crossing by only one order of magnitude or less in $Z_\mathrm{ri}$ (compare solid versus dashed curves).

Comparing fast-inflow (orange diamonds and red triangles) and slow-inflow (light-blue circles and dark-blue squares) curves in @fig:interactions demonstrates how advection modulates both thermal and kinetic contributions to 660 structure (see Figures S8--S9 and S15--S16). In both suites, doubling $\vec{u}_\mathrm{in}$ nearly doubles $\vec{v}_\mathrm{max}$ at $b$ = 1 (top row, solid orange/red versus solid blue curves) and transports colder slab material to transition-zone depths. In the NC suite, faster inflow preserves colder slab cores at the 660 ($\hat{T}$ down to -839 K in scenario 14 versus -637 K in scenario 12), increasing $\delta z_t$ from 29.6 km to 37.8--39.0 km for weak slabs (third row, right, solid orange diamonds versus solid light-blue circles). At the slowest nominal $Z_\mathrm{ri}$ (1.6e-3--1.2e-2 mol$^2$ J$^{-2}$ s$^{-1}$), rapid descent in scenario 14 ($\vec{v}_\mathrm{max}$ = 4.8--5.5 cm yr$^{-1}$; Figures S15--S16) begins to outpace ringwoodite decomposition, producing the only upward inflection in NC $\delta z_k$ (to 15.5--22.3 km; second row, right) and $\delta w$ (to 10.2--13.1 km; bottom right). In the SW suite, faster inflow shifts the stagnation crossing to 1--2 orders of magnitude lower $Z_\mathrm{ri}$ (top left) while advecting untransformed ringwoodite deeper before reaction completes, elevating $\delta z_k$ to 7.9--64.1 km and $\delta w$ to 4.0--34.3 km for $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$ (orange and red curves; Figures S8--S11), compared to $\delta z_k$ = 6.7--45.7 km and $\delta w$ = 4.0--21.4 km for $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$ (blue curves; Figures -@fig:slab-composition-scen04, S5--S7).

Finally, slab strength (dark-blue squares and red triangles versus light-blue circles and orange diamonds) controls how coherently slabs transmit buoyant and viscous stresses across the 660 (@fig:interactions; see Figures S10--S11 and S17--S18). In the NC suite, stronger temperature-dependent viscosity ($B$ = 10) stiffens the outer thermal boundary layer of the slab, moderating core descent velocity at $b$ = 1 (4.5--4.6 cm yr$^{-1}$ in scenario 15 versus 4.8--6.6 cm yr$^{-1}$ in scenario 14; top right) and sampling warmer temperatures along the 660 profile ($\delta z_t$ = 16.6--21.8 km) than in weaker $B$ = 5 slabs ($\delta z_t$ = 29.1--39.0 km; third row, right). In the SW suite, weaker slabs ($B$ = 5) decelerate more readily under metastable buoyancy and stagnate at up to two orders of magnitude higher $Z_\mathrm{ri}$ than stronger slabs ($B$ = 10; top left). Because early stagnation halts further downward advection of ringwoodite, weaker SW slabs reach smaller maximum kinetic displacements ($\delta z_k$ = 37.4--58.5 km; total $\delta z$ = 48.4--74.9 km) and widths ($\delta w$ = 10.8--24.7 km) at the lowest $Z_\mathrm{ri}$. Conversely, the strongest and fastest SW slabs (red triangles; Figures S10--S11) resist stagnation down to $Z_\mathrm{ri} \leq$ 3.81e-10 mol$^2$ J$^{-2}$ s$^{-1}$, producing the largest kinetic displacements ($\delta z_k$ = 61.4--64.1 km; total $\delta z$ = 78.3--80.5 km; second row, left) and widest transition zones ($\delta w$ = 26.1--34.3 km; bottom left) in our simulations.

![Coupled kinetic, kinematic, and rheological controls on slab descent velocity through the 660 ($\vec{v}_\mathrm{max}$, top row), kinetic and thermal contributions to 660 displacement ($\delta z_k$, $\delta z_t$, second and third rows), and 660 width ($\delta w$, bottom row) as a function of kinetic prefactor $Z_\mathrm{ri}$ across the SW suite (left column) and the NC suite (right column) after 100 Ma (Table S1). Colors and point shapes denote the four combinations of inflow velocity ($\vec{u}_\mathrm{in}$ = 5 and 10 cm yr$^{-1}$) and slab strength ($B$ = 5 and 10); solid and dashed curves denote no lower-mantle viscosity jump ($b$ = 1) and a 50-fold jump ($b$ = 50), respectively. Gray shading in the top row marks the stagnation regime ($\vec{v}_\mathrm{max} \leq$ 0.5 cm yr$^{-1}$).](../figs/structure/interactions-quantitative.png){#fig:interactions width=100%}

\clearpage

# Discussion {#sec:discussion}

## Uncertainties and Model Limitations {#sec:uncertainties-and-model-limitations}

Distinguishing whether subducting slabs operate in the nominal-equilibrium or sluggish-stagnation regime is currently limited by both large experimental uncertainties and natural slab variations that have not yet been systematically accounted for in kinetics experiments. The primary quantitative uncertainty for the post-spinel reaction stems from the activation energy $E^{\ast}$ for Si self-diffusion and the kinetic prefactor $Z_\mathrm{ri}$, which bundles the growth rate prefactor $K^{\prime}$ and grain size $d$. Monte Carlo regression of the @kubo2002 experimental dataset yields $E^{\ast}$ = 310 $\pm$ 233 kJ mol$^{-1}$ and $\ln(K^{\prime})$ = -29.8 $\pm$ 22.1 (2$\sigma$; Figure S3). Interpreting this range requires distinguishing between systematic experimental error and random natural variability. Systematic error arises from uncertainties in controlling and measuring temperature, pressure, and transformation progress at extreme multi-anvil conditions, and defines the wide laboratory confidence envelope within which both SW and NC suites sit (Figure S4). Random variability, by contrast, reflects physical differences among subducting slabs that can shift effective $Z_\mathrm{ri}$ by several orders of magnitude from one subduction zone to another. Two physical mechanisms dominate this natural variability alongside bulk Fe-Mg composition: 1) parent ringwoodite grain size $d$, which governs the balance between faster grain-boundary diffusion and slower intracrystalline Si diffusion [@kubo2000; @yamazaki2005; @mao2021], and 2) structurally bound water, which may enhance Si diffusivity and lamellar growth rates by orders of magnitude relative to anhydrous ringwoodite [@chakraborty2010]. Both factors correlate with subduction history, which our simulations do not account for. Cold, dry slab cores that undergo high-overstep transformation at the 410 and 520 can experience grain-size reduction to 1--100 $\mu$m. In contrast, warmer or more slowly subducting slabs that transform near equilibrium retain coarser millimeter-scale grains [@riedel1997]. We also neglect major contributing factors that vary among subduction zones such as slab hydration, faulting, and sediment input. Our two simulation suites only bracket physically permitted end-members, demonstrating that new kinetics experiments addressing both the large laboratory uncertainties of the @kubo2002 calibration and natural variations in grain size, water, and Fe-Mg content in slabs are crucial before kinetic regimes can be independently correlated with individual subduction zones.

Another key driver of uncertainty is that the kinetics experiments of @kubo2002 were performed at highly overstepped metastable conditions ($>$ 1 GPa), requiring significant extrapolation to near-equilibrium conditions in our simulations. The quadratic dependence of ringwoodite decomposition on excess Gibbs energy (@eq:reaction-rate-660) results in vanishingly small reaction rates at small pressure oversteps in our simulations. Testing whether this quadratic suppression persists near equilibrium or gives way to an alternative, faster transformation mechanism in natural systems makes new kinetics experiments at small pressure oversteps a critical priority.

A related simplification concerns the reaction's directionality. Although @eq:reaction-rate-660 preserves the sign of $\Delta G$ for bidirectional integration, treating the forward decomposition (ringwoodite $\Rightarrow$ bridgmanite + periclase) and reverse recombination (bridgmanite + periclase $\Rightarrow$ ringwoodite) symmetrically is an approximation. Experiments show that the reverse reaction proceeds via a different mechanism and substantially more slowly than forward decomposition below 2000 K [@dobson2014; @lessing2022], introducing a kinetic asymmetry not captured by our symmetric $\Delta G \cdot |\Delta G|$ formulation. Because a symmetric rate law would overestimate reverse reaction rates in ascending plumes and underestimate metastable bridgmanite + periclase persistence in upwelling material, we restrict this study to forward decomposition in subducting slabs and leave upwelling plumes to future work incorporating dedicated reverse-reaction kinetics.

This kinetic treatment is itself coupled to thermodynamics in ways we only partially resolve. While our material model implicitly includes latent heating near equilibrium, the latent-heating effect at overstepped metastable conditions merits particular caution for the post-spinel reaction. Because the ringwoodite $\Leftrightarrow$ bridgmanite + periclase Clapeyron slope is negative, the (endothermic) latent-heat effect close to equilibrium reinforces kinetic inhibition. At highly overstepped metastable conditions, however, the free energy from mechanical work $P\Delta V$ (rather than $T\Delta S$) becomes operative and this reinforcement is lost. This contrasts with the 410, where both the (exothermic) latent-heat effect and $P\Delta V$ contributions promote faster kinetics. Fully resolving this feedback would likely strengthen the regime contrasts we report here and merits dedicated investigation. We also define Gibbs free energy based on the reference pressure (@eq:gibbs), neglecting deviatoric stresses at individual grain interfaces that directly influence reaction pathways and chemical potentials [@wheeler2014; @wheeler2020]. While the reference pressure can provide a reasonable approximation under certain conditions [@wheeler2015], an improved approach would be to use the dynamic pressure, i.e. the mean normal stress actually experienced by the rock. A rigorous treatment will require consideration of more localized stress-dependent chemical potentials (work in progress).

Beyond these kinetic and thermodynamic uncertainties, our compositional choices introduce additional simplifications. Our pure Mg end-member composition neglects Fe-Mg solid solutions, akimotoite, garnet, and other transition-zone phases present in natural systems [@ita1992; @xu2008; @papanagnou2023]. Iron is unlikely to alter our conclusions substantially because Si self-diffusion limits ringwoodite decomposition [@kubo2002; @yamazaki2005]. Iron content should therefore have only a minor effect on reaction kinetics, and the narrow ($<$ 1 kbar) Fe-Mg post-spinel phase loop [@ishii2019] means metastable Fe-bearing ringwoodite likely transforms directly to the stable bridgmanite + periclase assemblage, keeping the transition effectively univariant as in our pure Mg model. In the coldest slab interiors, the akimotoite $\Leftrightarrow$ bridgmanite transition may dominate over the post-spinel transition [@chanyshev2022; @cottaar2016], producing additional deepening beyond our kinetic model. This reaction is nevertheless expected to be comparatively rapid because the ilmenite and perovskite structures are crystallographically closely related [@navrotsky1998].

A final set of simplifications concerns the large-scale viscosity structure and dimensionality of our simulations. Our simulations test lower-mantle viscosity jumps of $b$ = 1 and $b$ = 50 to partially characterize how viscosity structure interacts with kinetic inhibition (@sec:interactions-among-key-physical-parameters; see Figures S6--S7 and S13--S14). This approach does not span the full plausible range of lower-mantle viscosity contrasts [estimated at roughly 10--100$\times$, @karato2008; @goes2017], and quantitative predictions remain model-dependent. More broadly, natural subduction involves the simultaneous action of viscosity structure, the Clapeyron slope, plate forcing, and kinetics [@goes2017; @garel2014; @agrusta2017], and isolating each contribution requires independent observational constraints. Grain-size distribution at the post-spinel reaction front [@kubo2000; @mao2021; @yamazaki2005] could also generate viscosity contrasts that augment stagnation beyond what our rheological model captures. Our simple temperature-dependent rheological model omits grain-size evolution that affects both flow dynamics and reaction kinetics [@karato1984; @hirth2003; @yamazaki2005]. Finally, our 2D simulations neglect 3D slab geometry, trench migration, slab rollback, and lateral flow diversion. In 3D, a slab that retains its dip and is carried laterally away from the 660 by rollback could sustain faster descent than the vertically ponding slabs in our 2D domain, since less metastable material would accumulate locally beneath any one point on the slab. These 3D effects, alongside slab morphology and residence time more broadly, warrant further investigation [@sime2024; @garel2014]. Despite these limitations, our results capture the first-order kinetic effects governing 660 structure and slab dynamics across three distinct regimes.

## Contrasting Reaction Mechanisms at the 410 and 660 {#sec:contrasting-reaction-mechanisms-at-the-410-and-660}

Unlike interface-controlled 410 kinetics, which produce threshold-controlled re-sharpening, diffusion-controlled 660 kinetics drive progressive and persistent slab stagnation across three regimes (Equations -@eq:volume-fraction to -@eq:reaction-rate-660). At the 410, the interface-controlled driving-force term $(1 - \exp[-\Delta G / RT])$ saturates toward unity once $|\Delta G| \gg RT$ (@eq:reaction-rate-410). Beyond this saturation point, only the Arrhenius term $\exp[-(H^\ast + PV^\ast)/RT]$ controls reaction progress. In a cold, stagnated slab, this factor remains negligible until temperatures rise enough to activate transformation, at which point the reaction completes abruptly over a narrow depth interval, re-sharpening the 410. This threshold produced the three regimes (quasi-equilibrium, intermediate, and ultra-sluggish with re-sharpening) with distinct 410 seismic signatures [@kerswell2026].

At the 660, the diffusion-controlled driving-force term $\Delta G \cdot |\Delta G|$ grows quadratically without bound as ringwoodite is carried below its stability field. Larger overstepping always drives larger (silicon) chemical potential gradients across the decomposition lamellae and thus faster transformation [@zener1946; @kubo2002; @dobson2014; @yamazaki2005]. No saturation ceiling exists, so the driving force never yields to the Arrhenius term alone. As a result, $\dot{X}_\mathrm{max}$ increases progressively with depth and the 660 widens ($\delta w$) and deepens ($\delta z_k$) continuously across all three regimes without triggering an abrupt transformation. The distinction between the intermediate and stagnation regimes at the 660 is therefore a matter of degree, marked by progressively longer reaction timescales $\tau$ (@eq:reaction-timescale), larger reaction length scales $L$ (@eq:characteristic-length-scale), slower descent, and broader, more deeply displaced discontinuities, rather than the abrupt threshold that separates the ultra-sluggish regime at the 410 (@fig:contributions).

This unbounded quadratic driving force also explains why the NC suite remains in quasi-equilibrium at the 660 across nearly the entire nominal $Z_\mathrm{ri}$ range, even when sluggish 410 prefactors in the same cold slabs ($\Delta T_0$ = -1000 K) generate deep metastable olivine wedges (test scenarios 16--19, T1--T4; Table S1). Colder slab cores at 660 km ($\hat{T} \approx$ -358 to -839 K in NC versus -236 to -457 K in SW) force a large Arrhenius penalty via $\exp(-E^{\ast} / RT)$, but the higher nominal $Z_\mathrm{ri}$ values compensate so that the product $Z_\mathrm{ri}\exp(-E^{\ast} / RT)$ at the fastest-SW and slowest-NC end-members overlaps (@fig:contributions). Because colder slab cores also experience larger thermal displacement ($\delta z_t$ = 16.6--39.0 km) and stronger overstepping $|\Delta G| \approx |\hat{T}\, \Delta \bar{S}|$, the quadratic $\Delta G \cdot |\Delta G|$ factor accelerates decomposition in the NC suite by up to five orders of magnitude relative to the slow end of the SW suite (@fig:contributions). Whereas saturation of $(1 - \exp[-\Delta G / RT])$ at the 410 allows cold temperatures to freeze metastable olivine, overstepping at the 660 accelerates decomposition of ringwoodite, so sustained metastable ringwoodite and kinetic stagnation require sluggish $Z_\mathrm{ri}$ prefactors near the lower bound of the @kubo2002 envelope (SW suite; Figure S4).

This difference in reaction mechanism also determines long-term slab behavior. Metastable olivine accumulated in the ultra-sluggish 410 regime eventually transforms in a rapid pulse that can disrupt transient stalling or ponding [@kerswell2026]. Metastable ringwoodite in the 660 stagnation regime is consumed gradually ($\tau$ up to 26 Ma; @eq:reaction-timescale), sustaining persistent buoyancy that resists penetration over much longer timescales. Kinetically stagnated slabs at the 660 are therefore more stable than those at the 410, consistent with the long-lived sub-horizontal ponding observed in the western Pacific [@fukao2013; @tauzin2017].

Near equilibrium, the two reaction mechanisms also differ. The quadratic driving force at the 660 strongly suppresses reaction rates near the phase boundary because $\Delta G \cdot |\Delta G|$ scales as $\Delta G^2$, approaching zero as $\Delta G \to$ 0. The linear driving force term governing the 410 $(1 - \exp[-\Delta G / RT]) \approx \Delta G / RT$ suppresses reaction rates less strongly when $\Delta G$ approaches zero. This inherent near-equilibrium suppression produces a finite baseline kinetic contribution ($\delta z_k \approx$ 6--11 km) and broadens the 660 transition zone slightly relative to the 410, even under quasi-equilibrium conditions (@fig:contributions; @fig:seismic-profiles).

## Kinetic Amplification of Temperature-Driven 660 Displacement {#sec:kinetic-amplification-of-temperature-driven-660-displacement}

The kinetic amplification quantified in @sec:structure-of-the-660 (@fig:contributions) reconciles observed 30--60 km depressions beneath subduction zones with modest Clapeyron slopes. Within the pure Mg, garnet-free system we model, equilibrium thermodynamics predicts downward 660 displacement from two principal sources: 1) the negative Clapeyron slope shifting the post-spinel reaction to higher pressure beneath cold slabs, and 2) the akimotoite $\Leftrightarrow$ bridgmanite transition generating additional displacement of 30--90 km in the coldest slab interiors [@chanyshev2022; @cottaar2016]. Although our simulations do not prescribe constant Clapeyron slopes, effective slopes are implicit in the tabulated molar entropy ($\Delta \bar{S}$) and volume ($\Delta \bar{V}$) changes along our pure-Mg thermodynamic profiles (Figure S2). Evaluating $\gamma = \Delta \bar{S} / \Delta \bar{V}$ at the nominal equilibrium crossings ($\Delta \bar{G}$ = 0) yields implicit Clapeyron slopes of $\gamma_{410}$ = +3.09 MPa K$^{-1}$, $\gamma_{520}$ = +5.36 MPa K$^{-1}$, and $\gamma_{660}$ = -1.87 MPa K$^{-1}$, with $\gamma_{660}$ shallowing slightly from -1.87 to -1.60 MPa K$^{-1}$ across the 0--80 km displacement range below the nominal 660. Our implicit post-spinel slope of -1.87 MPa K$^{-1}$ sits between the recent experimental estimates [-0.4 to -1.3 MPa K$^{-1}$, @katsura2003; @fei2004; @litasov2005; @kojitani2016; @ishii2018] and steeper values reported for earlier calibrations [-2 to -3 MPa K$^{-1}$, @ito1989; @bina1994] or hydrous compositions [@ghosh2013]. Because -1.87 MPa K$^{-1}$ is about 1.4 to 4.7 times steeper than modest Clapeyron slopes (-0.4 to -1.3 MPa K$^{-1}$), the thermal contributions in our simulations ($\delta z_t$ = 11--21 km in SW and 17--39 km in NC) represent conservative upper bounds, where the same slab-core thermal anomalies would produce only $\sim$ 2--15 km (SW) or $\sim$ 4--27 km (NC) of thermal displacement (cf. @fig:contributions; @fig:interactions; Table S1). Sluggish kinetics in the SW suite add $\delta z_k$ = 8.7--64.1 km in the intermediate and stagnation regimes, amplifying total 660 displacement to 27--80 km (@fig:seismic-profiles; Table S1). Such amplifications are roughly two to five times the thermal contribution $\delta z_t$ in our pure-Mg material model ($\gamma_{660}$ = -1.87 MPa K$^{-1}$) and up to an order of magnitude larger than experimentally-derived predictions ($\gamma_{660}$ = -0.4 to -1.3 MPa K$^{-1}$). Beyond these thermal and kinetic effects, two compositional factors outside our model could further modify the 660: 1) water in ringwoodite broadens the post-spinel reaction and raises its pressure [@ghosh2013; @muir2021], promoting additional deepening in cold slabs in contrast to water's shallowing effect at the 410 [@smyth1987; @smyth2002; @vandermeijde2003], while 2) basalt accumulation modifies reflectivity without systematically affecting depth [@yu2023; @goes2022].

The directional contrast between kinetic effects at the 410 and 660 in cold slabs is fundamental. At the 410, the positive Clapeyron slope ($\gamma_{410}$ = +3.09 MPa K$^{-1}$) produces upward thermal displacement under quasi-equilibrium conditions. Decreasing olivine $\Leftrightarrow$ wadsleyite reaction rates first broaden and deepen the 410 discontinuity, then ultimately re-sharpen it at a critical temperature threshold, reversing its displacement sign relative to the equilibrium prediction [@kerswell2026]. At the 660, both the equilibrium thermal contribution $\delta z_t$ and the kinetic contribution $\delta z_k$ across all three regimes produce downward displacement (@fig:contributions; @fig:seismic-profiles). Kinetics amplify rather than reverse the equilibrium thermal signal at the 660, and the transition from one regime to the next is monotonic. The 660 therefore lacks the seismically diagnostic sign-reversal that marks the onset of ultra-sluggish conditions at the 410.

Jointly observing both discontinuities in the same slab column exploits these different behaviors. A sharp, deeply displaced 410 paired with a broad, deeply displaced 660 points to ultra-sluggish olivine $\Leftrightarrow$ wadsleyite kinetics coexisting with intermediate to ultra-sluggish ringwoodite decomposition. A broad, deepened 410 paired with a broad, deepened 660 is consistent with intermediate kinetic inhibition at both transitions. A modestly displaced, narrow 410 paired with a modestly displaced, narrow 660 indicates quasi-equilibrium conditions across the full transition zone, as in the NC suite (@fig:seismic-profiles). These joint patterns exploit the different saturation behaviors of the interface-controlled and diffusion-controlled reaction mechanisms, though they only narrow (rather than eliminate) the ambiguity with thermal, compositional, and rheological contributions discussed below.

![Synthetic compressional wave velocity ($V_p$) profiles extracted along representative slab depth profiles after 100 Ma in the SW suite (left) and the NC suite (right) under identical kinematic and rheological settings (scenarios 4 and 12, respectively; @tbl:scenarios). Black curves show the initial adiabatic reference profile, and horizontal gray bands mark the nominal equilibrium 410, 520, and 660 transition depths. Colored curves span slow (dark red) to fast (yellow) $Z_\mathrm{ri}$ within each suite. In the SW suite, cold temperatures ($-T$) uplift the 410 and 520 while sluggish kinetics ($-Z_\mathrm{ol}$, $-Z_\mathrm{wd}$) counter-shift them downward. In contrast, both temperature and sluggish kinetics ($-T$, $-Z_\mathrm{ri}$) deepen and broaden the 660 ($\delta z$ = 25--48 km; $\delta z_k$ = 8.6--37.4 km; $\delta w$ = 6.0--13.4 km). In the NC suite, colder temperatures ($-T$) strongly uplift the 410 and 520 and deepen the 660 by $\delta z$ = 37--40 km ($\delta z_t$ = 29.6 km), while all $Z_\mathrm{ri}$ curves collapse onto a single narrow band ($\delta z_k$ = 7.8--10.5 km; $\delta w$ = 6.3--8.1 km).](../figs/seismic/seismic-sw-nc.png){#fig:seismic-profiles width=62%}

## Constraining Kinetics from Seismic Observations {#sec:constraining-kinetics-from-seismic-observations}

Kinetic inhibition offers a potential explanation for broad, deeply displaced 660 structures beneath subduction zones that are commonly attributed to water or the akimotoite $\Leftrightarrow$ bridgmanite transition alone. Seismic observations beneath South America [@ba2025], East Asia [@sun2020; @liu2022; @tang2023], and Europe [@cottaar2016; @kalmar2025] show the 660 displaced over a broad area while 410 displacement is either more localized or undetected, possibly because narrow structures escape detection.

Beyond overall displacement, transition width ($\delta w$) provides an independent observational test of our kinetic-inhibition hypothesis because sluggish kinetics alone can reproduce much of the broadening often attributed to combined ringwoodite and garnet breakdown. Beneath the western US, receiver-function inversions resolve a $\sim$ 20 km wide 410 alongside a sharp 660 with an enhanced velocity gradient directly above it associated with stalled Farallon fragments [@schmandt2012], placing an upper bound on local 660 kinetic broadening. Beneath Chile--Argentina, frequency-dependent receiver functions constrain a 30--40 km wide 660 [@bonatto2020], and beneath Northeast China, triplication modeling resolves a 50--70 km transition [@wang2010]; both locations are associated with subducted slabs. The 30--40 km width beneath Chile--Argentina overlaps the upper end of the range predicted by sluggish kinetics in the SW suite (up to $\delta w$ = 34 km in strong, rapidly descending slabs; @fig:contributions; @fig:interactions; Table S1). The 50--70 km transition beneath Northeast China exceeds our pure-Mg kinetic bound, however, and points to sluggish kinetics acting alongside garnet dissolution or the akimotoite $\Leftrightarrow$ bridgmanite transition.

@tbl:regional-observations tests this thermal-kinetic interpretation against representative subduction zones, reporting the conservative reading where methods disagree. Penetrating slabs show modest 660 displacements consistent with quasi-equilibrium thermal contributions $\delta z_t$ for experimentally-determined Clapeyron slopes [@goes2017], as in our NC suite. Stagnant slabs commonly show displacements of 20--60 km with 660 gradients broadened over tens of kilometers, consistent with intermediate to stagnation-regime kinetics in the SW suite where $\delta z_k$ amplifies modest thermal displacements. Across our simulations, kinetic effects reach up to $\delta z$ = 80 km total displacement ($\delta z_k$ up to 64 km) and $\delta w$ = 34 km width in the strongest, fastest SW slabs (@fig:interactions; Table S1). Signals that exceed those bounds, notably the 50--70 km wide 660 beneath Northeast China [@wang2010] and double-step displacements reaching $\sim$ 740 km beneath Tonga--Kermadec [@chanyshev2022], therefore require additional contributions from the akimotoite $\Leftrightarrow$ bridgmanite transition [@chanyshev2022; @cottaar2016] or combined ringwoodite and garnet breakdown [@wang2010]. Water in ringwoodite can also deepen the 660 [@muir2021; @sun2020], although that hypothesis fails complementary tests beneath central Europe [@cottaar2016].

\landscape

| Subduction zone | Slab morphology at 660 | 660 displacement | 660 width | Interpretation in this study | Refs |
|:----------------|:-----------------------|:---------------|:----------|:-----------------------------|:-----|
|Kuril--Izu--Bonin|Stagnant (variable)|Tens of km||Intermediate to stagnation-regime kinetics|1--3|
|Northeast China|Stagnant|$\sim$ 20 km|50--70 km|Stagnation-regime kinetics in a strong slab and/or akimotoite|4--8|
|Mariana|Stagnant remnants|Modest||Quasi-equilibrium|1, 8|
|Tonga--Kermadec|Penetrating|$\leq$ 80 km||Akimotoite (double step) rather than kinetics|1, 7|
|Central America|Penetrating|Modest||Quasi-equilibrium|1|
|Chile--Argentina|Stagnant (variable)|$\sim$ 15--20 km|30--40 km|Stagnation-regime kinetics|9--10|
|Western US|Stagnant remnants||Sharp|Sharp 660 limits kinetic broadening|11|
|Mediterranean|Penetrating (variable)|$\sim$ 10--20 km||Intermediate to stagnation-regime kinetics and/or akimotoite|7, 12--13|

Table: Representative regional 660 observations. Displacement is relative to the nominal 660 km global reference. Width is the depth extent of the 660 velocity gradient where resolved. References: 1: @fukao2013, 2: @tauzin2017, 3: @waszek2024, 4: @wang2010, 5: @tang2023, 6: @sun2020, 7: @chanyshev2022, 8: @goes2017, 9: @ba2025, 10: @bonatto2020, 11: @schmandt2012, 12: @cottaar2016, 13: @kalmar2025 {#tbl:regional-observations}

\endlandscape

Beyond depth and width, the 660 also displays a structural complexity that generally exceeds the 410. The discontinuity can appear split [@deuss2006; @boyce2021] or difficult to resolve in long-period PP precursor data [@deuss2009; @lessing2015], and observed amplitude variations in precursors [@waszek2021; @yu2023] and high-frequency scattering [@day2013; @wu2019] point to compositional variations around the boundary. Some of this apparent complexity may itself be a kinetic signature. In higher-frequency data, such as receiver functions, a broad transition may resemble a split one. Determining how much kinetic effects contribute to these observations (versus genuine compositional variation) requires forward modeling of synthetic seismic data [e.g., @lessing2015].

Seismic observations alone, however, cannot fully separate kinetic effects from thermal, compositional, and rheological contributions. The boundaries between regimes shift systematically with $B$, inflow velocity, and the viscosity jump factor $b$, so the same 660 structure is consistent with many kinetic-rheological combinations. As previously stated, joint analysis of the 410 and 660 in the same slab column narrows, rather than eliminates, this ambiguity. However, two laboratory priorities would translate this approach into quantitative observational constraints. The first is high-pressure experiments under cold-slab and small-overstep conditions targeting large laboratory uncertainties (see @sec:uncertainties-and-model-limitations). The second is explicit kinetic models for the reverse post-spinel reaction [e.g., @lessing2022].

## Slab Dynamics and the Diversity of Subduction Behavior {#sec:slab-dynamics-and-the-diversity-of-subduction-behavior}

Sluggish ringwoodite decomposition kinetics independently promote slab stagnation at the 660 without requiring trench retreat or a prescribed lower-mantle viscosity jump, establishing reaction kinetics as an additional, conditional impedance alongside equilibrium controls. Under nominal ringwoodite kinetics (NC suite), rapid decomposition maintains equilibrium and prevents metastable buoyancy from accumulating (even in very cold slabs; $\Delta T_0$ = -1000 K), so slabs penetrate continuously unless slowed and folded by a lower-mantle viscosity jump (@fig:slab-composition-scen12; Figures S13--S14 and S17--S18). Under sluggish ringwoodite kinetics (SW suite), by contrast, accumulated metastable buoyancy drives the penetration-to-stagnation progression detailed in @sec:structure-of-the-660, from quasi-equilibrium through intermediate flattening to ponding above the 660 (@fig:slab-composition-scen04; @fig:contributions). These results complement the equilibrium stagnation mechanisms identified by @garel2014, @agrusta2017, and @goes2017. Where those studies identify the Clapeyron slope, lower-mantle viscosity increase, and trench retreat as necessary joint conditions for stagnation, our SW suite establishes sluggish kinetic inhibition as an additional, independently variable impedance. A lower-mantle viscosity jump reinforces kinetic stagnation in our simulations (@fig:interactions; Figures S6--S7 and S10--S11), confirming that kinetic and viscous impedances at the 660 are additive.

The diversity of slab behavior documented globally by @fukao2013 maps onto this interpretation. Stagnant western Pacific slabs ponding above the 660 with displacements of 30--60 km [@fukao2013; @tauzin2017] are consistent with intermediate to stagnation-regime kinetics in the SW suite, where kinetic contributions ($\delta z_k$ = 9--64 km) amplify modest thermal displacements. Steeply penetrating slabs with narrow, modestly displaced 660s are consistent with the quasi-equilibrium regime of both suites. Our results also help explain slabs that flatten or stagnate in the uppermost lower mantle between 660 and 1000 km depth, such as segments of the Mariana, Kermadec, Java, and Central America subduction zones [@fukao2013; @goes2017]. Two complementary mechanisms may play a role: 1) in strong, rapidly subducting SW slabs under sluggish kinetics (scenarios 3 and 7; Figures S10--S11), structural coherence resists buckling at the 660 and advects buoyant metastable ringwoodite to $\sim$ 740 km depth before the slab decelerates and flattens in the uppermost lower mantle; and 2) because metastable ringwoodite decomposes gradually over characteristic timescales of $\tau$ $\sim$ 5--26 Ma rather than in an abrupt pulse, slabs that initially stall near the base of the transition zone slowly lose positive buoyancy over 20--160 Ma [@mao2018; @chapman2021] and sink into the uppermost lower mantle, where a 10--100$\times$ viscosity increase (scenarios 0--3 and 8--11; Figures S6--S7, S10--S11, S13--S14, and S17--S18) folds and stalls the slab between 660 and 1000 km depth [analogous to @garel2014; @goes2017; @agrusta2017].

Descent rates offer a further point of comparison with nature, though a more demanding one given the inherent limitations of our phenomenological model. In the SW suite, descent rates through the 660 in the quasi-equilibrium regime (0.5--3.2 cm yr$^{-1}$) fall below or at the lower end of the natural interquartile range of 2.6--4.8 cm yr$^{-1}$ [@lallemand2005], a discrepancy also present in the 410 results of @kerswell2026. The colder, more negatively buoyant NC suite slabs at $b$ = 1 (2.9--6.6 cm yr$^{-1}$) span the natural range and slow to 0.9--1.9 cm yr$^{-1}$ at $b$ = 50 (@fig:interactions; Table S1). Our model includes slab pull, the dominant driving force in nature, but omits other controls on descent rate, including upper mantle viscosity structure, chemical buoyancy contrasts between basaltic and harzburgitic layers, volatile content, and 2D geometric simplifications that neglect trench retreat and lateral flow. Any of these factors could shift simulated rates closer to natural values. Because our simulations are designed to isolate and demonstrate kinetic effects rather than to reproduce the full boundary conditions of natural subduction, the absolute descent rates are not expected to match observations quantitatively. The qualitative correspondence with observed slab diversity discussed above is the more direct test of our kinetic-inhibition hypothesis. Incorporating the omitted physics would be needed to translate our results into quantitative natural descent rates, and represents a natural extension of this approach.

Kinetic inhibition acts jointly with slab rheology and kinematics to control subduction dynamics and 660 structure (@fig:interactions). In the SW suite, weaker slabs decelerate more readily under metastable buoyancy and stagnate at up to two orders of magnitude higher $Z_\mathrm{ri}$ than stronger slabs, which caps their maximum kinetic contribution ($\delta z_k$ = 37--59 km) once ponding halts downward advection. Stronger slabs resist stagnation to lower $Z_\mathrm{ri}$ and advect untransformed ringwoodite deeper into the metastable zone when their descent slows, generating the widest ($\delta w$ = 26--34 km) and most deeply displaced ($\delta z$ = 78--80 km; $\delta z_k$ = 61--64 km) 660s in our simulations (@fig:interactions; Figures S10--S11). In the NC suite, conversely, only the weakest and kinematically fastest configuration (scenario 14; Figures S15--S16) descends rapidly enough at the slowest nominal $Z_\mathrm{ri}$ to enter the intermediate regime ($\delta z_k$ = 16--22 km). Small changes in convergence rate, slab thermal state, or rheological strength near a regime boundary can therefore drive episodic transitions between penetrating and stagnant behavior at individual subduction zones over geological time [@agrusta2017; @mao2018; @kerswell2026].

# Conclusions {#sec:conclusions}

Diffusion-controlled ringwoodite decomposition kinetics provide a credible physical mechanism to independently stall subducting slabs and reconcile deep, broad 660 km discontinuity transitions with modest experimental Clapeyron slopes. By coupling experimentally calibrated kinetics to 2D compressible subduction simulations, and decomposing total 660 displacement into its thermal and kinetic contributions, we demonstrate that reaction kinetics is an indispensable quantitative paradigm for interpreting the diversity of observed slab morphologies and seismic structures across the MTZ.

Ringwoodite decomposition kinetics exert a conditional, first-order control on slab dynamics and 660 structure, modulated by lower-mantle viscosity jump, inflow velocity, and slab strength. Nominal kinetic prefactors ($Z_\mathrm{ri}$ best-fit to experimental data; NC suite) create conditions that are indistinguishable from thermodynamic equilibrium. Slabs penetrate continuously unless slowed by a lower-mantle viscosity jump, and observed 660 displacements must be mostly thermal and/or compositional. By contrast, sluggish kinetic prefactors (representative of dry, coarse-grained rocks; SW suite) transition slabs from penetration to stagnation with decreasing $Z_\mathrm{ri}$. Accumulating metastable ringwoodite slows descent up to tenfold and ponds slabs above the lower mantle. In these regimes, kinetic inhibition widens the 660 to 34 km and contributes up to 64 km of downward displacement (80 km total), amplifying thermal displacements by two to five times in our pure-Mg model ($\gamma_{660}$ = -1.87 MPa K$^{-1}$) and by up to an order of magnitude relative to experimentally-determined Clapeyron slopes ($\gamma_{660}$ = -0.4 to -1.3 MPa K$^{-1}$). Sluggish kinetics thus act as an independent stagnation mechanism alongside thermal effects and lower-mantle viscosity jump, reconciling broad, 30--60 km 660 displacements with modest Clapeyron slopes without requiring akimotoite, garnet, or water.

Kinetic stagnation at the 660 is progressive and persistent ($\tau$ up to 26 Ma) rather than threshold-controlled, a distinction essential for interpreting the diverse seismic signatures and slab morphologies across the MTZ. At the 410, the interface-controlled driving force saturates at high overstepping, allowing cold temperatures to freeze metastable olivine until warming triggers an abrupt re-sharpening pulse [@kerswell2026]. At the 660, the quadratic diffusion-controlled driving force ($\Delta G \cdot |\Delta G|$) grows without bound as overstepping increases, causing kinetic inhibition to progress monotonically from quasi-equilibrium through stagnation with no re-sharpening at any tested condition.

Distinguishing between equilibrium and kinetically controlled 660 regimes in Earth's mantle requires narrowing large laboratory uncertainties alongside new observational constraints. High-pressure experiments targeting cold-slab conditions and small pressure oversteps (accounting for expected grain-size, water, and Fe-Mg variations in the mantle), dedicated kinetic models for the reverse post-spinel reaction, and frequency-dependent inversions jointly constraining 410 and 660 topography and gradient width, would discriminate kinetic inhibition from competing thermal and compositional explanations. Until these fundamental constraints narrow the permitted kinetic range, both NC and SW suite end-member behaviors remain plausible.

# Acknowledgements {.unnumbered #sec:acknowledgements}

This work was funded by the UKRI NERC Large Grant no. NE/V018477/1. All computations were undertaken on Barkla2, part of the High Performance Computing facilities at the University of Liverpool, who graciously provided expert support. We thank the Computational Infrastructure for Geodynamics ([https://geodynamics.org](https://geodynamics.org)) which is funded by the National Science Foundation under awards EAR-0949446 and EAR-1550901 for supporting the development of ASPECT. We thank two anonymous reviewers for their feedback, which greatly improved this work, and the JGR:SE editorial staff for handling the manuscript.

# Data Availability {.unnumbered #sec:data-availability}

All simulation outputs and post-processed data for reproducing this work are archived on Zenodo [@kerswell2027], as well as all analysis code [@kerswell2027b]. All data and code within these repositories are MIT Licensed and free for use and distribution (see license details). ASPECT version 3.1.0 [@aspect-doi-v3.1.0] was used for the computations in this study and is freely available under the GPL v2.0 or later license.

# Conflict of Interest {.unnumbered #sec:conflict-of-interest}

The authors declare there are no conflicts of interest for this manuscript.

\clearpage

# References {.unnumbered #sec:references}

::: {#refs}
:::
