<!--
# Abstract {.unnumbered #sec:abstract}

The 660 km discontinuity deepens and broadens beneath slabs, but temperature alone does not explain the range. We couple diffusion-controlled ringwoodite kinetics to compressible mantle flow and compare two end-member suites: Warm Sluggish Kinetics (500 K anomaly, sluggish rates from a corrected year-to-second scaling) against Cold Nominal Kinetics (1000 K anomaly, calibrated nominal rates). Totals deceive. Median displacement reads 38.0 km warm against 34.2 km cold. Contributions differ. Median kinetic excess reads 18.2 km warm against 8.2 km cold, with thermal offsets at 16.9 and 25.5 km. Warm models span quasi-equilibrium through stagnation as rates fall, amplifying the warm thermal baseline by 2--4 times and slowing descent by an order of magnitude. Cold models remain near equilibrium across six orders in nominal prefactor, with 62 of 64 models in quasi-equilibrium. Sluggish-410 tests AC1--AC2 and T3--T4 build 9--47 km of 410 kinetic excess with 7--8 km at the paired 660. Seismic profiles show a broad deep warm 660 band against a narrow cold band. Kinetics stagnate slabs only when rates are sluggish. Nominal kinetics at very cold temperatures penetrate.

\clearpage

# Plain Language Summary {.unnumbered #sec:plain-language-summary}

Earth has a boundary 660 kilometers underground where ringwoodite changes into two denser minerals. Beneath sinking plates, this boundary often sits deeper and looks thicker than heat alone predicts. Laboratory data show the change takes time. We ran computer models of sinking plates with two setups: warm plates with sluggish reaction speeds and very cold plates with laboratory-calibrated speeds. Both setups deepen the boundary by similar totals, near 35 km. The split differs. Warm sluggish models add 18 km from kinetics on top of 17 km from temperature. Very cold nominal models add 8 km from kinetics on top of 25 km from temperature. Sluggish kinetics stall plates and widen the boundary as speeds drop. Calibrated kinetics let even very cold plates sink with a narrow boundary. Tests with sluggish 410 kinetics broaden the 410 without broadening the paired 660. Reaction speed stalls plates only when speeds are sluggish.

# Keypoints {.unnumbered #sec:keypoints}

- Warm Sluggish Kinetics stagnates slabs and widens the 660; Cold Nominal Kinetics penetrates with a narrow 660 despite 1000 K anomalies.
- Thermal-kinetic split separates the signals: 18.2 against 8.2 km kinetic excess with 16.9 against 25.5 km thermal offset.
- Joint 410/660 kinetic excess discriminates mechanisms; AC1--AC2 and T3--T4 pair large 410 excess with near-zero 660 response.
-->

\clearpage

# Definition of Symbols {.unnumbered #sec:definition-of-symbols}

|Parameter|Symbol|Unit|Equations|
|:--------------|:------|:----|:----|
|Activation energy|$E^{\ast}$|J mol$^{-1}$|[-@eq:growth-rate-660; -@eq:reaction-rate-660]|
|Activation enthalpy|$H^{\ast}$|J mol$^{-1}$|[-@eq:reaction-rate-410]|
|Activation volume|$V^{\ast}$|m$^3$ mol$^{-1}$|[-@eq:reaction-rate-410]|
|Activation factor (rheology)|$B$|-|[-@eq:rheological-model]|
|Compressibility (reference)|$\bar{\beta}$|Pa$^{-1}$|[-@eq:density-ala]|
|Density|$\rho$|kg m$^{-3}$|[-@eq:navier-stokes-no-inertia; -@eq:continuity-compressible; -@eq:energy; -@eq:continuity-expanded; -@eq:density-ala]|
|Density (reference)|$\bar{\rho}$|kg m$^{-3}$|[-@eq:adiabatic-pressure; -@eq:density-ala]|
|Density (dynamic)|$\hat{\rho}$|kg m$^{-3}$|-|
|Deviatoric stress tensor|$\sigma^{\prime}$|Pa|[-@eq:navier-stokes-no-inertia; -@eq:energy]|
|Deviatoric strain rate tensor|$\dot{\epsilon}^{\prime}$|s$^{-1}$|[-@eq:energy]|
|Gas constant|$R$|J mol$^{-1}$ K$^{-1}$|[-@eq:growth-rate-660; -@eq:rheological-model]|
|Gibbs width factor|$w$|J mol$^{-1}$|[-@eq:transition-function]|
|Grain size|$d$|m|-|
|Gravitational acceleration|$g$|m s$^{-2}$|[-@eq:navier-stokes-no-inertia; -@eq:adiabatic-temperature; -@eq:adiabatic-pressure]|
|Growth rate|$\dot{x}$|m s$^{-1}$|[-@eq:volume-fraction; -@eq:volume-transformation-rate; -@eq:growth-rate-660]|
|Growth rate prefactor|$K^{\prime}$|m$^7$ J$^{-2}$ s$^{-1}$|[-@eq:growth-rate-660]|
|Kinetic prefactor (olivine $\Leftrightarrow$ wadsleyite)|$Z_\mathrm{ol}$|K s$^{-1}$|[-@eq:reaction-rate-410]|
|Kinetic prefactor (wadsleyite $\Leftrightarrow$ ringwoodite)|$Z_\mathrm{wd}$|K s$^{-1}$|[-@eq:reaction-rate-410]|
|Kinetic prefactor (ringwoodite $\Leftrightarrow$ bridgmanite + periclase)|$Z_\mathrm{ri}$|mol$^2$ J$^{-2}$ s$^{-1}$|[-@eq:reaction-rate-660]|
|Latent heat|$Q_L$|J kg$^{-1}$|[-@eq:energy]|
|Molar entropy|$\bar{S}$|J mol$^{-1}$ K$^{-1}$|[-@eq:gibbs]|
|Molar Gibbs free energy|$\bar{G}$|J mol$^{-1}$|[-@eq:gibbs; -@eq:transition-function]|
|Molar volume|$\bar{V}$|m$^{3}$ mol$^{-1}$|[-@eq:gibbs]|
|Nucleation site factor|$N$|m$^{-1}$|[-@eq:volume-fraction; -@eq:volume-transformation-rate]|
|Pressure|$P$|Pa|[-@eq:navier-stokes-no-inertia; -@eq:energy]|
|Pressure (reference)|$\bar{P}$|Pa|[-@eq:adiabatic-pressure]|
|Pressure (dynamic)|$\hat{P}$|Pa|[-@eq:density-ala; -@eq:gibbs]|
|Reaction rate|$\frac{dX}{dt}$; $\dot{X}$|s$^{-1}$|[-@eq:volume-transformation-rate; -@eq:reaction-rate-410; -@eq:reaction-rate-660; -@eq:composition]|
|Reaction completion timescale|$\tau$|Ma|-|
|Reaction completion length scale|$L$|km|-|
|Specific heat capacity (reference)|$\bar{C}_p$|J kg$^{-1}$ K$^{-1}$|[-@eq:energy; -@eq:adiabatic-temperature]|
|Temperature|$T$|K|[-@eq:energy; -@eq:growth-rate-660; -@eq:rheological-model]|
|Temperature (reference)|$\bar{T}$|K|[-@eq:adiabatic-temperature; -@eq:rheological-model]|
|Temperature (dynamic)|$\hat{T}$|K|[-@eq:density-ala; -@eq:gibbs; -@eq:rheological-model]|
|Thermal conductivity (reference)|$\bar{k}$|W m$^{-1}$ K$^{-1}$|[-@eq:energy]|
|Thermal expansivity (reference)|$\bar{\alpha}$|K$^{-1}$|[-@eq:energy; -@eq:adiabatic-temperature; -@eq:density-ala]|
|Time|$t$|s|[-@eq:continuity-compressible; -@eq:energy; -@eq:continuity-expanded; -@eq:volume-fraction; -@eq:composition]|
|Transition function|$f_j$|-|[-@eq:transition-function; -@eq:equilibrium-fractions]|
|Velocity (field)|$\vec{u}$|m s$^{-1}$|[-@eq:continuity-compressible; -@eq:energy; -@eq:continuity-expanded; -@eq:composition]|
|Velocity (boundary)|$\vec{u}_\mathrm{in}$|cm yr$^{-1}$|-|
|Velocity (maximum through 660)|$\vec{v}_\mathrm{max}$|cm yr$^{-1}$|-|
|Viscosity|$\eta$|Pa s|[-@eq:rheological-model]|
|Viscosity (reference)|$\bar{\eta}$|Pa s|[-@eq:rheological-model]|
|Viscosity jump factor (lower mantle)|$b$|-|[-@eq:rheological-model; -@eq:rheological-jump-factor]|
|Viscosity prefactor (phase $i$)|$\nu$|-|[-@eq:rheological-jump-factor]|
|Volume fraction (actual)|$X$|-|[-@eq:volume-fraction; -@eq:volume-transformation-rate; -@eq:reaction-rate-410; -@eq:reaction-rate-660; -@eq:composition]|
|Volume fraction (equilibrium)|$\phi$|-|[-@eq:equilibrium-fractions; -@eq:rheological-jump-factor]|

\clearpage

# Introduction {#sec:introduction}

Earth's 660 km seismic discontinuity (hereafter the '660') marks the base of the mantle transition zone (MTZ), where ringwoodite decomposes into bridgmanite and periclase (the 'post-spinel' reaction). Two shallower discontinuities, near 410 and 520 km depth (hereafter the '410' and '520'), mark the olivine $\Leftrightarrow$ wadsleyite and wadsleyite $\Leftrightarrow$ ringwoodite transitions that further define the MTZ. High-pressure experiments constrain the Clapeyron slope of the post-spinel reaction to -1 to -3 MPa/K [@litasov2005; @ishii2019], which deepens the phase transition beneath cold subducting slabs and has long been recognized as a potential barrier to whole-mantle convection [@ringwood1991; @ita1992].

Equilibrium thermodynamics explains the 660's first-order behavior, but two observations suggest it is incomplete. First, 660 structure itself is more variable than purely thermal effects predict. While global seismic studies show patterns broadly consistent with the thermal modulation expected from a negative Clapeyron slope [e.g., @flanagan1998; @lebedev2002], amplitude variations point to additional compositional heterogeneity [@waszek2021; @goes2022; @yu2023], and local 660 structures in many subduction zones show stronger than predicted deflections [e.g., @cottaar2016; @tang2014; @ba2025]. Proposed explanations include water in ringwoodite [@muir2021], the akimotoite $\Leftrightarrow$ bridgmanite transition [@chanyshev2022; @cottaar2016], and grain-size-dependent viscosity reduction [@kubo2000; @mao2021]. Second, slab dynamics at the 660 depend on more than the Clapeyron slope alone. Numerical geodynamic studies show that slab stagnation above the 660 requires a negative Clapeyron slope, a lower-mantle viscosity increase, and trench retreat acting jointly [@garel2014; @goes2017]. Whether reaction kinetics can independently explain these observations has not been evaluated. Few studies have moved beyond the equilibrium paradigm to test how much microscale reaction kinetics influence macroscale flow dynamics and seismic structures.

Laboratory experiments establish that the 410 olivine $\Leftrightarrow$ wadsleyite reaction and the 660 post-spinel reaction follow fundamentally different physical mechanisms [@hosoya2005; @kubo2002; @dobson2014; @lessing2022], with different semi-empirical rate equations. A companion study coupled *interface-controlled* olivine $\Leftrightarrow$ wadsleyite kinetics to compressible flow and identified three kinetic regimes in cold slabs with diagnostic 410 signatures [@kerswell2026a]. That study ran with time in years, so its nominal prefactors ran slower by seconds per year; an erratum corrects the offset. The present revision builds on that correction and compares two end members: Warm Sluggish Kinetics at 500 K anomaly with the effective (sluggish) rates the 410 simulations actually sampled, and Cold Nominal Kinetics at 1000 K anomaly with calibrated nominal rates. Because *diffusion-controlled* ringwoodite kinetics takes a different mathematical form, it should produce different dynamic behavior at the 660. Whether kinetics at the 660 matter for large-scale flow, and how the two mechanisms differ in one dynamic framework, remains untested.

Here, we couple calibrated ringwoodite kinetics [after @kubo2002] to compressible ASPECT simulations [@kronbichler2012; @heister2017] that resolve the 410, 520, and 660 together. We hypothesize conditional control: sluggish kinetics stagnate slabs and broaden and deepen the 660, while nominal kinetics at very cold temperatures keep slabs penetrating with a narrow 660 near its thermal offset. We further hypothesize that the two reaction mechanisms leave different joint 410/660 signatures. These hypotheses motivate three questions:

1. Do ringwoodite kinetics control 660 structure and slab dynamics differently in the sluggish and nominal suites, and how do those effects differ from 410 behavior?
2. How do rheological strength and slab kinematics modulate kinetic effects on 660 structure?
3. Can seismic width and topography of the 660, jointly with the 410, constrain kinetics?

We cross eight $Z_\mathrm{ri}$ values per suite with rheology and kinematics. Warm-sluggish models span quasi-equilibrium through stagnation and amplify warm thermal offsets by 2--4 times while slowing descent by an order of magnitude. Cold-nominal models remain near equilibrium at the 660 despite 1000 K anomalies, with AC1--AC2 and T3--T4 anchoring strong 410 metastability against a null 660 response. The 660 changes monotonically without the abrupt re-sharpening seen at the 410. Joint 410/660 observation in one slab column discriminates kinetic from thermal and compositional contributions to MTZ structure.

# Methods {#sec:methods}

## Governing Equations for Compressible Mantle Flow {#sec:governing-equations-for-compressible-mantle-flow}

We solve the same governing equations for compressible mantle flow as @kerswell2026a, summarized here for completeness. We simulate mantle flow using the finite-element geodynamic code ASPECT v3.0.0 [@aspect-doi-v3.0.0; @aspectmanual; @gassmoller2018; @clevenger2021; @fraters2019; @fraters2020] to determine the velocity $\vec{u}$, pressure $P$, and temperature $T$ fields that satisfy the following equations:

$$
  \nabla P - \nabla \cdot \sigma^{\prime} = \rho\, g
$$ {#eq:navier-stokes-no-inertia}

$$
  \frac{\partial \rho}{\partial t} + \nabla \cdot (\rho\, \vec{u}) = 0
$$ {#eq:continuity-compressible}

$$
  \rho\, \bar{C}_p \left(\frac{\partial T}{\partial t} + \vec{u} \cdot \nabla T \right) - \nabla \cdot \left(\bar{k}\, \nabla T \right) = \sigma^{\prime} : \dot{\epsilon}^{\prime} + \bar{\alpha}\, T \left(\vec{u} \cdot \nabla P \right) + Q_L
$$ {#eq:energy}

where $\sigma^{\prime}$ is the deviatoric stress tensor, $\dot{\epsilon}^{\prime}$ is the deviatoric strain rate tensor, $\rho$ is density, $g$ is gravitational acceleration, $t$ is time, and $\bar{C}_p$, $\bar{k}$, $\bar{\alpha}$ are reference specific heat capacity, thermal conductivity, and thermal expansivity respectively. The term $Q_L$ captures latent heat from phase transitions. We adopt the projected density approximation [@gassmoller2020], reformulating @eq:continuity-compressible as:

$$
  \frac{1}{\rho} \frac{\partial \rho}{\partial t} + \nabla \cdot \vec{u} + \left(\frac{1}{\rho} \nabla \rho \right) \cdot \vec{u} = 0
$$ {#eq:continuity-expanded}

The projected density $\rho(T, P, X)$ varies with temperature, pressure, and volume fractions of the relevant mineral phases, ensuring that local density changes from both pressure-temperature (PT) variations and phase transitions influence the flow through buoyancy, volumetric expansion, and compression. See @gassmoller2020 for a detailed discussion of this compressible formulation.

## Numerical Setup {#sec:numerical-setup}

### Adiabatic Reference Conditions {#sec:adiabatic-reference-conditions}

We compute adiabatic reference conditions using the same approach as @kerswell2026a, extended to encompass the full MTZ and uppermost lower mantle (@fig:PYR-material-table). We evaluate entropy changes over a PT range of 1053--2673 K and 0.001--43 GPa using Gibbs free energy minimization with Perple_X [v7.0.9, @connolly2009], assuming a dry pyrolitic bulk composition [@green1979] in the Na$_2$O-CaO-FeO-MgO-Al$_2$O$_3$-SiO$_2$ (NCFMAS) chemical system with the equations of state and solution models of @stixrude2022. We determine an isentropic adiabat using the Newton-Raphson method and evaluate reference material properties ($\bar{\rho}$, $\bar{\alpha}$, $\bar{C}_p$, $\bar{\beta}$) along the adiabat using BurnMan [@cottaar2014; @myhill2023] with equations of state from @stixrude2022 for pure Mg ringwoodite, bridgmanite, and periclase (Figure S1).

![Entropy (left) and density (right) changes across Earth's MTZ under thermodynamic equilibrium and hydrostatic stress conditions. The black box indicates the approximate PT range within our ASPECT simulations. The white line indicates the isentropic adiabat used to calculate reference material properties.](../figs/adiabat/PYR-material-table.png){#fig:PYR-material-table width=65%}

### Initialization and Boundary Conditions {#sec:initialization-and-boundary-conditions}

We conduct simulations in a 1500 $\times$ 1000 km rectangular model domain initialized with equilibrium mineral assemblages across the olivine, wadsleyite, ringwoodite, and post-spinel stability fields. An applied surface pressure of 10 GPa and surface temperature of 1706 K places the 410, 520, and 660 transitions near the center of the model domain (@fig:initial-setup-diagram). We compute initial adiabatic PT profiles by numerically integrating:

$$
  \frac{d\bar{T}}{dy} = \frac{\bar{\alpha}\, \bar{T}\, g}{\bar{C}_p}
$$ {#eq:adiabatic-temperature}

$$
  \frac{d\bar{P}}{dy} = \bar{\rho}\, g
$$ {#eq:adiabatic-pressure}

where the material properties $\bar{\rho}$, $\bar{\alpha}$, and $\bar{C}_p$ are determined from the stable equilibrium assemblage evaluated along the adiabatic reference conditions (Figure S1).

We superimpose Gaussian thermal anomalies on the adiabatic profile using linear features with 15 km half-width Gaussian cross-sections and 5 km tanh-tapered ends. Slab anomalies extend 105 km horizontally and 175 km downward from the top boundary, while plume anomalies extend 280 km upward from the bottom boundary. We prescribe constant inflow velocities $\vec{u}_\mathrm{in}$ of 5 or 10 cm yr$^{-1}$ parallel to the thermal anomalies. Boundary conditions on lateral walls apply zero horizontal velocity with a lithostatic normal traction, and the (open) top and bottom boundaries apply constant normal traction equal to the initial lithostatic pressure.

The revision compares two end-member suites. Warm Sluggish Kinetics imposes a 500 K anomaly with sluggish kinetics. Cold Nominal Kinetics imposes a 1000 K anomaly with nominal kinetics as calibrated. Plumes exist only in the warm-sluggish suite. Section @sec:numerical-experiment-design-and-postprocessing defines the suites, and @sec:reaction-kinetics gives the per-suite kinetic ranges.

![Initial setup for slab (top) and plume (bottom) simulations follows @kerswell2026a, but with an extended 1500 $\times$ 1000 km model domain and additional phase transitions (410, 520, and 660; gray bands). Slabs extend 105 km horizontally and 175 km downward from the top boundary, while plumes extend 280 km upward from the bottom boundary. All other boundary conditions are consistent with @kerswell2026a.](../figs/setup/initial-setup-diagram.png){#fig:initial-setup-diagram width=45%}

### Material Model {#sec:material-model}

#### Material Properties {#sec:material-properties}

We compute material properties with BurnMan with equations of state from @stixrude2022 for pure Mg ringwoodite, bridgmanite, and periclase (see @sec:adiabatic-reference-conditions), and all properties except density are held at their adiabatic reference values (Figure S1). We correct density using a first-order Taylor expansion:

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

where $H^{\ast}$ = 274 kJ mol$^{-1}$ and $V^{\ast}$ = 3.0 $\times$ 10$^{-6}$ m$^3$ mol$^{-1}$. The two suites hold the 410 prefactors at different values. Warm Sluggish Kinetics uses $Z_\mathrm{ol} = Z_\mathrm{wd} = 4.44 \times 10^{-4}$ K s$^{-1}$. Cold Nominal Kinetics uses $Z_\mathrm{ol} = Z_\mathrm{wd} = 1.4 \times 10^{4}$ K s$^{-1}$. The factor $3.15 \times 10^{7}$ between them corrects a year-to-second scaling mistake in the companion 410 study. The published 410 range ran with time in years, so its nominal values ran slower by seconds per year. The erratum records the correction. Warm-sluggish values reproduce the effective rates the 410 simulations actually sampled. Cold-nominal values impose the calibrated nominal rates. AC1--AC2 (5 cm yr$^{-1}$ inflow) and T3--T4 (20 cm yr$^{-1}$ inflow) test sluggish 410 kinetics ($Z_\mathrm{ol} = Z_\mathrm{wd} = 3.0$ and $7.0$ K s$^{-1}$) at cold temperatures and mid-range nominal 660 kinetics ($Z_\mathrm{ri} = 6.0 \times 10^{-1}$ mol$^2$ J$^{-2}$ s$^{-1}$).

The molar Gibbs free energy difference for each phase transformation is approximated by:

$$
  \Delta G \approx \Delta \bar{G} + \hat{P}\, \Delta \bar{V} - \hat{T}\, \Delta \bar{S}
$$ {#eq:gibbs}

where we compute the thermodynamic quantities $\Delta \bar{G}$, $\Delta \bar{V}$, and $\Delta \bar{S}$ for each major reaction along the adiabatic reference profile (Figure S2).

The 660 post-spinel reaction requires a fundamentally different kinetic formulation. Because one phase breaks down to two phases of different compositions, diffusion must play a role regardless of whether interface control has an effect. Microstructural observations show that the forward ringwoodite $\Rightarrow$ bridgmanite + periclase transformation proceeds via diffusion-controlled lamellar decomposition. Bridgmanite and periclase lamellae nucleate rapidly at grain boundaries and grow at rates limited by silicon self-diffusion through the parent ringwoodite [@zener1946; @kubo2002]. Following the diffusion-controlled Zener-Hillert decomposition model [@zener1946; @burke1965], the growth rate for the post-spinel assemblage is:

$$
  \dot{x} = K^{\prime}\, \exp\!\left(-\frac{E^{\ast}}{R\, T}\right)\, \frac{\Delta G^2}{\bar{V}_\mathrm{ps}^2}
$$ {#eq:growth-rate-660}

where $K^{\prime}$ is the growth rate prefactor, $E^{\ast}$ is the activation energy for Si self-diffusion, $\bar{V}_\mathrm{ps}^2 = (V_\mathrm{bg} + V_\mathrm{pe})^2$ is the squared molar volume of the post-spinel assemblage. We refactor $\Delta G^2 = \Delta G \cdot |\Delta G|$ as the thermodynamic driving force term, which keeps reactions reversible when $\Delta G$ $<$ 0.

Combining $N$, $K^{\prime}$, and $\bar{V}_\mathrm{ps}^2$ into a single kinetic prefactor $Z_\mathrm{ri} = \text{6.67}\, K^{\prime}\, /\, d\, \bar{V}_\mathrm{ps}^2$, the macroscopic reaction rate for ringwoodite $\Leftrightarrow$ bridgmanite + periclase becomes:

$$
  \dot{X} = Z_\mathrm{ri}\, \exp\!\left(-\frac{E^{\ast}}{R\, T}\right)\, \Delta G \cdot |\Delta G| \left(1 - X \right)
$$ {#eq:reaction-rate-660}

@eq:reaction-rate-660 introduces a fundamental shift from the interface-controlled reaction mechanism at the 410 and 520 (@eq:reaction-rate-410) to a diffusion-controlled reaction mechanism at the 660. Mathematically, the driving force at the 660 is quadratic ($\Delta G^2$), whereas the 410 and 520 follow a linear approximation near equilibrium $(\Delta G\, /\, RT)$ = 0 before saturating at high overstepping. Physically, this quadratic dependence more aggressively suppresses reaction rates near equilibrium for the 660 transition. Conversely, the lack of exponential saturation means the 660 reaction rate remains sensitive to the magnitude of overstepping even far from equilibrium, unlike the 410 and 520 where the driving force term trends towards unity. These divergent behaviors underpin the distinct structural and dynamic signatures discussed in Sections -@sec:results and -@sec:discussion.

The $Z_\mathrm{ri}$ ranges differ by suite. Warm Sluggish Kinetics spans $5.08 \times 10^{-11}$ to $5.08 \times 10^{-5}$ mol$^2$ J$^{-2}$ s$^{-1}$. Cold Nominal Kinetics spans $1.6 \times 10^{-3}$ to $1.6 \times 10^{3}$ mol$^2$ J$^{-2}$ s$^{-1}$. Both brackets derive from the same calibration against the high-overpressure @kubo2002 dataset with $\bar{V}_\mathrm{ps}$ = 3.381 $\times$ 10$^{-5}$ m$^3$ mol$^{-1}$ (Figure S3). Regression yields $E^{\ast}$ = 310 $\pm$ 233 kJ mol$^{-1}$ and $\ln(K^{\prime})$ = -29.8 $\pm$ 22.1, both consistent with @kubo2002 within uncertainty. We adopt $E^{\ast}$ = 355 kJ mol$^{-1}$ [after @kubo2002], $\ln(K^{\prime})$ in [-33.5, -22.0], and $d$ in [1 $\times$ 10$^{-3}$, 10 $\times$ 10$^{-3}$] m [@karato1984; @karato2008]. The $3.15 \times 10^{7}$ offset between brackets equals seconds per year. The plugin integrates rates in SI seconds.

#### Operator Splitting {#sec:operator-splitting}

Since reaction rates for the 410, 520, and 660 transitions can exceed advective timescales, we employ the first-order operator splitting scheme to decouple reaction from advection. Volume fractions are updated in two sequential steps per advection timestep $\Delta t$: 1) a reaction substep integrating Equations -@eq:reaction-rate-410 and -@eq:reaction-rate-660 over the full $\Delta t$ using the ARKODE adaptive Runge-Kutta integrator [@reynolds2023; @hindmarsh2005] with relative tolerance 1 $\times$ 10$^{-6}$; and 2) an advection step:

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

where $\bar{\eta}$ = 10$^{21}$ Pa s is the background viscosity, $\bar{T}$ is the reference adiabatic temperature, and $\hat{T} = T - \bar{T}$ is the nonadiabatic temperature anomaly. We vary the activation factor $B$ between 5 and 10 to control thermal sensitivity.

We calculate the viscosity jump prefactor $b$ via a log-linear average of per-phase viscosity prefactors ($\nu_\mathrm{ol}, \nu_\mathrm{wd}, \nu_\mathrm{ri}, \nu_\mathrm{ps}$), weighted by the equilibrium fractions $\phi$ defined in @eq:equilibrium-fractions:

$$
  \ln(b) = \sum_{i} \phi_i \ln(\nu_i)
$$ {#eq:rheological-jump-factor}

We adopt this log-linear (geometric) average because it is commonly used for viscosity contrasts across mineral phase mixtures and avoids the sensitivity to the single weakest phase that a harmonic (Reuss) average would introduce [@ji2004]. By anchoring viscosity jumps to the equilibrium fractions $\phi$ rather than the actual (metastable) mineralogy $X$, the viscosity structure remains a function of the adiabatic reference condition. This decoupling prevents spurious viscosity patches arising from metastable phases within cold slabs, allowing us to isolate the kinetic contribution to slab impedance via buoyancy from rheological effects. To maintain numerical stability, we impose a global viscosity floor and ceiling of 10$^{19}$ and 10$^{24}$ Pa s, respectively.

### Numerical Stabilization of Dynamic Pressure Oscillations {#sec:numerical-stabilization-of-dynamic-pressure-oscillations}

Following @gassmoller2020 and @kerswell2026a, we exclude the dynamic pressure $\hat{P}$ contribution to $\Delta G$ in the kinetic rate equations (Equations -@eq:reaction-rate-410 and -@eq:reaction-rate-660) while retaining it in the density formulation (@eq:density-ala). In practice, this means applying $\Delta G \approx \Delta \bar{G} - \hat{T}\, \Delta \bar{S}$ to the kinetic rate equations, which preserves the primary thermal control of the reactions while eliminating pressure-wave feedback. The quadratic $\Delta G \cdot |\Delta G|$ driving force amplifies pressure-wave sensitivity relative to the exponential form used at the 410 and 520, making this stabilization particularly important for the 660. Limitations of this approximation are discussed in @sec:uncertainties-and-model-limitations.

### Numerical Experiment Design and Postprocessing {#sec:numerical-experiment-design-and-postprocessing}

Warm Sluggish Kinetics crosses eight $Z_\mathrm{ri}$ values with two inflow velocities, two thermal sensitivity factors $B$, and two lower-mantle viscosity jumps $b$, running matched slab and plume simulations in every scenario. Cold Nominal Kinetics crosses eight nominal $Z_\mathrm{ri}$ values over the same rheological and kinematic grid for slabs only, plus explicit sluggish-410 tests AC1--AC2 (5 cm yr$^{-1}$ inflow) and T3--T4 (20 cm yr$^{-1}$ inflow) at mid-range 660 kinetics. Warm-sluggish scenarios index 0--7. Cold-nominal scenarios index 8--19. Indices 12--13 stay empty because the 20 cm yr$^{-1}$ inflow exists only at EtaTherm 5 and $b = 1$. The R side recomputes indices deterministically from velocity, $B$, and $b$, so chunked mesh runs keep tile rows unambiguous.

We characterize 660 structure along a representative depth profile that follows the thermal-anomaly extreme with a 150 km per-slice step cap and a 250 K anomaly threshold. 'Displacement' measures the depth where $X_\mathrm{ps}$ reaches 0.9 minus the nominal equilibrium depth (614.7 km). 'Width' measures the depth interval between $X_\mathrm{ps}$ = 0.9 and $X_\mathrm{ps}$ = 0.1. We also report maximum reaction rate $\dot{X}_\mathrm{max}$ and maximum descent velocity $\vec{v}_\mathrm{max}$ within the transition zone. These define a reaction length scale (in km):

$$
  L = 10\, \frac{\vec{v}_\mathrm{max}}{\dot{X}_\mathrm{max}}
$$ {#eq:characteristic-length-scale}

which approximates the depth traversed during one reaction timescale $\tau = 1/\dot{X}_\mathrm{max}$ (Ma). $L$ estimates local completion from peak rate and peak velocity, while width measures the full $X_\mathrm{ps}$ = 0.1--0.9 interval. The two diverge where rate varies strongly inside the transition.

We then split displacement into thermal and kinetic parts. Equilibrium depth comes from the Perple_X profile at slab-core temperature. Core temperature interpolates on the representative trace at the measured $X_\mathrm{ps}$ = 0.9 depth. Thermal offset equals equilibrium depth minus nominal depth, computed as $\gamma \hat{T}/(\rho g)$ with $\gamma_{660} = -1.869$ MPa K$^{-1}$ and $\rho = 4100$ kg m$^{-3}$. Kinetic excess equals measured depth minus equilibrium depth. Nominal depths derive from the Mg100 profiles at runtime. The pipeline (`make -C python split`) writes both parts to `thermal-kinetic-split.csv`, the source for all combined figures.

In slab simulations, $L$ and $\vec{v}_\mathrm{max}$ classify each model with fixed thresholds. Quasi-equilibrium takes $L \leq 5$ km and $\vec{v}_\mathrm{max} > 0.5$ cm yr$^{-1}$. Intermediate takes $L > 5$ km and $\vec{v}_\mathrm{max} > 0.5$ cm yr$^{-1}$. Stagnation takes $\vec{v}_\mathrm{max} \leq 0.5$ cm yr$^{-1}$. The language describes the warm-sluggish suite. Cold-nominal models cluster in quasi-equilibrium (62/2/0 across the dividers, excluding AC1--AC2 and T3--T4).

| Scenario | $\vec{u}_\mathrm{in}$ | $B$ | $b$ |
|:---------|----------------------:|----:|----:|
| 0        |                     5 |   5 |  50 |
| 1        |                     5 |  10 |  50 |
| 2        |                    10 |   5 |  50 |
| 3        |                    10 |  10 |  50 |
| 4        |                     5 |   5 |   1 |
| 5        |                     5 |  10 |   1 |
| 6        |                    10 |   5 |   1 |
| 7        |                    10 |  10 |   1 |

Table: Rheological and kinematic parameters for the eight warm-sluggish scenarios. Cold-nominal scenarios 8--19 repeat this grid at 1000 K anomaly and nominal kinetics, plus a third inflow level at 20 cm yr$^{-1}$ for the T3--T4 twins (12--13 stay empty by design). Units are $\vec{u}_\mathrm{in}$: cm yr$^{-1}$, $B$: dimensionless, $b$: dimensionless. {#tbl:scenarios}

# Results {#sec:results}

## Simulation Snapshots: Matched Slab Pair {#sec:simulation-snapshots}

@fig:snapshot-pair shows the two end members at identical forcing (EtaTherm 5, no lower-mantle viscosity jump at $b = 1$, inflow 5 cm yr$^{-1}$) after 100 Ma. The Warm Sluggish Kinetics slab ponds above the 660. The Cold Nominal Kinetics slab descends through the 660. Plumes exist only in the warm-sluggish suite and remain insensitive to kinetics across the tested range, so the main panels show slabs only.

Warm Sluggish Kinetics (@fig:snapshot-pair: top row; ID_W1) stagnates with $\vec{v}_\mathrm{max} = 0.25$ cm yr$^{-1}$, 660 displacement 48.4 km, and width 10.8 km. Metastable ringwoodite persists above the 660 and supports buoyant ponding. Cold Nominal Kinetics (@fig:snapshot-pair: bottom row; ID_C1) penetrates with $\vec{v}_\mathrm{max} = 2.96$ cm yr$^{-1}$, 660 displacement 40.1 km, and width 6.3 km. Totals look alike; the thermal-kinetic split below shows they arise for different reasons.

![Matched slab pair at identical rheological and kinematic forcing after 100 Ma. Top: Warm Sluggish Kinetics (500 K anomaly, sluggish $Z_\mathrm{ri} = 5.08 \times 10^{-11}$ mol$^2$ J$^{-2}$ s$^{-1}$). Bottom: Cold Nominal Kinetics (1000 K anomaly, nominal $Z_\mathrm{ri} = 1.6 \times 10^{-3}$ mol$^2$ J$^{-2}$ s$^{-1}$). Columns show dynamic temperature $\hat{T}$, dynamic density $\hat{\rho}$, and vertical velocity $\vec{u}_y$. Thick black lines mark the 10% and 90% post-spinel volume fraction contours. The background grid shows ASPECT adaptive refinement. White traces mark the representative depth profiles used for measurements.](../figs/simulation/compositions/slab-pair-set1-composition-W1-C1-0100.png){#fig:snapshot-pair width=100%}

## Structure of the 660: Thermal-Kinetic Split {#sec:structure-of-the-660}

@fig:contributions splits measured 660 displacement into thermal and kinetic parts and plots each against maximum reaction rate. Point size encodes width. Suite colors separate Warm Sluggish Kinetics from Cold Nominal Kinetics. AC1--AC2 and T3--T4 rings mark sluggish-410 tests at nominal 660 kinetics. @fig:tiles-rate maps the same quantities across rheological and kinematic scenarios on the shared rate axis. The two suites fall on one surface. Comparison on $Z_\mathrm{ri}$ would mislead because the tested $Z_\mathrm{ri}$ ranges do not overlap. Rate, kinetic contribution, and width exist for every model, so the revision compares suites on those axes only.

Totals deceive. Median displacement reads 38.0 km warm-sluggish against 34.2 km cold-nominal. Contributions differ. Median kinetic excess reads 18.2 km warm against 8.2 km cold. Median thermal offset reads 16.9 km warm against 25.5 km cold. Warm-fast kinetic excess (9.1 km at the fast $Z_\mathrm{ri}$ end) meets the cold kinetic range (7--10 km). Both mark quasi-equilibrium. Warm kinetic excess rises to 50.1 km at the slow end while thermal offset stays near 14--17 km. Cold kinetic excess stays near 7--10 km while thermal offset stays near 26--30 km.

![Thermal-kinetic split at the 660 for slab models. Left: kinetic excess (measured depth minus equilibrium depth) versus maximum reaction rate. Right: thermal offset (equilibrium depth minus nominal depth) versus maximum reaction rate on the shared 0--70 km axis. Color separates Warm Sluggish Kinetics from Cold Nominal Kinetics. Point size encodes 660 width. Open rings mark AC1--AC2 and T3--T4. Warm kinetic excess climbs as rate falls. Cold kinetic excess stays near the quasi-equilibrium floor while thermal offset stays higher.](../figs/structure/contributions.png){#fig:contributions width=100%}

Rheology and inflow velocity modulate the same surface (@fig:tiles-rate). Warm-sluggish scenarios 0--7 span quasi-equilibrium, intermediate, and stagnation. Cold-nominal scenarios 8--19 stay flat at high rates except for one turning corner at the slowest nominal $Z_\mathrm{ri}$ under fast descent. Scenarios 12--13 are empty by design. The lower-mantle viscosity jump ($b = 50$ against $b = 1$) shifts the stagnation boundary toward faster kinetics for weak slow slabs. Faster inflow shifts it toward slower kinetics for strong slabs and widens the 660 at fixed rate because faster descent advects more metastable material downward before reaction completes. Stronger slabs ($B = 10$) resist stagnation longer but produce the widest, deepest 660s once descent slows.

AC1--AC2 and T3--T4 anchor the 410 side. At nominal 660 kinetics ($Z_\mathrm{ri} = 6.0 \times 10^{-1}$), sluggish 410 kinetics ($Z_\mathrm{ol} = Z_\mathrm{wd} = 3.0$--$7.0$) build 410 kinetic excess of 9--47 km with widths of 10--41 km, while paired 660 kinetic excess stays near 7--8 km. Sluggish olivine kinetics broaden and depress the 410 without broadening the 660 in these cases.

![660 structure across rheological and kinematic scenarios on the shared rate axis. Panels show displacement, width, descent rate through the 660, and reaction length scale $L$. Warm-sluggish scenarios 0--7 occupy the left (slow-rate) side. Cold-nominal scenarios 8--19 occupy the right (fast-rate) side. Dashed lines mark $L = 5$ km and 0.5 cm yr$^{-1}$. The cold turning corner at EtaTherm5/$b = 1$/Vel10 slowest-$Z_\mathrm{ri}$ lands on the warm trend.](../figs/structure/tiles-rate.png){#fig:tiles-rate width=100%}

@fig:regime-joint states the threshold language and the joint 410/660 test. Left: $L$ against descent rate with dividers at 5 km and 0.5 cm yr$^{-1}$. Warm Sluggish Kinetics spans all three regions (20/18/26). Cold Nominal Kinetics sits in quasi-equilibrium (62/2/0). Right: 410 kinetic excess against 660 kinetic excess. AC1--AC2 and T3--T4 carry large 410 excess with near-zero 660 excess.

![Regime and joint 410/660 behavior. Left: reaction length scale $L$ against descent rate. Dashed lines divide quasi-equilibrium (1), intermediate (2), and stagnation (3). Right: 410 kinetic excess against 660 kinetic excess with AC1--AC2 and T3--T4 tags. Point size encodes 660 width. The suites separate on kinetic contribution, not total displacement.](../figs/structure/regime-joint.png){#fig:regime-joint width=100%}

# Discussion {#sec:discussion}

## Uncertainties and Model Limitations {#sec:uncertainties-and-model-limitations}

The primary quantitative uncertainty for the post-spinel reaction stems from the activation energy $E^{\ast}$ for Si self-diffusion and the kinetic prefactor $Z_\mathrm{ri}$, which bundles the growth rate prefactor $K^{\prime}$ and grain size $d$. Monte Carlo regression of the @kubo2002 experimental dataset yields a mean activation energy of 310 $\pm$ 233 kJ mol$^{-1}$ and a mean $\ln(K^{\prime})$ of -29.8 $\pm$ 22.1 (Figure S3). These uncertainties span several orders of magnitude, reflecting incomplete knowledge of Si self-diffusion in ringwoodite at natural PT conditions, dependence on grain size and deformation history, and poorly characterized water content effects on post-spinel diffusion rates. Our simulations therefore bracket plausible kinetic conditions rather than targeting specific natural scenarios, and all three kinetic regimes identified for slabs fall within this uncertainty envelope.

Another key driver of uncertainty is that the kinetic experiments of @kubo2002 were performed at highly-overstepped metastable conditions ($>$ 1 GPa), requiring significant extrapolation to near-equilibrium conditions in our simulations. The quadratic dependence of ringwoodite decomposition on excess Gibbs energy (@eq:reaction-rate-660) results in vanishingly small reaction rates at small pressure oversteps in our simulations. However, it is possible that an alternative, faster transformation mechanism occurs in natural systems at near-equilibrium conditions. This requires further kinetic experiments at small pressure oversteps to determine.

A related simplification concerns the reaction's directionality. Our bidirectional implementation of the reverse reaction (ringwoodite regrowth from bridgmanite + periclase) treats the forward and reverse transformations symmetrically, which represents a simplification. Experiments document that the reverse reaction proceeds substantially more slowly than the forward decomposition, particularly below 2000 K [@lessing2022], introducing a kinetic asymmetry not captured by our symmetric $\Delta G \cdot |\Delta G|$ formulation in @eq:reaction-rate-660. Our simplification likely overestimates reverse reaction rates in ascending plumes and underestimates metastable bridgmanite + periclase persistence in upwelling material. The slight broadening of plume 660 widths at the slowest kinetics in our simulations (up to 10 km) may partly reflect this effect, but a rigorous treatment requires a separate kinetic rate equation for the reverse reaction.

This kinetic framework is itself coupled to thermodynamics in ways we only partially resolve. While our material model implicitly includes latent heating near equilibrium, the latent-heating effect at overstepped metastable conditions merits particular caution for the post-spinel reaction. Because the ringwoodite $\Leftrightarrow$ bridgmanite + periclase Clapeyron slope is negative, the (endothermic) latent-heat effect close to equilibrium reinforces kinetic inhibition. At highly-overstepped metastable conditions, however, the free energy from mechanical work $P\Delta V$ (rather than $T\Delta S$) becomes operative and this reinforcement is lost. This contrasts with the 410, where both the (exothermic) latent-heat effect and $P\Delta V$ contributions promote faster kinetics. Fully resolving this feedback would likely strengthen the regime contrasts we report here and merits dedicated investigation. We also define Gibbs free energy based on the reference pressure (@eq:gibbs), neglecting deviatoric stresses at individual grain interfaces that directly influence reaction pathways and chemical potentials [@wheeler2015; @wheeler2020]. While the reference pressure can provide a reasonable approximation under certain conditions [@wheeler2015b], an improved approach would be to use the dynamic pressure, i.e. the mean normal stress actually experienced by the rock. A rigorous treatment will require consideration of more localized stress-dependent chemical potentials (work in progress).

Beyond these kinetic and thermodynamic uncertainties, our compositional choices introduce additional simplifications. Our pure Mg end-member composition neglects Fe-Mg solid solutions, akimotoite, garnet, and other transition-zone phases present in natural systems [@ita1992; @xu2008; @papanagnou2023]. Iron is unlikely to alter our conclusions substantially because Si self-diffusion limits ringwoodite decomposition. Iron content should therefore have only a minor effect on reaction kinetics, and the narrow ($<$ 1 kbar) Fe-Mg post-spinel phase loop [@ishii2019] means metastable Fe-bearing ringwoodite likely transforms directly to the stable bridgmanite + periclase assemblage, keeping the transition effectively univariant as in our pure Mg model [@ming2006]. In the coldest slab interiors, the akimotoite $\Leftrightarrow$ bridgmanite transition may dominate over the post-spinel transition [@chanyshev2022; @cottaar2016], producing additional deepening beyond our kinetic model. This reaction is nevertheless expected to be comparatively rapid because the ilmenite and perovskite structures are crystallographically closely related [@navrotsky1998], permitting a diffusionless or martensite-like reaction mechanism.

A final set of simplifications concerns the large-scale viscosity structure and dimensionality of our simulations. Our simulations test lower-mantle viscosity jumps of $b$ = 1 and $b$ = 50 to characterize how viscosity structure interacts with kinetic inhibition (@sec:structure-of-the-660; see Figures S4--S7). This approach does not span the full plausible range of lower-mantle viscosity contrasts [estimated at roughly 10--100$\times$, @karato2008; @goes2017], and quantitative predictions remain model-dependent. More broadly, natural subduction involves the simultaneous action of viscosity structure, the Clapeyron slope, plate forcing, and kinetics [@goes2017; @garel2014], and isolating each contribution requires independent observational constraints. Grain-size distribution at the post-spinel reaction front [@kubo2000; @mao2021] could also generate viscosity contrasts that augments stagnation beyond what our rheological model captures. Our simple temperature-dependent rheological model omits grain-size evolution that affect both flow dynamics and reaction kinetics [@karato1984; @hirth2003; @yamazaki2005]. Finally, our 2D simulations neglect 3D slab geometry, trench migration, slab rollback, and lateral flow diversion. In 3D, a slab that retains its dip and is carried laterally away from the 660 by rollback could sustain faster descent than the vertically ponding slabs in our 2D domain, since less metastable material would accumulate locally beneath any one point on the slab. These 3D effects, alongside slab morphology and residence time more broadly, warrant further investigation [@sime2024; @garel2014]. Despite these limitations, our results capture the first-order kinetic effects governing 660 structure and slab dynamics across three distinct regimes.

## Contrasting Reaction Mechanisms at the 410 and 660 {#sec:contrasting-reaction-mechanisms-at-the-410-and-660}

The warm-sluggish regimes at the 660 differ qualitatively from interface-controlled behavior at the 410 (Equations -@eq:volume-fraction to -@eq:reaction-rate-660). At the 410, the driving-force term $(1 - \exp[-\Delta G / RT])$ saturates toward unity once $|\Delta G| \gg RT$ (@eq:reaction-rate-410). Past saturation, only the Arrhenius term $\exp[-(H^\ast + PV^\ast)/RT]$ governs progress. In a cold stagnated slab, the reaction waits until warming activates it, then completes abruptly over a narrow interval and re-sharpens the 410. That threshold defined the published 410 regimes.

At the 660, the diffusion-controlled term $\Delta G \cdot |\Delta G|$ grows quadratically without bound as ringwoodite descends below stability. Larger overstep drives larger silicon chemical-potential gradients across decomposition lamellae and faster transformation [@zener1946; @kubo2002]. No saturation ceiling exists. $\dot{X}_\mathrm{max}$ climbs progressively with depth, and the warm-sluggish 660 widens and deepens continuously without abrupt transformation (@fig:tiles-rate; @fig:regime-joint). Intermediate against stagnation marks degree, not threshold: longer $\tau$, larger $L$, slower descent, broader and deeper discontinuities.

Cold Nominal Kinetics stays fast for three reasons. Nominal $Z_\mathrm{ri}$ offsets the Arrhenius penalty at 900--1300 K slab-core temperatures. Quadratic driving force grows with overstep instead of saturating. Faster descent shortens residence in the transition, so a metastable zone has less time to accumulate. Viscosity anchors to equilibrium fractions, so cold strength shapes geometry without creating spurious viscosity patches; buoyancy from metastable ringwoodite remains the impedance, and at nominal rates that buoyancy never accumulates enough to stall descent. Olivine behaves differently because its factor $(1 - \exp[-\Delta G/RT])$ saturates at high overstep. Once saturated, only the Arrhenius term and $(1 - X)$ govern progress. Cold can freeze olivine until warming triggers an abrupt pulse, as AC1--AC2 and T3--T4 show at the 410. Ringwoodite lacks that ceiling, so overstep accelerates its own consumption.

Metastable olivine in the ultra-sluggish 410 regime transforms in a rapid pulse that can disrupt stalling [@kerswell2026a]. Metastable ringwoodite in warm-sluggish stagnation consumes gradually ($\tau$ up to 26 Ma), sustaining buoyancy that resists penetration over longer timescales. Kinetically stagnated slabs at the 660 persist longer than stalled slabs at the 410, consistent with long-lived ponding in the western Pacific [@fukao2013; @tauzin2017].

Near equilibrium, the quadratic 660 term suppresses rates more strongly than the linear 410 term $(1 - \exp[-\Delta G / RT]) \approx \Delta G / RT$. The suppression broadens the 660 slightly relative to the 410 even at quasi-equilibrium, visible where warm-fast kinetic excess (9.1 km) meets the cold kinetic floor (7--10 km) in @fig:contributions.

## Kinetic Amplification of Temperature-Driven 660 Displacement {#sec:kinetic-amplification-of-temperature-driven-660-displacement}

Equilibrium thermodynamics in our pure Mg system predicts downward 660 displacement from the negative Clapeyron slope shifting post-spinel to higher pressure beneath cold slabs. The akimotoite $\Leftrightarrow$ bridgmanite transition would add 30--90 km in the coldest interiors [@chanyshev2022; @cottaar2016]. Warm-sluggish quasi-equilibrium slabs recover the thermal signal: 11--21 km thermal offset with 6.7--9.1 km kinetic excess. Kinetics then amplify that warm baseline. The deepest warm-sluggish stagnation displacements (to 80 km) reach 2--4 times the warm thermal baseline, depending on rheology and kinematics (@fig:tiles-rate; Table S1). Cold-nominal slabs carry larger thermal offsets (17--39 km) but kinetic excess near 6--8 km, so their totals overlap warm totals for a different reason (@fig:contributions; @fig:seismic-comparison). Water in ringwoodite would broaden post-spinel and raise its pressure [@ghosh2013; @muir2021], deepening cold slabs further, while basalt accumulation modifies reflectivity without systematic depth shifts [@yu2023; @goes2022].

Kinetic effects at the 410 and 660 point in different directions. At the 410, slower rates first broaden and deepen the discontinuity, then re-sharpen it at a depressed position and reverse displacement sign relative to equilibrium. At the 660, kinetics deepen displacement monotonically (@fig:seismic-comparison). The 660 lacks the sign reversal that marks ultra-sluggish 410 behavior.

Joint 410/660 observation in the same slab column exploits the difference (@fig:regime-joint). AC1--AC2 and T3--T4 pair large 410 kinetic excess (9--47 km) with near-zero 660 excess (7--8 km). Broad deep 410 with broad deep 660 fits intermediate inhibition at both transitions. Narrow modest 410 with narrow modest 660 fits quasi-equilibrium across the zone. The joint pattern narrows ambiguity from thermal, compositional, and rheological contributions without eliminating it.

![Synthetic P-wave profiles at matched forcing (EtaTherm 5, $b = 1$, Vel 5) across eight $Z_\mathrm{ri}$ values per suite. Black line marks the adiabatic reference. Bands show Warm Sluggish Kinetics against Cold Nominal Kinetics. Vertical lines mark nominal 410, 520, and 660 depths (364.2, 511.2, 614.7 km). The warm 660 band broadens and deepens. The cold 660 band stays narrow near its thermal offset.](../figs/seismic/seismic-warm-sluggish-cold-nominal.png){#fig:seismic-comparison width=100%}

## Constraining Kinetics from Seismic Observations {#sec:constraining-kinetics-from-seismic-observations}

Seismic observations in several subduction zones show the 660 displaced over a broad area while 410 displacement is either more localized or undetected, possibly because narrow structures escape detection. Examples include subduction zones beneath South America [@ba2025], East Asia [@sun2020; @liu2022; @tang2023], and Europe [@cottaar2016; @kalmar2025]. These studies generally invoke water or the akimotoite $\Leftrightarrow$ bridgmanite transition to explain the pattern, but our results show kinetic inhibition offers an alternative explanation for at least part of the signature.

Beyond depth, width tests the hypothesis. Receiver functions show a 25 km gradient beneath the US [@schmandt2012], a 30--40 km 660 beneath Chile--Argentina [@bonatto2020], and 50--70 km beneath Northeast China [@wang2010]. The Chile--Argentina width falls inside warm-sluggish stagnation (@fig:tiles-rate; Table S1). The Northeast China width fits warm-sluggish stagnation in a strong fast slab.

Beyond depth and width, the 660 also displays a structural complexity that generally exceeds the 410. The discontinuity can appear split [@deuss2006; @boyce2021] or difficult to resolve in long-period PP precursor data [@deuss2009; @lessing2015], and observed amplitude variations in precursors [@waszek2021; @yu2023] and high-frequency scattering [@day2013; @wu2019] point to compositional variations around the boundary. Some of this apparent complexity may itself be a kinetic signature. In higher-frequency data, such as receiver functions, a broad transition may resemble a split one. Determining how much kinetic effects contribute to these observations (versus genuine compositional variation) requires forward modeling of synthetic seismic data [e.g., @lessing2015].

Seismic observations alone, however, cannot fully separate kinetic effects from thermal, compositional, and rheological contributions. The boundaries between regimes shift systematically with $B$, inflow velocity, and the viscosity jump factor $b$, so the same 660 structure is consistent with many kinetic-rheological combinations. As previously stated, joint analysis of the 410 and 660 in the same slab column narrows, rather than eliminates, this ambiguity. However, two laboratory priorities would translate this framework into quantitative observational constraints. The first is high-pressure experiments that reduce uncertainties in ringwoodite decomposition kinetic parameters under cold slab conditions with small pressure oversteps. The second is explicit kinetic models for the reverse post-spinel reaction [e.g., @lessing2022].

## Slab Dynamics and the Diversity of Subduction Behavior {#sec:slab-dynamics-and-the-diversity-of-subduction-behavior}

Ringwoodite kinetics promote stagnation through buoyant metastable ringwoodite without trench retreat or a prescribed viscosity jump. Warm-sluggish slabs pass from penetration at quasi-equilibrium through stalling and flattening at intermediate rates to ponding at stagnation (@fig:snapshot-pair; @sec:structure-of-the-660). Cold-nominal slabs penetrate throughout. The contrast complements the equilibrium mechanisms of @garel2014, @agrusta2017, and @goes2017. Clapeyron slope, viscosity increase, and trench retreat jointly stagnate slabs in those studies. Kinetic inhibition adds an independent impedance here. A viscosity jump reinforces it (Figures S4--S7).

Western Pacific stagnant slabs with 30--60 km depressions [@jiang2015; @tauzin2017] fit warm-sluggish intermediate kinetics, particularly where fast descent amplifies metastable accumulation. Depressions beyond 60 km need stagnation kinetics, akimotoite contribution [@chanyshev2022], or both. Steeply penetrating slabs fit quasi-equilibrium and fit the entire cold-nominal suite as a counterexample: similar thermal anomaly, narrow 660, continuous penetration. Slabs that deflect then sink may record evolution inside intermediate or stagnation regimes, where gradual consumption of metastable ringwoodite removes buoyancy and descent resumes, consistent with 20--30 Ma transience [@mao2018] and with 150--160 Ma residence in kinetic models [@chapman2021] and long-lived ponding [@fukao2013].

Descent rates remain below nature in both suites. Quasi-equilibrium descent reads 0.5--3.2 cm yr$^{-1}$ warm-sluggish and 0.9--6.6 cm yr$^{-1}$ cold-nominal against a natural interquartile range of 2.6--4.8 cm yr$^{-1}$ [@lallemand2005]. The model includes slab pull but omits upper-mantle viscosity structure, basalt/harzburgite buoyancy, volatiles, and 3D rollback and lateral flow. Those omissions shift absolute rates. The qualitative match to slab diversity tests the hypothesis more directly than absolute rates.

Kinetic inhibition acts jointly with rheology and kinematics. Stronger slabs ($B = 10$) descend faster at quasi-equilibrium and carry more material into the metastable zone once descent slows, producing the widest deepest 660s. Weaker slabs decelerate sooner and shift regime boundaries toward faster kinetics (@fig:tiles-rate). Small changes in convergence rate or strength near a boundary can flip behavior between penetrating and stagnant over geologic time [@agrusta2017].

# Conclusions {#sec:conclusions}

We couple diffusion-controlled ringwoodite kinetics to compressible flow with the 410 and 520 resolved, comparing Warm Sluggish Kinetics (500 K, sluggish $Z$) against Cold Nominal Kinetics (1000 K, nominal $Z$) across slab strength, viscosity structure, and inflow velocity. Reaction mechanism governs the outcome. Interface control at the 410 saturates and re-sharpens. Diffusion control at the 660 grows quadratically and changes monotonically.

Sluggish kinetics stagnate slabs. Warm-sluggish models pass from penetration through stalling to ponding as rates slow. Descent slows by an order of magnitude and depression reaches 2--4 times the warm thermal baseline. Nominal kinetics at very cold temperatures keep slabs penetrating. Cold-nominal models cluster at quasi-equilibrium with 6--8 km kinetic excess against 17--39 km thermal offset, despite 1000 K anomalies. AC1--AC2 and T3--T4 confirm the split: large 410 excess with near-zero 660 excess. Kinetic inhibition promotes stagnation independently and amplifies Clapeyron and viscosity effects. Narrow modest reflectors mark quasi-equilibrium. Broad deep reflectors mark stagnation, an alternative to akimotoite, garnet, or water explanations.

Joint 410/660 observation discriminates the mechanisms. Experiments at small oversteps and cold conditions, plus reverse-reaction kinetics, would tighten the calibration. Frequency-dependent inversions of topography and width in well-studied zones would separate kinetic from thermal and compositional signals.

\clearpage

# Acknowledgements {.unnumbered #sec:acknowledgements}

This work was funded by the UKRI NERC Large Grant no. NE/V018477/1. All computations were undertaken on Barkla2, part of the High Performance Computing facilities at the University of Liverpool, who graciously provided expert support. We thank the Computational Infrastructure for Geodynamics ([https://geodynamics.org](https://geodynamics.org)) which is funded by the National Science Foundation under awards EAR-0949446 and EAR-1550901 for supporting the development of ASPECT.

# Data Availability {.unnumbered #sec:data-availability}

All data, code, and relevant information for reproducing this work are archived on the OSF [@kerswell2026b] and Zenodo [@kerswell2026c] repositories. All code within these repositories is MIT Licensed and free for use and distribution (see license details). ASPECT version 3.0.0 [@aspect-doi-v3.0.0] was used for the computations in this study and is freely available under the GPL v2.0 or later license.

# Conflict of Interest {.unnumbered #sec:conflict-of-interest}

The authors declare there are no conflicts of interest for this manuscript.

\clearpage

# References {.unnumbered #sec:references}

::: {#refs}
:::
