Dear Dr. Behn,

Thank you for handling our manuscript #2026JB035526 and for the constructive evaluations from the Associate Editor and both reviewers. We are grateful to Reviewer #2 for recommending publication in present form and to Reviewer #1 for seven thoughtful suggestions that significantly strengthened the physical framing, observational comparisons, and clarity of the study.

Alongside addressing all of Reviewer #1's comments, we made two major improvements to the simulation dataset and analysis. We first summarize these major revisions and then provide a point-by-point response to the Associate Editor and both reviewers. Math symbols and section, figure, equation, and table numbers refer to the revised manuscript and Supplementary Information (SI).

\clearpage

# Overview of Major Revisions {.unnumbered}

## Addition of the *Nominal Kinetics / Cold Slabs* (NC) Suite {.unnumbered}

In our companion study [@kerswell2026\, *JGR: Solid Earth*, 10.1029/2026JB033781], the kinetic prefactors ($Z$) were inadvertently divided by a factor of 3.15e7 when passed to ASPECT (see the companion Erratum). That same scaling factor affected the original 64 slab simulations in this study. While the scaled $$Z_\mathrm{ri}$ still lie within the $\pm$ 2$\sigma$ experimental uncertainties of @kubo2002 (new Figure S4), our original simulations sampled more sluggish ringwoodite kinetics than we intended, representing ringwoodite decomposition in dry, coarse-grained rocks.

To test how the 660 behaves under nominal (unscaled) laboratory rates, we ran a second 64-simulation suite (*Nominal Kinetics / Cold Slabs*, NC; scenarios 8--15 in Table 1) analogous to classic studies of metastable olivine in very cold slabs [@rubie1994; @dassler1996; @riedel1997; @devaux1997; @hosoya2005], plus four sensitivity tests with sluggish 410 kinetics (scenarios 16--19, T1--T4; Table S1). This effectively expands the original parameter space to a larger range of kinetics and slab temperatures.

Comparing the original *Sluggish Kinetics / Warm Slabs* (SW) and added *Nominal Kinetics / Cold Slabs* (NC) suites reveals a key physical result that adds further insight without detracting from our former interpretations of slab behavior under SW suite conditions (Sections 3.1--3.3 and 4.2; Figures 3--6):

**In the SW suite**, sluggish kinetics allow buoyant metastable ringwoodite to accumulate, driving slabs monotonically through quasi-equilibrium, intermediate, and stagnation regimes as $Z_\mathrm{ri}$ decreases. Kinetic delay slows descent by up to an order of magnitude, broadens the 660 up to 34 km, and adds up to 64 km of downward kinetic displacement (80 km total). These results remain unchanged from the original manuscript.

**In the NC suite**, by contrast, 62 of the 64 simulations remain in the quasi-equilibrium regime across all six orders of magnitude in $Z_\mathrm{ri}$, even in very cold slabs. Because the diffusion-controlled driving force at the 660 is quadratic ($\propto$ $\Delta G^2$), large reaction overstepping in slab cores accelerates ringwoodite breakdown and compensates for the cold Arrhenius penalty.

We updated the title to *"Beyond Equilibrium II: Sluggish Ringwoodite Kinetics Amplify 660 km Discontinuity Depressions and Independently Promote Slab Stagnation"* and framed the manuscript around this conditional finding. While nominal ringwoodite kinetics ($Z_\mathrm{ri}$ best-fit to experimental data) hold the 660 near its equilibrium depth even in very cold slabs and imply mostly thermal and/or compositional effects depressing the 660, the most sluggish ringwoodite kinetics permitted by experimental uncertainty independently promote slab stagnation even in relatively warm slabs and amplify thermal 660 depressions by two to five times, reconciling 30--60 km depressions with modest Clapeyron slopes.

## Decomposition of 660 Displacement into Thermal-Kinetic Contributions {.unnumbered}

In the initial submission, we evaluated 660 structure using only its width ($\delta w$) and total displacement measured relative the nominal 660 ($\delta z$). However, because a negative Clapeyron slope and kinetic delay both shift the 660 downward in cold slabs, and because the SW and NC suites have different slab thermal anomalies (-500 K versus -1000 K), total displacement alone mixes contributions from equilibrium thermal depression and kinetic delay.

To separate these effects cleanly, we added an explicit decomposition of $\delta z$ into its thermal and kinetic contributions ($\delta z_t$ versus $\delta z_k$; Section 2.2.6, Equations 19--20; Table S1):

$$
\delta z_t = \frac{\gamma\, \hat{T}}{\rho\, g}, \qquad \delta z_k = \delta z - \delta z_t
$$

These are evaluated using the slab-core temperature $\hat{T}$ at the transition depth and the implicit pure-Mg Clapeyron slope ($\gamma_{660}$ = -1.869 MPa K$^{-1}$) from our material model. This decomposition substantially improves our analysis (Sections 3.2--3.3 and 4.3; Figures 5--6):

**It resolves the ambiguity in total displacement** by showing that the SW suite is dominated by kinetic delay atop a modest thermal baseline, whereas the NC suite is dominated by thermal depression with a flat quasi-equilibrium kinetic baseline.

**It quantifies kinetic amplification** by allowing us to directly measure how much excess kinetic delay adds to purely thermal displacement (Section 4.3).

---

# Response to Associate Editor {.unnumbered}

> *The manuscript has been evaluated by two reviewers. Reviewer #1 raises several important concerns regarding the modeling approach, reaction kinetics, underlying assumptions, and interpretation of the results. Reviewer #2 supports publication and recognizes the scientific significance of the study. In my assessment, the manuscript presents an interesting contribution to understanding the influence of ringwoodite decomposition kinetics on the 660-km discontinuity and slab stagnation. However, the concerns raised by Reviewer #1 require careful attention before the manuscript can be considered for publication. I therefore recommend major revision.*

We thank the Associate Editor for the careful assessment. We have thoroughly revised the manuscript, figures, and Supplementary Information to address all seven points raised by Reviewer #1, integrated the new NC simulation suite and the thermal-kinetic contribution analysis, and updated the manuscript title and key points accordingly. Beyond these technical revisions, the manuscript went through an internal review that improved the presentation of its major impacts and brought them to the surface, mostly targeting the Title, Key Points, Plain Language Summary, and Conclusions sections.

---

# Response to Reviewer #2 {.unnumbered}

> *Although the modelling in this manuscript could be refined in several respects, it nevertheless represents an important contribution to the field and merits prompt publication. The manuscript is generally written with great care, and I thoroughly enjoyed reading it. I therefore recommend its publication in its present form in the Journal of Geophysical Research: Solid Earth.*

We thank Reviewer #2 for the positive assessment and support of our work.

\clearpage

# Response to Reviewer #1 {.unnumbered}

We thank Reviewer #1 for the constructive and insightful review. Below we address each of the seven points in detail.

---

## Point 1: Reconsidering the Clapeyron Slope {.unnumbered}

> *While you mention that experimentally determined Clapeyron slopes for the post-spinel reaction range from -1 to -3 MPa K$^{-1}$, we note that the majority of recent studies, including @katsura2003, @fei2004, @litasov2005, @ghosh2013, @kojitani2016, @ishii2018, and @chanyshev2022, report notably shallower slopes between -0.4 and -1 MPa K$^{-1}$. Although @ishii2019 did report -3 MPa K$^{-1}$ for harzburgite, these same authors reported -1 MPa K$^{-1}$ for pyrolite in @ishii2018. We would encourage you to build the overall discussion throughout this paper around these shallower slopes.*

We agree and have reframed the Abstract, Introduction, Discussion (Sections 4.3--4.4), and Conclusions around the shallower experimental Clapeyron slopes of -0.4 to -1.3 MPa K$^{-1}$, while distinguishing steeper values (-2 to -3 MPa K$^{-1}$) obtained from earlier calibrations [@ito1989; @bina1994] or hydrous compositions [@ghosh2013].

In Section 4.3, we also explicitly evaluate the Clapeyron slopes implicitly embedded in our pure-Mg thermodynamic tables ($\gamma$ = $\Delta \bar{S}/\Delta \bar{V}$ at $\Delta \bar{G}$ = 0; Figure S2), which give $\gamma_{660}$ = -1.87 MPa K$^{-1}$ (shallowing to -1.60 MPa K$^{-1}$ across the 0--80 km depression range). Because -1.87 MPa K$^{-1}$ is about 1.4 to 4.7 times steeper than the -0.4 to -1.3 MPa K$^{-1}$ estimates, our simulated thermal contributions ($\delta z_t$ = 11--21 km in SW and 17--39 km in NC) represent conservative upper bounds. The same slab thermal anomalies would produce only $\sim$ 2--15 km (SW) or $\sim$ 4--27 km (NC) of equilibrium depression under shallower slopes. This strengthens the central argument that sluggish kinetic amplification ($\delta z_k$ up to 64 km) provides a direct physical mechanism to reconcile observed 30--60 km depressions with modest Clapeyron slopes.

---

## Point 2: Strengthening the Theoretical Basis of Equation (12) {.unnumbered}

> *Equation (12) is central to your analysis, and we appreciate that you cite @burke1965 and @zener1946 to justify it. However, given that these foundational works are 60-80 years old and not readily accessible, we would like to suggest citing more recent literature to support this crucial equation. While @kubo2002 do provide detailed explanation, their treatment ultimately relies on the same historical sources. This might strengthen the theoretical foundation of your work.*

We have expanded Section 2.2.3.2 (leading into Equation 13) to explain the physical basis of the $\Delta G^2$ growth law in plain terms and to cite accessible modern metallurgy textbooks and mineral-physics studies [@hillert1957; @hillert1969; @yamazaki2005; @christian2007; @porter2009; @dobson2014] alongside the foundational literature.

---

## Point 3: Accounting for Different Reaction Kinetics in Plumes vs. Slabs {.unnumbered}

> *You correctly note in Section 4.1 that the kinetics of the ringwoodite-to-perovskite+periclase reaction differ from the reverse reaction. Given this important distinction, the current arguments regarding plumes might benefit from reconsideration. We would suggest either: (1) rebuilding the plume-related arguments using @dobson2014 and @lessing2022, which specifically address upwelling scenarios, or (2) focusing the discussion primarily on slabs and setting aside the plume analysis for future work.*

We adopted option (2) and removed all plume simulations, figures, and tables from the main text and Supplementary Information so the paper focuses entirely on forward ringwoodite decomposition in subducting slabs. No plume figures or tables are retained in the revised manuscript or Supplementary Information. This is made clear in the Introduction and in Section 4.1 (Uncertainties and Model Limitations), where we cite @dobson2014 and @lessing2022 to explain that the reverse reaction in upwelling mantle proceeds via a distinct physical mechanism. We leave upwelling plumes to future work incorporating dedicated reverse-reaction kinetics.

---

## Point 4: Addressing Regional Variation in Observations {.unnumbered}

> *The seismological literature on 660-km discontinuity topography is substantial, encompassing perhaps more than 20 global-scale studies and upwards of 200 regional investigations. We would welcome a more detailed and quantitative discussion of which regions' topography can be reasonably explained by your model and which may not, perhaps even presented in a table or map format.*

We expanded Section 4.4 (Constraining Kinetics from Seismic Observations) and added a synthesis table (Table 2) that maps eight representative subduction zones (Kuril--Japan--Izu--Bonin, Northeast China, Mariana, Tonga--Kermadec, Central America, Chile--Argentina, Western US, and the Mediterranean) onto our thermal-kinetic interpretation. We compare observed slab morphology, 660 depression, and 660 gradient width against our simulation results ($\delta z$ up to 80 km, $\delta z_k$ up to 64 km, and $\delta w$ up to 34 km), which suggests a few interpretations:

**Penetrating slabs with modest, narrow 660 depressions**, such as Mariana, Central America, and the sharp 660 beneath the western US, are explained by quasi-equilibrium thermal shifts (NC or fast SW).

**Stagnant or flattening slabs with 20--60 km depressions and 30--40 km transition widths**, such as Chile--Argentina, Kuril--Japan--Izu--Bonin, and parts of Europe/Mediterranean, are explained by intermediate to stagnation-regime kinetics (SW suite).

**Signals wider than 34 km**, such as the 50--70 km wide 660 beneath Northeast China, and double-step depressions reaching $\sim$ 740 km beneath Tonga--Kermadec, exceed our kinetic limits and point to sluggish kinetics acting alongside garnet dissolution or the akimotoite $\Leftrightarrow$ bridgmanite transition.

\clearpage

## Point 5: Exploring the Physical Range of $Z_\mathrm{ri}$ Variations {.unnumbered}

> *@fukao2013 documented an intriguing pattern: some slabs (e.g., Honshu, Bonin, Chile) stagnate above the 660-km discontinuity, while others (e.g., Mariana, Kermadec, Central America) do not. Your model appears to explain this variation through changes in $Z_\mathrm{ri}$ spanning six orders of magnitude. We would find it helpful if you could provide more physical insight into what mechanisms might drive such extreme variations in $Z_\mathrm{ri}$ and whether there are observable geodynamic or compositional factors that correlate with this range.*

We addressed this in both the Methods (Section 2.2.3.2), the Supplementary Information (new Figure S4), and the Discussion (Section 4.1):

**Quantifying the experimental uncertainty envelope.** In Section 2.2.3.2 and Figure S4, we propagate the $\pm$ 2$\sigma$ uncertainty from our Monte Carlo regression of the @kubo2002 dataset ($\ln K^{\prime}$ = -29.8 $\pm$ 22.1, $E^{\ast}$ = 310 $\pm$ 233 kJ mol$^{-1}$) across mantle grain sizes of $d$ = 1--10 mm, yielding a 95% confidence interval of $Z_\mathrm{ri}$ $\in$ [1.7e-11, 2.6e9] mol$^2$ J$^{-2}$ s$^{-1}$. Only 5 data points constrain these regressed parameters, and both six-order-of-magnitude simulation suites (SW and NC) sit entirely within this large uncertainty envelope.

**Distinguishing experimental error from natural variability.** In Section 4.1, we distinguish systematic laboratory error (uncertainties in pressure, temperature, and transformation progress at multi-anvil conditions) from random natural variability between subduction zones. We highlight physical mechanisms (grain size reduction, water content, and bulk Fe-Mg chemistry) that can shift effective $Z_\mathrm{ri}$ by orders of magnitude from one slab to another and correlate with subduction history, motivating new kinetic experiments that reduce laboratory uncertainties and quantify these natural variations.

---

## Point 6: Clarifying the "Three Kinetic Regimes" {.unnumbered}

> *In the opening paragraph of Section 3.2, you identify three kinetic regimes evident in Figures 5 and 6. However, we must admit that these three distinct regimes are not immediately obvious to us from the figures themselves, and the white lines demarcating boundaries in Figure 6 appear somewhat subjective. Would it be possible to make these three regimes more explicit-perhaps with clearer labeling, quantitative thresholds, or additional annotation-so that readers can more readily identify and understand them?*

Thank you for this helpful criticism. We completely redesigned Figures 5 and 6 and clarified the regime definitions in Sections 2.2.6, 3.2, 3.3, and 4.2:

**Explicit quantitative regime diagram (new Figure 5, left panel).** We retired the subjective white contour lines from the old tile plot. Instead, the left panel of Figure 5 plots maximum descent velocity through the 660 ($\vec{v}_\mathrm{max}$) against the characteristic reaction completion length scale ($L$; Equation 18) for all 128 baseline simulations, with explicit dashed threshold lines at $L$ = 5 km and $\vec{v}_\mathrm{max}$ = 0.5 cm yr$^{-1}$ and clearly labeled regime regions. The regime of every simulation is also tabulated in Table S1.

**Line plots replacing the old tile plot (new Figure 6).** We replaced the old tile plot with a figure that shows $\vec{v}_\mathrm{max}$, $\delta z_k$, $\delta z_t$, and $\delta w$ against $Z_\mathrm{ri}$ for each kinematic and rheological scenario. While the interactions among these variables is still challenging to untangle, the line plot explicitly visualizes the major trends outlined in the text.

**Why 660 regimes are progressive rather than abrupt.** In Sections 3.2 and 4.2, we emphasize that unlike the 410---where saturation of the interface-controlled driving force creates a sharp re-sharpening threshold---the unbounded quadratic driving force at the 660 causes $\delta z_k$ and $\delta w$ to change continuously and monotonically across the three regimes. The regimes at the 660 represent progressive dynamic stages rather than discontinuous jumps.

---

## Point 7: Stagnation Between 660 and 1000 km Depth {.unnumbered}

> *Could the authors expand slightly on how the model accounts for slabs that appear to stagnate in the mid-mantle between 660 and 1000 km depths (e.g., Mariana, Kermadec, Central America)?*

We expanded Section 4.5 (Slab Dynamics and the Diversity of Subduction Behavior) to discuss how our simulations account for slabs that flatten or stall in the uppermost lower mantle between 660 and 1000 km depth through two complementary mechanisms:

**Deep kinetic overshoot in strong, fast slabs.** In strong, rapidly subducting SW slabs under sluggish kinetics (scenarios 3 and 7; Figures S10--S11, top panel), high structural coherence resists buckling at the nominal 660 and advects buoyant metastable ringwoodite down to $\sim$ 740 km depth ($\delta z$ = 80 km) before the slab decelerates in the uppermost lower mantle.

**Gradual loss of metastable buoyancy followed by viscous folding.** Because metastable ringwoodite decomposes gradually over characteristic timescales of $\tau$ $\sim$ 5--26 Ma (Equation 17) rather than in an abrupt pulse, slabs that initially stall near the base of the MTZ slowly lose their positive buoyancy over 20--160 Ma and sink into the uppermost lower mantle, where a 10--100$\times$ viscosity increase (scenarios 0--3 and 8--11; Figures S6--S7, S10--S11, S13--S14, and S17--S18) may fold and stall the slab between 660 and 1000 km depth.

\clearpage

# References {.unnumbered #sec:references}

::: {#refs}
:::
