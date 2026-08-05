<!--
# Abstract {.unnumbered #sec:abstract}

The 660 km seismic discontinuity ('660') varies beneath subduction zones, ranging from modest depressions consistent with equilibrium thermodynamics to anomalously deep, broad transitions challenging purely thermal interpretations. Laboratory experiments establish that the ringwoodite decomposition responsible for the 660 proceeds via diffusion-controlled kinetics, yet their quantitative effects on 660 structure and slab dynamics have not been evaluated in compressible mantle flow simulations. We couple ringwoodite decomposition kinetics to simulations of mantle plumes and subducting slabs, varying kinetic parameters across six orders of magnitude. Results reveal a fundamental asymmetry between hot and cold environments. In plumes, elevated temperatures produce uplifted, narrow 660s that are relatively insensitive to kinetics due to rapid reaction rates. In slabs, kinetics exert strong control through three regimes: 1) a quasi-equilibrium regime producing 660s consistent with Clapeyron-slope predictions; 2) an intermediate regime where metastable ringwoodite accumulates within a broadening buoyant zone, slowing slab descent; and 3) a stagnation regime where slabs pond above the 660, producing the deepest, broadest 660s and slowest descent velocities. The endothermic Clapeyron slope and kinetic inhibition reinforce each other, amplifying temperature-driven 660 deflection by a factor of 2--4 while independently promoting slab stagnation. Slabs smoothly transition through each regime as reaction rates slow, without abrupt reactions at overstepped metastable conditions. These findings establish ringwoodite kinetics as a first-order control on slab stagnation dynamics and 660 seismic structure under Earth-like conditions, explaining the diverse slab behaviors observed at the base of the mantle transition zone.

\clearpage

# Plain Language Summary {.unnumbered #sec:plain-language-summary}

Earth has a boundary 660 kilometers underground where the mineral ringwoodite transforms into two new minerals. Beneath sinking tectonic plates (slabs), this boundary is often deeper and thicker than expected. Scientists assumed cold plates were the main cause, but laboratory experiments show this transformation is also limited by how quickly ringwoodite reacts. We used computer simulations of rising mantle plumes and sinking slabs to test how reaction speed affects the 660 km boundary structure. In hot plumes, high temperatures allow rapid transformation, so the 660 shifts slightly upward and remains narrow regardless of reaction speed. In cold slabs, reaction speed strongly affects flow behavior. Fast reactions allow slabs to sink steadily with modest 660 deepening. Slower reactions cause untransformed ringwoodite to build up inside the slab, slowing its descent while pushing the 660 deeper and wider. Very slow reactions cause slabs to stall at the 660, producing the deepest, broadest seismic signals. Our results show that ringwoodite transformation speed is a major control on sinking tectonic plates. It can amplify temperature-driven boundary shifts by 2--4 times and slow slab descent by up to ten times, explaining why some slabs sink into the lower mantle while others temporarily flatten.

# Keypoints {.unnumbered #sec:keypoints}

- Plumes consistently uplift the 660; slabs show kinetically controlled deepening and broadening across three distinct regimes.
- Diffusion-controlled kinetics in cold slabs produce monotonically broader and deeper 660s as reaction rates slow.
- Ringwoodite kinetics amplify 660 depressions and reduce slabs velocities, partially explaining slab stagnation and 660 topography.
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

Laboratory experiments establish that the 410 olivine $\Leftrightarrow$ wadsleyite reaction and the 660 post-spinel reaction are governed by fundamentally different physical mechanisms [@hosoya2005; @kubo2002; @dobson2014; @lessing2022], which translate into different semi-empirical kinetic rate equations with distinct mathematical formulations and parameter dependencies. In a companion study, @kerswell2026a coupled *interface-controlled* olivine $\Leftrightarrow$ wadsleyite kinetics to compressible mantle flow simulations and identified three distinct kinetic regimes in cold slabs with diagnostic seismic signatures at the 410. Because *diffusion-controlled* ringwoodite decomposition kinetics takes a different mathematical form, it is expected to produce qualitatively different dynamic behavior at the 660. Whether these two reaction mechanisms produce different flow dynamics and discontinuity structures, and whether reaction kinetics at the 660 matter at all for large-scale mantle flow, has not been systematically evaluated in geodynamic simulations of Earth's upper mantle.

Here, we couple experimentally calibrated ringwoodite decomposition kinetics [after @kubo2002] to compressible mantle flow simulations using ASPECT [@kronbichler2012; @heister2017]. Our simulations simultaneously resolve the 410, 520, and 660 transitions, enabling the first direct comparison between reaction mechanisms in a consistent dynamic framework. We hypothesize that ringwoodite decomposition kinetics control whether slabs penetrate or stagnate at the 660, such that slower reaction rates sustain a buoyant metastable zone that impedes descent while faster rates facilitate continuous penetration. We further hypothesize that kinetic inhibition thickens and flattens slabs above the 660, producing seismically broad, deeply displaced discontinuities in stagnant settings and narrow, modestly displaced signals where kinetics are fast. These hypotheses motivate three specific questions:

1. Do ringwoodite decomposition kinetics control 660 structure and slab dynamics, and how do these effects differ from those at the 410?
2. How do rheological strength contrasts and slab kinematics modulate kinetic effects on 660 structure?
3. Can seismic observations of 660 structure independently constrain ringwoodite decomposition kinetics?

We vary ringwoodite decomposition kinetics across six orders of magnitude, spanning the range permitted by typical grain sizes under nominally dry conditions [@karato1984; @kubo2002; @karato2008]. We also vary rheological strength contrasts, inflow velocities, and lower-mantle viscosity contrasts. The results show three kinetic regimes at the 660 that amplify temperature-driven 660 displacements by a factor of 2--4 and reduce slab descent rates by up to an order of magnitude. Unlike the kinetic regimes at the 410, which include an abrupt reaction threshold at highly-overstepped metastable conditions, the 660 regimes change monotonically from quasi-equilibrium to stagnation. We discuss how the differences between the two reaction mechanisms produce fundamentally different slab dynamics and discontinuity structures, and how jointly observing the 410 and 660 in the same slab column offers a seismological pathway toward discriminating kinetic from thermal and compositional contributions to MTZ structure.

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

We conduct simulations in a 1500 $\times$ 1000 km rectangular model domain initialized with equilibrium mineral assemblages across the olivine, wadsleyite, ringwoodite, and post-spinel stability fields. An applied surface pressure of 10 GPa and surface temperature of 1706 K places the 410, 520, and 660 transitions at approximately the center of the model domain (@fig:initial-setup-diagram). We compute initial adiabatic PT profiles by numerically integrating:

$$
  \frac{d\bar{T}}{dy} = \frac{\bar{\alpha}\, \bar{T}\, g}{\bar{C}_p}
$$ {#eq:adiabatic-temperature}

$$
  \frac{d\bar{P}}{dy} = \bar{\rho}\, g
$$ {#eq:adiabatic-pressure}

where the material properties $\bar{\rho}$, $\bar{\alpha}$, and $\bar{C}_p$ are determined from the stable equilibrium assemblage evaluated along the adiabatic reference conditions (Figure S1).

We superimpose Gaussian thermal anomalies of $\pm$ 500 K on the adiabatic profile using linear features with 15 km half-width Gaussian cross-sections and 5 km tanh-tapered ends. Slab anomalies extend 105 km horizontally and 175 km downward from the top boundary, while plume anomalies extend 280 km upward from the bottom boundary. We prescribe constant inflow velocities $\vec{u}_\mathrm{in}$ of 5 or 10 cm yr$^{-1}$ parallel to the thermal anomalies. Boundary conditions on lateral walls apply zero horizontal velocity with a lithostatic normal traction, and the (open) top and bottom boundaries apply constant normal traction equal to the initial lithostatic pressure.

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

where $H^{\ast}$ = 274 kJ mol$^{-1}$, $V^{\ast}$ = 3.0 $\times$ 10$^{-6}$ m$^3$ mol$^{-1}$, and we hold the kinetic prefactors fixed at $Z_\mathrm{ol}$ = $Z_\mathrm{wd}$ = 1.4 $\times$ 10$^4$ K s$^{-1}$. These coefficients correspond to relatively fast, quasi-equilibrium 410 and 520 reaction rates [@kerswell2026a], and we choose them deliberately to avoid interfering with the kinetic signal investigated at the 660.

The molar Gibbs free energy difference for each phase transformation is approximated by:

$$
  \Delta G \approx \Delta \bar{G} + \hat{P}\, \Delta \bar{V} - \hat{T}\, \Delta \bar{S}
$$ {#eq:gibbs}

where we compute the thermodynamic quantities $\Delta \bar{G}$, $\Delta \bar{V}$, and $\Delta \bar{S}$ for each major reaction along the adiabatic reference profile (Figure S2).

The 660 post-spinel reaction requires a fundamentally different kinetic formulation. Because one phase breaks down to two phases of different compositions, diffusion must play a role regardless of whether interface control has an effect. Microstructural observations show that the forward ringwoodite $\Rightarrow$ bridgmanite + periclase transformation proceeds via diffusion-controlled lamellar decomposition. Bridgmanite and periclase lamellae nucleate rapidly at grain boundaries and grow at rates limited by silicon self-diffusion through the parent ringwoodite [@zener1946; @kubo2002]. Following the diffusion-controlled Zener-Hillert decomposition model [@zener1946; @burke1965], the growth rate for the post-spinel assemblage is:

$$
  \dot{x} = K^{\prime}\, \exp\!\left(-\frac{E^{\ast}}{R\, T}\right)\, \frac{\Delta G^2}{\bar{V}_\mathrm{ps}^2}
$$ {#eq:growth-rate-660}

where $K^{\prime}$ is the growth rate prefactor, $E^{\ast}$ is the activation energy for Si self-diffusion, $\bar{V}_\mathrm{ps}^2 = (V_\mathrm{bg} + V_\mathrm{pe})^2$ is the squared molar volume of the post-spinel assemblage. We refactor $\Delta G^2 = \Delta G \cdot |\Delta G|$ as the thermodynamic driving force term, which allows for reversible reactions when $\Delta G$ $<$ 0.

Combining $N$, $K^{\prime}$, and $\bar{V}_\mathrm{ps}^2$ into a single kinetic prefactor $Z_\mathrm{ri} = \text{6.67}\, K^{\prime}\, /\, d\, \bar{V}_\mathrm{ps}^2$, the macroscopic reaction rate for ringwoodite $\Leftrightarrow$ bridgmanite + periclase becomes:

$$
  \dot{X} = Z_\mathrm{ri}\, \exp\!\left(-\frac{E^{\ast}}{R\, T}\right)\, \Delta G \cdot |\Delta G| \left(1 - X \right)
$$ {#eq:reaction-rate-660}

@eq:reaction-rate-660 introduces a fundamental shift from the interface-controlled reaction mechanism at the 410 and 520 (@eq:reaction-rate-410) to a diffusion-controlled reaction mechanism at the 660. Mathematically, the driving force at the 660 is quadratic ($\Delta G^2$), whereas the 410 and 520 follow a linear approximation near equilibrium $(\Delta G\, /\, RT)$ = 0 before saturating at high overstepping. Physically, this quadratic dependence more aggressively suppresses reaction rates near equilibrium for the 660 transition. Conversely, the lack of exponential saturation means the 660 reaction rate remains sensitive to the magnitude of overstepping even far from equilibrium, unlike the 410 and 520 where the driving force term trends towards unity. These divergent behaviors underpin the distinct structural and dynamic signatures discussed in Sections -@sec:results and -@sec:discussion.

The range of $Z_\mathrm{ri}$ explored in our experiments [1.6 $\times$ 10$^{-3}$, 1.6 $\times$ 10$^3$] mol$^2$ J$^{-2}$ s$^{-1}$ is calibrated against the high-overpressure experimental dataset of @kubo2002 using Monte Carlo regression with a post-spinel molar volume of $\bar{V}_\mathrm{ps}$ = 3.381 $\times$ 10$^{-5}$ m$^3$ mol$^{-1}$ (Figure S3). Our regression yields $E^{\ast}$ = 310 $\pm$ 233 kJ mol$^{-1}$ and $\ln(K^{\prime})$ = -29.8 $\pm$ 22.1, both consistent with @kubo2002 within uncertainty. We therefore adopt $E^{\ast}$ = 355 kJ mol$^{-1}$ [after @kubo2002], $\ln(K^{\prime})$ in the range [-33.5, -22.0], and $d$ in the range [1 $\times$ 10$^{-3}$, 10 $\times$ 10$^{-3}$] m [@karato1984; @karato2008], such that $Z_\mathrm{ri}$ spans conditions from slow kinetics in coarse-grained rocks to fast kinetics in fine-grained rocks.

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

We explore the ringwoodite decomposition kinetic parameter space across eight scenarios spanning two inflow velocities, two rheological strength contrasts, and two lower-mantle viscosity jumps (@tbl:scenarios), running matched slab and plume simulations across the full tested range of $Z_\mathrm{ri}$ within every scenario.

We characterize 660 structure using two diagnostic measures extracted along a representative depth profile through each simulation. 'Displacement' is the difference between the depth at which the post-spinel volume fraction $X_\mathrm{ps}$ reaches 0.9 and the nominal equilibrium post-spinel depth. 'Width' is the depth interval between $X_\mathrm{ps}$ = 0.9 and $X_\mathrm{ps}$ = 0.1. We also report the maximum post-spinel reaction rate $\dot{X}_\mathrm{max}$ and the maximum descent (or ascent) velocity $\vec{v}_\mathrm{max}$ along the same profile, extracted within the phase transition zone (defined by the measured 660 width). These later two quantities allow us to define a characteristic reaction completion length scale (in km):

$$
  L = 10\, \frac{\vec{v}_\mathrm{max}}{\dot{X}_\mathrm{max}}
$$ {#eq:characteristic-length-scale}

which approximates the depth traversed during one characteristic reaction timescale $\tau = 1/\dot{X}_\mathrm{max}$ (Ma). $L$ and the measured 660 width are related but not identical. $L$ is a local estimate based on the maximum reaction rate and maximum vertical velocity through the 660, whereas width measures the full spatial extent of the transition between $X_\mathrm{ps}$ = 0.1 and 0.9. The two metrics diverge where reaction rate varies strongly within the phase transition zone.

In slab simulations, $L$ and $\vec{v}_\mathrm{max}$ are subsequently used to heuristically classify each model into three regimes using fixed threshold values. The quasi-equilibrium regime corresponds to $L$ $\leq$ 5 km and $\vec{v}_\mathrm{max}$ $>$ 0.5 cm yr$^{-1}$; the intermediate regime corresponds to $L$ $>$ 5 km and $\vec{v}_\mathrm{max}$ $>$ 0.5 cm yr$^{-1}$; and the stagnation regime correspond to $\vec{v}_\mathrm{max}$ $\leq$ 0.5 cm yr$^{-1}$.

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

Table: Rheological and kinematic parameters for the eight tested scenarios. Units are $\vec{u}_\mathrm{in}$: cm yr$^{-1}$, $B$: dimensionless, $b$: dimensionless. {#tbl:scenarios}

# Results {#sec:results}

## Simulation Snapshots: Slabs and Plumes {#sec:simulation-snapshots}

Figures -@fig:slab-composition-660-b01 and -@fig:plume-composition-660-b01 show slab and plume simulations for scenario 4 (@tbl:scenarios) after 100 Ma and 50 Ma, respectively. This reference scenario illustrates the range of 660 structures produced across three kinetic conditions characterizing slow to fast reaction rates. Ringwoodite decomposition kinetics strongly control slab dynamics while affecting plume structure more modestly, consistent with the asymmetric pattern documented at the 410 by @kerswell2026a.

In slab simulations, three regimes emerge with decreasing $Z_\mathrm{ri}$. In the quasi-equilibrium regime (@fig:slab-composition-660-b01: bottom row; $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^3$ mol$^2$ J$^{-2}$ s$^{-1}$), the slab descends through the 660 at 1.6 cm yr$^{-1}$ and the 660 is narrow (6 km) and modestly displaced (25 km), consistent with Clapeyron-slope predictions for the imposed thermal anomaly. In the intermediate regime (@fig:slab-composition-660-b01: middle row; $Z_\mathrm{ri}$ = 6.0 $\times$ 10$^{-1}$ mol$^2$ J$^{-2}$ s$^{-1}$), metastable ringwoodite accumulates and reduces descent through the 660 to 1.1 cm yr$^{-1}$, deepening the 660 by 40 km and widening it to 12 km. In the stagnation regime (@fig:slab-composition-660-b01: top row; $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^{-3}$ mol$^2$ J$^{-2}$ s$^{-1}$), persistent metastable buoyancy arrests descent ($\vec{v}_\mathrm{max}$ = 0.25 cm yr$^{-1}$) and the slab ponds above the 660, displacing it by 48 km and broadening it to 11 km.

In plume simulations, the 660 remains uplifted and relatively sharp across all tested kinetic conditions. Under the slowest reaction rates (@fig:plume-composition-660-b01: top row; $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^{-3}$ mol$^2$ J$^{-2}$ s$^{-1}$), the plume ascends through the 660 at 3 cm yr$^{-1}$ with the 660 displaced by 14 km upward and widening to 9 km. Under intermediate and fast kinetic conditions (@fig:plume-composition-660-b01: middle and bottom rows; $Z_\mathrm{ri}$ = 6.0 $\times$ 10$^{-1}$ and 1.6 $\times$ 10$^3$ mol$^2$ J$^{-2}$ s$^{-1}$), the 660 narrows to 7 km and is uplifted 10 km, with ascent velocities through the 660 of 4 cm yr$^{-1}$. Elevated plume temperatures maintain $\dot{X}_\mathrm{max}$ above 3 Ma$^{-1}$ even at the slowest tested $Z_\mathrm{ri}$, suppressing extended metastable zones like those formed in cold slabs. This kinetic insensitivity of plume dynamics and 660 structures holds qualitatively across the full tested parameter space and contrasts sharply with the strong kinetic control on slab behavior.

![Reference slab simulations with moderate inflow velocity, intermediate slab strength, and no lower-mantle viscosity jump (scenario 4; @tbl:scenarios). Rows show stagnation (top row: $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^{-3}$ mol$^2$ J$^{-2}$ s$^{-1}$), intermediate (middle row: $Z_\mathrm{ri}$ = 6.0 $\times$ 10$^{-1}$ mol$^2$ J$^{-2}$ s$^{-1}$), and quasi-equilibrium (bottom row: $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^3$ mol$^2$ J$^{-2}$ s$^{-1}$) kinetic regimes after 100 Ma. Columns show dynamic temperature $\hat{T}$ (left column), dynamic density $\hat{\rho}$ (middle column), and vertical velocity $\vec{u}_y$ (right column). Thick black lines (left column) highlight the 10% and 90% wadsleyite and post-spinel volume fraction contours used to define 660 displacement and width. The background grid pattern indicates ASPECT's adaptive mesh refinement near high thermal gradients and phase transitions. White trace (left column) indicates the representative depth profile used to extract data, and the white arrows indicate where the 660 structure is evaluated.](../figs/simulation/compositions/slab-set1-composition-b01-0100.png){#fig:slab-composition-660-b01 width=100%}

![Reference plume simulations with moderate inflow velocity, intermediate plume strength, and no lower-mantle viscosity jump (scenario 4; @tbl:scenarios). Rows show ultra-sluggish (top row: $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^{-3}$ mol$^2$ J$^{-2}$ s$^{-1}$), intermediate (middle row: $Z_\mathrm{ri}$ = 6.0 $\times$ 10$^{-1}$ mol$^2$ J$^{-2}$ s$^{-1}$), and fast (bottom row: $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^3$ mol$^2$ J$^{-2}$ s$^{-1}$) kinetic conditions after 50 Ma. All other annotations follow @fig:slab-composition-660-b01. The 660 is uplifted across all kinetic conditions, consistent with the negative Clapeyron slope, but 660 width increases and plume ascent slows measurably under the slowest kinetic conditions (top row).](../figs/simulation/compositions/plume-set1-composition-b01-0050.png){#fig:plume-composition-660-b01 width=100%}

## Structure of the 660: Displacement and Width {#sec:structure-of-the-660}

@fig:660-structure summarizes 660 displacement and width as a function of maximum reaction rate $\dot{X}_\mathrm{max}$ across the full suite of plume and slab simulations, and @fig:660-structure-comp maps all results across the full kinetic-rheological-kinematic parameter space (Table S1). Together, the figures reveal three kinetic regimes in slabs, near-invariant 660 structure in plumes, plus independent and coupled kinetic-kinematic-rheological effects on 660 structure and slab descent.

Plume 660 structure remains largely independent of kinetics across the full tested range of kinetic prefactors $Z_\mathrm{ri}$ (@fig:660-structure). Upward displacements vary only from 10--22 km and widths from 5--10 km across six orders of magnitude variation in $Z_\mathrm{ri}$, and ascent velocities through the 660 remain within 2--8 cm yr$^{-1}$ regardless of kinetics. These are relatively narrow ranges compared to the order-of-magnitude changes seen in slabs. Even at the slowest tested conditions ($Z_\mathrm{ri}$ = 1.6 $\times$ 10$^{-3}$ mol$^2$ J$^{-2}$ s$^{-1}$), maximum reaction rates in plumes reach 3--7 Ma$^{-1}$ ($\tau \lesssim 0.3$ Ma; $L \lesssim 10$ km), maintaining a narrow (7--10 km) and consistently uplifted (14--22 km) 660. Plume 660 widths are systematically broader than plume 410 widths at equivalent kinetic conditions, but only marginally (cf. circle and triangle datapoints in @fig:660-structure).

Slab 660 structure changes substantially across three kinetic regimes (@fig:660-structure-comp). Regime boundaries follow two heuristic thresholds: 1) $L$ $\lesssim$ 5 km separates quasi-equilibrium from intermediate regimes, and 2) $\vec{v}_\mathrm{max}$ $\lesssim$ 0.5 cm yr$^{-1}$ separates intermediate from stagnation regimes (see @sec:numerical-experiment-design-and-postprocessing). In the quasi-equilibrium regime (region 1 in @fig:660-structure-comp), $\tau$ remains below 2 Ma and slabs descend through the 660 at 0.5--3.2 cm yr$^{-1}$, with the 660 displaced 22--36 km downward and 4--12 km wide. In the intermediate regime (region 2 in @fig:660-structure-comp), $\tau$ spans 0.5--13.1 Ma and descent velocities through the 660 of 0.4--2.4 cm yr$^{-1}$ produce continuous but progressively slower slab penetration, with the 660 deepening by 40--80 km and widening to 9--34 km. In the stagnation regime (region 3 in @fig:660-structure-comp), descent velocities through the 660 of 0.1--0.5 cm yr$^{-1}$ and $\tau$ up to 26 Ma leave the 660 displaced 27--80 km downward with widths of 6--34 km. In contrast to the abrupt re-sharpening threshold at the 410 [@kerswell2026a], 660 displacement and width increase monotonically with decreasing $Z_\mathrm{ri}$ across all three regimes, with no re-sharpening at any tested kinetic prefactor (@fig:660-structure). The direction of 660 displacement also differs from the 410. At the 410, displacement changes sign from uplifted under quasi-equilibrium conditions to depressed in the ultra-sluggish regime [@kerswell2026a], whereas at the 660, slower kinetics amplify downward displacement monotonically across all three regimes (cf. circle and triangle datapoints in @fig:660-structure).

![Measured 660 width (top) and displacement (bottom) versus maximum reaction rates in plume (left) and slab (right) simulations after 50 Ma and 100 Ma, respectively. Triangles show the 660 results from this study (Table S1) while circles show the 410 results from @kerswell2026a for comparison. The 660 structure near plumes shows consistent upward displacements and moderate widths with minimal dependence on $\dot{X}_\mathrm{max}$ across six orders of magnitude variation. Unlike the 410, the 660 structure near slabs (right column) changes monotonically with decreasing $\dot{X}_\mathrm{max}$ and no re-sharpening occurs at ultra-sluggish kinetic conditions. The modest scatter of the 660 results (triangles) at fixed $\dot{X}_\mathrm{max}$ reflects the additional, systematically varying influence of inflow velocity ($\vec{u}_\mathrm{in}$), rheological contrast ($B$), and lower-mantle viscosity jump ($b$). These effects are explored more completely in @fig:660-structure-comp.](../figs/structure/composition.png){#fig:660-structure width=70%}

@fig:660-structure-comp further isolates four trends in slab simulations across the eight tested scenarios (@tbl:scenarios). The first is an independent effect, while the latter three reflect coupled interactions between two or more parameters.

The kinetic prefactor $Z_\mathrm{ri}$ controls maximum reaction rate independently of rheology or kinematics. Maximum reaction rate decreases monotonically and proportionally with $Z_\mathrm{ri}$ across all eight scenarios, spanning approximately 0.04--135 Ma$^{-1}$ (@fig:660-structure-comp), consistent with the direct $Z_\mathrm{ri}$ scaling in @eq:reaction-rate-660.

The lower-mantle viscosity jump ($b$ = 50, compared to no jump at $b$ = 1) exerts a first-order control on slab descent velocity through the 660 (see Figures S4--S7), shifting the stagnation regime boundary toward higher $Z_\mathrm{ri}$. Comparing scenarios with $b$ = 50 (scenarios 0--3) to $b$ = 1 (scenarios 4--7) at equivalent $B$ and $\vec{u}_\mathrm{in}$, the stagnation regime boundary shifts by up to four orders of magnitude in $Z_\mathrm{ri}$ for the weakest and slowest slab configurations (cf. scenarios 0 and 4 in @fig:660-structure-comp). This effect is most pronounced for weaker slabs ($B$ = 5). For instance, scenario 0 ($\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$, $B$ = 5, $b$ = 50) falls at or below the 0.5 cm yr$^{-1}$ stagnation threshold for all tested $Z_\mathrm{ri}$, effectively stagnating across the entire kinetic range. For stronger slabs ($B$ = 10; scenarios 1 and 3), the effect of a lower-mantle viscosity jump on the stagnation regime boundary is substantially reduced. Thus, while the presence of a viscosity jump consistently promotes stagnation, its absolute impact is modulated by an interaction between mantle and slab strength contrasts ($b$ versus $B$).

Inflow velocity and kinetics also interact to influence descent velocity through the 660 and 660 structure. Higher inflow velocity ($\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$) shifts the stagnation regime boundary toward lower $Z_\mathrm{ri}$ relative to $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$ at equivalent $B$ and $b$. This happens most clearly for stronger slabs (cf. scenarios 1 and 3; 5 and 7 in @fig:660-structure-comp), where the shift reaches 1--2 orders of magnitude. At the same time, faster inflow produces larger displacements and widths across all regimes; $\vec{u}_\mathrm{in}$ = 10 cm yr$^{-1}$ scenarios (2, 3, 6, 7) reach 22--80 km displacement and 4--34 km width, compared to 22--59 km and 4--21 km for $\vec{u}_\mathrm{in}$ = 5 cm yr$^{-1}$ scenarios (0, 1, 4, 5). Both the stagnation regime boundary shift and the increase in 660 displacement and width reflect that faster descent advects more metastable ringwoodite to greater depths before ponding.

In parallel with the coupled interactions above, slab strength and descent velocity through the 660 operate in tandem to further modulate 660 structure. Weaker slabs ($B$ = 5; scenarios 0, 2, 4, 6) decelerate more readily than stronger slabs ($B$ = 10; scenarios 1, 3, 5, 7), stagnating at up to two orders of magnitude higher $Z_\mathrm{ri}$ and shifting both regime boundaries toward faster kinetic conditions (@fig:660-structure-comp). In the intermediate regime, stronger slabs produce substantially larger 660 displacements (40--80 km; mean 57 km) than weaker slabs (40--56 km; mean 47 km) at equivalent $Z_\mathrm{ri}$. The fastest and strongest slabs (scenarios 3 and 7) resist stagnation, even under ultra-sluggish kinetic conditions ($Z_\mathrm{ri}$ $\lesssim$ 1.2 $\times$ 10$^{-2}$ mol$^2$ J$^{-2}$ s$^{-1}$), producing the largest displacements (78--80 km) and widths (26--34 km) in our simulations. At the same $Z_\mathrm{ri}$, weaker counterparts (scenarios 2 and 6) are already stagnant, with notably smaller displacements (68--75 km). Taken together, weaker slabs are more prone to stagnation but produce smaller maximum displacements, while stronger slabs resist stagnation longer and ultimately generate the widest and most deeply displaced 660s when their descent through the 660 slows---a trend that reflects coupled kinetic, kinematic, and rheological controls on 660 structure.

![Variation in 660 structure and slab descent rate through the 660 across kinetic ($Z_\mathrm{ri}$), kinematic ($\vec{u}_\mathrm{in}$), and rheological ($B$, $b$) parameter space. Panels show maximum reaction rate (top left), maximum vertical velocity through the 660 (top right), 660 width (bottom left), and 660 displacement (bottom right) as functions of the kinetic prefactor $Z_\mathrm{ri}$ (horizontal axis, log scale) and remaining parameter space reduced to eight scenarios [$\vec{u}_\mathrm{in}$, $B$, $b$]: **0)** [5, 5, 50]; **1)** [5, 10, 50]; **2)** [10, 5, 50]; **3)** [10, 10, 50]; **4)** [5, 5, 1]; **5)** [5, 10, 1]; **6)** [10, 5, 1]; **7)** [10, 10, 1] (@tbl:scenarios). Units are $\vec{u}_\mathrm{in}$: cm yr$^{-1}$, $B$: dimensionless, $b$: dimensionless. Each tile represents the measured value after 100 Ma (Table S1). Black and white lines delineate transitions between regime behaviors, and their positions shift with $B$, $b$, and $\vec{u}_\mathrm{in}$. Regime labels correspond to: (1) quasi-equilibrium, (2) intermediate, and (3) stagnation.](../figs/structure/tiles-660.png){#fig:660-structure-comp width=70%}

# Discussion {#sec:discussion}

## Uncertainties and Model Limitations {#sec:uncertainties-and-model-limitations}

The primary quantitative uncertainty for the post-spinel reaction stems from the activation energy $E^{\ast}$ for Si self-diffusion and the kinetic prefactor $Z_\mathrm{ri}$, which bundles the growth rate prefactor $K^{\prime}$ and grain size $d$. Monte Carlo regression of the @kubo2002 experimental dataset yields a mean activation energy of 310 $\pm$ 233 kJ mol$^{-1}$ and a mean $\ln(K^{\prime})$ of -29.8 $\pm$ 22.1 (Figure S3). These uncertainties span several orders of magnitude, reflecting incomplete knowledge of Si self-diffusion in ringwoodite at natural PT conditions, dependence on grain size and deformation history, and poorly characterized water content effects on post-spinel diffusion rates. Our simulations therefore bracket plausible kinetic conditions rather than targeting specific natural scenarios, and all three kinetic regimes identified for slabs fall within this uncertainty envelope.

Another key driver of uncertainty is that the kinetic experiments of @kubo2002 were performed at highly-overstepped metastable conditions ($>$ 1 GPa), requiring significant extrapolation to near-equilibrium conditions in our simulations. The quadratic dependence of ringwoodite decomposition on excess Gibbs energy (@eq:reaction-rate-660) results in vanishingly small reaction rates at small pressure oversteps in our simulations. However, it is possible that an alternative, faster transformation mechanism occurs in natural systems at near-equilibrium conditions. This requires further kinetic experiments at small pressure oversteps to determine.

A related simplification concerns the reaction's directionality. Our bidirectional implementation of the reverse reaction (ringwoodite regrowth from bridgmanite + periclase) treats the forward and reverse transformations symmetrically, which represents a simplification. Experiments document that the reverse reaction proceeds substantially more slowly than the forward decomposition, particularly below 2000 K [@lessing2022], introducing a kinetic asymmetry not captured by our symmetric $\Delta G \cdot |\Delta G|$ formulation in @eq:reaction-rate-660. Our simplification likely overestimates reverse reaction rates in ascending plumes and underestimates metastable bridgmanite + periclase persistence in upwelling material. The slight broadening of plume 660 widths at the slowest kinetics in our simulations (up to 10 km) may partly reflect this effect, but a rigorous treatment requires a separate kinetic rate equation for the reverse reaction.

This kinetic framework is itself coupled to thermodynamics in ways we only partially resolve. While our material model implicitly includes latent heating near equilibrium, the latent-heating effect at overstepped metastable conditions merits particular caution for the post-spinel reaction. Because the ringwoodite $\Leftrightarrow$ bridgmanite + periclase Clapeyron slope is negative, the (endothermic) latent-heat effect close to equilibrium reinforces kinetic inhibition. At highly-overstepped metastable conditions, however, the free energy from mechanical work $P\Delta V$ (rather than $T\Delta S$) becomes operative and this reinforcement is lost. This contrasts with the 410, where both the (exothermic) latent-heat effect and $P\Delta V$ contributions promote faster kinetics. Fully resolving this feedback would likely strengthen the regime contrasts we report here and merits dedicated investigation. We also define Gibbs free energy based on the reference pressure (@eq:gibbs), neglecting deviatoric stresses at individual grain interfaces that directly influence reaction pathways and chemical potentials [@wheeler2015; @wheeler2020]. While the reference pressure can provide a reasonable approximation under certain conditions [@wheeler2015b], an improved approach would be to use the dynamic pressure, i.e. the mean normal stress actually experienced by the rock. A rigorous treatment will require consideration of more localized stress-dependent chemical potentials (work in progress).

Beyond these kinetic and thermodynamic uncertainties, our compositional choices introduce additional simplifications. Our pure Mg end-member composition neglects Fe-Mg solid solutions, akimotoite, garnet, and other transition-zone phases present in natural systems [@ita1992; @xu2008; @papanagnou2023]. Iron is unlikely to alter our conclusions substantially because Si self-diffusion limits ringwoodite decomposition. Iron content should therefore have only a minor effect on reaction kinetics, and the narrow ($<$ 1 kbar) Fe-Mg post-spinel phase loop [@ishii2019] means metastable Fe-bearing ringwoodite likely transforms directly to the stable bridgmanite + periclase assemblage, keeping the transition effectively univariant as in our pure Mg model [@ming2006]. In the coldest slab interiors, the akimotoite $\Leftrightarrow$ bridgmanite transition may dominate over the post-spinel transition [@chanyshev2022; @cottaar2016], producing additional deepening beyond our kinetic model. This reaction is nevertheless expected to be comparatively rapid because the ilmenite and perovskite structures are crystallographically closely related [@navrotsky1998], permitting a diffusionless or martensite-like reaction mechanism.

A final set of simplifications concerns the large-scale viscosity structure and dimensionality of our simulations. Our simulations test lower-mantle viscosity jumps of $b$ = 1 and $b$ = 50 to partially characterize how viscosity structure interacts with kinetic inhibition (@sec:structure-of-the-660; see Figures S4--S7). This approach does not span the full plausible range of lower-mantle viscosity contrasts [estimated at roughly 10--100$\times$, @karato2008; @goes2017], and quantitative predictions remain model-dependent. More broadly, natural subduction involves the simultaneous action of viscosity structure, the Clapeyron slope, plate forcing, and kinetics [@goes2017; @garel2014], and isolating each contribution requires independent observational constraints. Grain-size distribution at the post-spinel reaction front [@kubo2000; @mao2021] could also generate viscosity contrasts that augments stagnation beyond what our rheological model captures. Our simple temperature-dependent rheological model omits grain-size evolution that affect both flow dynamics and reaction kinetics [@karato1984; @hirth2003; @yamazaki2005]. Finally, our 2D simulations neglect 3D slab geometry, trench migration, slab rollback, and lateral flow diversion. In 3D, a slab that retains its dip and is carried laterally away from the 660 by rollback could sustain faster descent than the vertically ponding slabs in our 2D domain, since less metastable material would accumulate locally beneath any one point on the slab. These 3D effects, alongside slab morphology and residence time more broadly, warrant further investigation [@sime2024; @garel2014]. Despite these limitations, our results capture the first-order kinetic effects governing 660 structure and slab dynamics across three distinct regimes.

## Contrasting Reaction Mechanisms at the 410 and 660 {#sec:contrasting-reaction-mechanisms-at-the-410-and-660}

The three kinetic regimes identified for the 660 differ qualitatively from those at the 410, reflecting the different reaction mechanisms that govern each transition (Equations -@eq:volume-fraction to -@eq:reaction-rate-660). At the 410, the interface-controlled driving-force term $(1 - \exp[-\Delta G / RT])$ saturates toward unity once $|\Delta G| \gg RT$ (@eq:reaction-rate-410). Beyond this saturation point, only the Arrhenius term $\exp[-(H^\ast + PV^\ast)/RT]$ controls reaction progress. In a cold, stagnated slab, this factor remains negligible until temperatures rise enough to activate transformation, at which point the reaction completes abruptly over a narrow depth interval, re-sharpening the 410. This threshold produced the three regimes (quasi-equilibrium, intermediate, and ultra-sluggish with re-sharpening) with distinct 410 seismic signatures [@kerswell2026a].

At the 660, the diffusion-controlled driving-force term $\Delta G \cdot |\Delta G|$ grows quadratically without bound as ringwoodite is carried below its stability field. Larger overstepping always drives larger (silicon) chemical potential gradients across the decomposition lamellae and thus faster transformation [@zener1946; @kubo2002]. No saturation ceiling exists, so the driving force never yields to the Arrhenius term alone. As a result, $\dot{X}_\mathrm{max}$ increases progressively with depth and the 660 widens and deepens continuously across all three regimes without triggering an abrupt transformation. The distinction between the intermediate and stagnation regimes at the 660 is therefore a matter of degree, marked by progressively longer $\tau$, larger $L$, slower descent, and broader, more deeply displaced discontinuities, rather than the abrupt threshold that separates the ultra-sluggish regime at the 410 (@fig:660-structure).

This difference in reaction mechanism also determines long-term slab behavior. Metastable olivine accumulated in the ultra-sluggish 410 regime eventually transforms in a rapid pulse that can disrupt transient stalling or ponding [@kerswell2026a]. Metastable ringwoodite in the 660 stagnation regime is consumed gradually ($\tau$ up to 26 Ma), sustaining persistent buoyancy that resists penetration over much longer timescales. Kinetically stagnated slabs at the 660 are therefore more stable than those at the 410, consistent with the long-lived sub-horizontal ponding observed in the western Pacific [@fukao2013; @tauzin2017].

Near equilibrium, the two reaction mechanisms also differ. The quadratic driving force at the 660 strongly suppresses reaction rates near the phase boundary because $\Delta G \cdot |\Delta G|$ approaches zero as $\Delta G^2$. The linear driving force term governing the 410 $(1 - \exp[-\Delta G / RT]) \approx \Delta G / RT$ suppresses reaction rates less strongly when $\Delta G$ approaches zero. This inherent near-equilibrium suppression broadens the 660 transition zone slightly relative to the 410, even under quasi-equilibrium conditions (cf. circle and triangle datapoints in @fig:660-structure).

## Kinetic Amplification of Temperature-Driven 660 Displacement {#sec:kinetic-amplification-of-temperature-driven-660-displacement}

Within the pure Mg, garnet-free system we model, equilibrium thermodynamics predicts downward 660 displacement from two principal sources: 1) the negative Clapeyron slope shifting the post-spinel reaction to higher pressure beneath cold slabs, and 2) the akimotoite $\Leftrightarrow$ bridgmanite transition generating additional depression of 30--90 km in the coldest slab interiors [@chanyshev2022; @cottaar2016]. Our quasi-equilibrium slab simulations recover this thermal signal (Figures -@fig:660-structure and -@fig:660-structure-comp), showing 22--36 km displacements consistent with Clapeyron-slope predictions for a -500 K anomaly [@flanagan1998; @bina1994]. Kinetics then amplify this baseline progressively (@fig:seismic-profiles), as the deepest stagnation regime displacements (up to 80 km) reach roughly 2 to 4 times the shallowest quasi-equilibrium displacement (22 km), depending on rheological and kinematic conditions (Table S1). Beyond these thermal and kinetic effects, two compositional factors outside our model could further modify the 660: 1) water in ringwoodite broadens the post-spinel reaction and raises its pressure [@ghosh2013; @muir2021], promoting additional deepening in cold slabs in contrast to water's shallowing effect at the 410 [@smyth1987; @smyth2002; @vandermeijde2003], while 2) basalt accumulation modifies reflectivity without systematically affecting depth [@yu2023; @goes2022].

The directional contrast between kinetic effects at the 410 and 660 in cold slabs is fundamental. At the 410, the positive Clapeyron slope produces upward displacement under quasi-equilibrium conditions. Decreasing reaction rates first broaden and deepen the discontinuity, then ultimately re-sharpen it at a depressed position, reversing its displacement sign relative to the equilibrium prediction (cf. circle and triangle datapoints in @fig:660-structure). At the 660, both the equilibrium prediction and all three kinetic regimes produce downward displacement (@fig:seismic-profiles). Kinetics amplify rather than reverse the equilibrium signal, and the transition from one regime to the next is monotonic. The 660 therefore lacks the seismically diagnostic sign-reversal that marks the onset of ultra-sluggish conditions at the 410.

Jointly observing both discontinuities in the same slab column exploits these different behaviors. A sharp, deeply displaced 410 paired with a broad, deeply displaced 660 points to ultra-sluggish olivine $\Leftrightarrow$ wadsleyite kinetics coexisting with intermediate to ultra-sluggish ringwoodite decomposition. A broad, deepened 410 paired with a broad, deepened 660 is consistent with intermediate kinetic inhibition at both transitions. A modestly displaced, narrow 410 paired with a modestly displaced, narrow 660 suggests quasi-equilibrium conditions across the full transition zone (@fig:seismic-profiles). These joint patterns exploit the different saturation behaviors of the interface-controlled and diffusion-controlled reaction mechanisms, though they only narrow (rather than eliminate) the ambiguity with thermal, compositional, and rheological contributions discussed below.

![Synthetic seismic velocity profiles extracted along representative depth profiles in plume (left) and slab (right) simulations across the full range of tested kinetic prefactors $Z_\mathrm{ri}$. The black line shows the background adiabatic reference profile. Colored bands show the envelope of profiles from slow (dark red, $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^{-3}$ mol$^2$ J$^{-2}$ s$^{-1}$) to fast (yellow, $Z_\mathrm{ri}$ = 1.6 $\times$ 10$^3$ mol$^2$ J$^{-2}$ s$^{-1}$) kinetics. In plumes, the 410 and 520 are depressed, and the 660 is uplifted by elevated temperatures ($+T$). The narrow colored band at the 660 indicates that its position is insensitive to $Z_\mathrm{ri}$. In slabs, the 410 and 520 are uplifted by cold temperatures ($-T$), but counter-shifted by sluggish kinetic conditions ($-Z_\mathrm{ol}$, $-Z_\mathrm{wd}$). The 660 is depressed by both cold temperatures and kinetic inhibition ($-T$, $-Z_\mathrm{ri}$), with the wider colored band reflecting stronger sensitivity to $Z_\mathrm{ri}$. Unlike the 410, temperature ($-T$) and kinetic ($Z_\mathrm{ri}$) effects displace the 660 in the same direction in cold environments.](../figs/seisimc_profiles/seismic-composition.png){#fig:seismic-profiles width=75%}

## Constraining Kinetics from Seismic Observations {#sec:constraining-kinetics-from-seismic-observations}

Seismic observations in several subduction zones show the 660 displaced over a broad area while 410 displacement is either more localized or undetected, possibly because narrow structures escape detection. Examples include subduction zones beneath South America [@ba2025], East Asia [@sun2020; @liu2022; @tang2023], and Europe [@cottaar2016; @kalmar2025]. These studies generally invoke water or the akimotoite $\Leftrightarrow$ bridgmanite transition to explain the pattern, but our results show kinetic inhibition offers an alternative explanation for at least part of the signature.

Beyond overall displacement, a handful of studies also constrain the width of the transition, offering an independent test of our kinetic-inhibition hypothesis. Prior work often attributes such broadening to the joint decomposition of ringwoodite and garnet, but our results show that kinetic effects alone can reproduce the observed widths. Inversion of receiver functions over a broad area beneath the US shows a velocity gradient over 25 km [@schmandt2012]. More locally, frequency-dependent receiver function observations constrain a 30--40 km wide 660 beneath Chile--Argentina [@bonatto2020], and triplications show a 50--70 km transition beneath Northeast China [@wang2010]; both locations are associated with subducted slabs. The Chile--Argentina width falls within the range predicted by kinetic effects in the stagnation regime (@fig:660-structure-comp; Table S1), and, following the trends discussed in @sec:structure-of-the-660, the 50--70 km transition beneath Northeast China is consistent with ultra-sluggish ringwoodite decomposition within a strong, quickly descending slab.

Beyond depth and width, the 660 also displays a structural complexity that generally exceeds the 410. The discontinuity can appear split [@deuss2006; @boyce2021] or difficult to resolve in long-period PP precursor data [@deuss2009; @lessing2015], and observed amplitude variations in precursors [@waszek2021; @yu2023] and high-frequency scattering [@day2013; @wu2019] point to compositional variations around the boundary. Some of this apparent complexity may itself be a kinetic signature. In higher-frequency data, such as receiver functions, a broad transition may resemble a split one. Determining how much kinetic effects contribute to these observations (versus genuine compositional variation) requires forward modeling of synthetic seismic data [e.g., @lessing2015].

Seismic observations alone, however, cannot fully separate kinetic effects from thermal, compositional, and rheological contributions. The boundaries between regimes shift systematically with $B$, inflow velocity, and the viscosity jump factor $b$, so the same 660 structure is consistent with many kinetic-rheological combinations. As previously stated, joint analysis of the 410 and 660 in the same slab column narrows, rather than eliminates, this ambiguity. However, two laboratory priorities would translate this framework into quantitative observational constraints. The first is high-pressure experiments that reduce uncertainties in ringwoodite decomposition kinetic parameters under cold slab conditions with small pressure oversteps. The second is explicit kinetic models for the reverse post-spinel reaction [e.g., @lessing2022].

## Slab Dynamics and the Diversity of Subduction Behavior {#sec:slab-dynamics-and-the-diversity-of-subduction-behavior}

Ringwoodite decomposition kinetics independently promote slab stagnation through buoyancy accumulation in the metastable ringwoodite zone, without requiring trench retreat or a prescribed lower-mantle viscosity jump. Slabs progress from continuous penetration in the quasi-equilibrium regime, through temporary stalling and flattening in the intermediate regime, to full ponding above the 660 in the stagnation regime (@fig:slab-composition-660-b01; @sec:structure-of-the-660). These results complement the equilibrium stagnation mechanisms identified by @garel2014, @agrusta2017, and @goes2017. Where those studies identify the Clapeyron slope, lower-mantle viscosity increase, and trench retreat as necessary joint conditions for stagnation, our results establish kinetic inhibition as an additional, independently variable impedance. A lower-mantle viscosity jump reinforces kinetic stagnation in our simulations (Figures S4--S7), confirming that kinetic and viscous impedances at the 660 are additive.

The diversity of slab behavior documented globally by @fukao2013 maps onto this three-regime framework. Stagnant western Pacific slabs with 660 depressions of 30--60 km [@jiang2015; @tauzin2017] are consistent with the intermediate regime at moderate $Z_\mathrm{ri}$, particularly where faster descent velocity through the 660 amplifies metastable accumulation. The deepest observed depressions exceeding 60 km require either stagnation regime kinetics, the akimotoite $\Leftrightarrow$ bridgmanite contribution [@chanyshev2022], or both acting together. Steeply penetrating slabs are consistent with the quasi-equilibrium regime. Slabs that deflect at the 660 before eventually sinking may record temporal evolution within the intermediate or stagnation regimes, where metastable ringwoodite is gradually consumed until buoyancy is lost and the slab resumes descent, consistent with @mao2018 who found that stagnation is transient on timescales of 20--30 Ma. A separate geodynamic modeling study of ringwoodite decomposition kinetics predicts slab residence times at the base of the transition zone of 150--160 Ma before buoyancy is lost and penetration resumes [@chapman2021], a timescale consistent with the persistent metastable zones in our stagnation regime and with the long-lived sub-horizontal ponding documented in the western Pacific [@fukao2013].

Descent rates offer a further point of comparison with nature, though a more demanding one given the inherent limitations of our phenomenological model. Descent rates through the 660 in the quasi-equilibrium regime fall somewhat below the natural interquartile range of 2.6--4.8 cm yr$^{-1}$ [@lallemand2005], a discrepancy also present in the 410 results of @kerswell2026a. Our model already includes slab pull, the dominant driving force in nature, but omits other controls on descent rate, including upper mantle viscosity structure, chemical buoyancy contrasts between basaltic and harzburgitic layers, volatile content, and 2D geometric simplifications that neglect trench retreat and lateral flow. Any of these factors could shift simulated rates closer to natural values. Because our simulations are designed to isolate and demonstrate kinetic effects rather than to reproduce the full boundary conditions of natural subduction, the absolute descent rates are not expected to match observations quantitatively. The qualitative correspondence with observed slab diversity discussed above is the more direct test of our kinetic-inhibition hypothesis. Incorporating the omitted physics would be needed to translate our results into quantitative natural descent rates, and represents a natural extension of this framework.

Despite all of these considerations, the clearest result of our simulations is that kinetic inhibition does not act in isolation, but jointly with rheology and kinematics to control subduction dynamics at the 660. Stronger slabs ($B$ = 10) descend faster through the 660 due to their structural coherence and produce smaller displacements in the quasi-equilibrium regime, where kinetics are fast enough to keep pace with the slab. In the intermediate and stagnation regimes, however, their faster descent through the 660 carries more material into the metastable zone, amplifying 660 depression relative to weaker slabs. Weaker slabs with faster descent rates through the 660 generally amplify metastability and shift both regime boundaries to higher $Z_\mathrm{ri}$ (@fig:660-structure-comp). Small changes in convergence rate or rheological strength near a regime boundary could therefore drive episodic transitions between penetrating and stagnant behavior at individual subduction zones over geological time [@agrusta2017; @kerswell2026a].

# Conclusions {#sec:conclusions}

We couple diffusion-controlled ringwoodite decomposition kinetics to compressible mantle flow simulations that also resolve the 410 and 520 transitions, varying the kinetic prefactor across six orders of magnitude alongside slab strength, mantle viscosity structure, and inflow velocity. Our simulations show that the different reaction mechanisms governing the 410 and 660 produce fundamentally different controls on discontinuity structure and slab dynamics across the MTZ.

Ringwoodite decomposition kinetics exert first-order control on slab dynamics at the 660, modulated by mantle viscosity structure, descent velocity, and slab strength. Slabs progress through three regimes as reaction rates slow. Near equilibrium, slabs descend continuously through the 660. As metastable ringwoodite accumulates, descent progressively slows and the 660 broadens and deepens. At the slowest reaction rates, slabs fully stagnate above the 660, descent rate drops by an order of magnitude, and 660 depression reaches two to four times the equilibrium prediction. This kinetic inhibition independently promotes slab stagnation, complementing and amplifying the established equilibrium mechanisms of the endothermic Clapeyron slope and lower-mantle viscosity jump. The resulting seismic signatures differ and become diagnostic. Quasi-equilibrium kinetics produce narrow, modestly depressed reflectors, while stagnation produces broad, deeply depressed reflectors with reduced amplitude, offering an alternative explanation for observations often attributed instead to akimotoite, garnet, or water.

The character of these regimes differs fundamentally from those at the 410. There, the interface-controlled driving force saturates at high overstepping, permitting abrupt re-sharpening once temperatures overcome the kinetic barrier. At the 660, the quadratic diffusion-controlled driving force grows continuously with overstepping, so displacement and width increase monotonically from quasi-equilibrium through stagnation with no re-sharpening at any tested condition. Kinetic stagnation at the 660 is therefore progressive and persistent rather than threshold-controlled, a distinction essential for correctly interpreting the diverse seismic signatures of the MTZ.

Realizing the observational potential of this framework requires progress on two fronts. High-pressure experiments targeting cold slab conditions, including small pressure oversteps, would reduce current uncertainties in activation energy and the kinetic prefactor, alongside dedicated kinetic models for the reverse post-spinel reaction. Frequency-dependent inversions that jointly constrain 660 topography and width in well-studied subduction zones would help discriminate kinetic from competing thermal and compositional explanations. Together with our companion study of the 410, these advances would extend seismological constraints to both the interface-controlled and diffusion-controlled kinetic regimes of the MTZ.

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
