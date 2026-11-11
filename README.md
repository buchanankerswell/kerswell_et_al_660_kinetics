![](draft/repo-banner.png)

***Figure:*** *Reference slab simulations with moderate inflow velocity, intermediate slab strength, and no lower-mantle viscosity jump. Rows show stagnation (top row: $`Z_\mathrm{ri}`$ = 1.6 $`\times`$ 10$`^{-3}`$ mol$`^2`$ J$`^{-2}`$ s$`^{-1}`$), intermediate (middle row: $`Z_\mathrm{ri}`$ = 6.0 $`\times`$ 10$`^{-1}`$ mol$`^2`$ J$`^{-2}`$ s$`^{-1}`$), and quasi-equilibrium (bottom row: $`Z_\mathrm{ri}`$ = 1.6 $`\times`$ 10$`^{3}`$ mol$`^2`$ J$`^{-2}`$ s$`^{-1}`$) kinetic regimes after 100 Ma. Columns show dynamic temperature $`\hat{T}`$ (left column), dynamic density $`\hat{\rho}`$ (middle column), and vertical velocity $`\vec{u}_y`$ (right column). Thick black lines (left column) highlight the 10% and 90% wadsleyite and post-spinel volume fraction contours used to define 660 displacement and width. The background grid pattern indicates ASPECT's adaptive mesh refinement near high thermal gradients and phase transitions. White trace (left column) indicates the representative depth profile used to extract data, and the white arrows indicate where the 660 structure is evaluated.*

# Kerswell et al. (2027; in review)

## Repository

This repository provides all materials for the manuscript *Beyond Equilibrium II: Sluggish Ringwoodite Kinetics Amplify 660 km Discontinuity Depressions and Independently Promote Slab Stagnation* (Kerswell et al., 2027; in review), including all datasets required to compile the study and scripts to reproduce all results and figures.

## Prerequisite software

### Python

I recommend installing the [miniforge](https://github.com/conda-forge/miniforge) python distribution. This includes a minimal installation of python (plus some dependencies) and the package manager [conda](https://docs.conda.io/en/latest/), which is required to build the necessary python environment for this study.

### R

R is a programming language used to visualize the results in this study. R can be downloaded from the [R Project homepage](https://www.r-project.org). Follow their instructions to install R on your machine.

### Pandoc

Pandoc is a universal document converter used to build a PDF version of the manuscript, which written in Markdown. Pandoc can be downloaded from the [Pandoc homepage](https://pandoc.org). Follow their instructions to install Pandoc on your machine.

## Reproducing the study

`make build` fetches the archived datasets, reproduces all results and figures, and builds a pdf version of the manuscript. It does not run simulations:

```bash
# Clone this repository
git clone https://github.com/buchanankerswell/kerswell_et_al_660_kinetics.git

# Change into the directory
cd kerswell_et_al_660_kinetics

# Get data and reproduce figures
make build
```

The full set of ASPECT solution files and 660 structural measurement dataset are downloaded from the [Zenodo dataset record](https://doi.org/10.5281/zenodo.24120946) during the build.

To run the simulations from scratch instead, link your installs at the project root as `<aspect_install_dir> -> aspect/` and `<dealii_install_dir> -> dealii/` (needed only for this step), then run `make models`. See [candi](https://github.com/dealii/candi) (deal.II >= v9.7.0) and [ASPECT](https://github.com/geodynamics/aspect) (ASPECT >= 3.1.0) for installation instructions.

## Coauthors

- [John Wheeler](https://scholar.google.com/citations?user=jsfp2-8AAAAJ&hl=en&oi=ao) (Department of Earth, Oceans and Ecological Sciences, University of Liverpool)
- [Rene Gassmöller](https://scholar.google.com/citations?user=Vk8SmssAAAAJ&hl=en&oi=ao) (GEOMAR Helmholtz Centre for Ocean Research Kiel)
- [J. Huw Davies](https://scholar.google.com/citations?user=T5ygdwcAAAAJ&hl=en&oi=ao) (School of Earth and Environmental Sciences, Cardiff University)
- Isabel Papanagnou (Bullard Laboratories, Department of Earth Sciences, University of Cambridge)
- [Sanne Cottaar](https://scholar.google.com/citations?user=l5JtmzkAAAAJ&hl=en&oi=ao) (Bullard Laboratories, Department of Earth Sciences, University of Cambridge)
- [David Dobson](https://scholar.google.com/citations?user=kAkS0tcAAAAJ&hl=en&oi=ao) (Department of Earth Sciences, University College London)

## Acknowledgement

This work was funded by the UKRI NERC Large Grant no. NE/V018477/1. All computations were undertaken on Barkla2, part of the High Performance Computing facilities at the University of Liverpool, who graciously provided expert support. We thank the Computational Infrastructure for Geodynamics ([https://geodynamics.org](https://geodynamics.org)) which is funded by the National Science Foundation under awards EAR-0949446 and EAR-1550901 for supporting the development of ASPECT. We thank two anonymous reviewers for their feedback, which greatly improved this work, and the JGR:SE editorial staff for handling the manuscript.

## Data Availability

All simulation outputs and post-processed data for reproducing this work are archived on Zenodo ([Kerswell, 2027](https://doi.org/10.5281/zenodo.24120946)), as well as all analysis code ([Kerswell, 2027b](https://doi.org/10.5281/zenodo.21810740)). All data and code within these repositories are MIT Licensed and free for use and distribution (see license details). ASPECT version 3.1.0 ([Bangerth et al., 2024](https://doi.org/10.5281/zenodo.22814863)) was used for the computations in this study and is freely available under the GPL v2.0 or later license.

## Abstract

The 660 km seismic discontinuity ('660') beneath some subduction zones exhibits 30--60 km deep, broad transitions far exceeding the $`\sim`$ 3--16 km displacements predicted by cold slab temperatures and experimentally-determined Clapeyron slopes (-0.4 to -1.3 MPa K$`^{-1}`$). Recent studies emphasize compositional or hydration effects, leaving the impact of diffusion-controlled ringwoodite decomposition kinetics unexplored. Here we couple experimentally calibrated olivine $`\Leftrightarrow`$ wadsleyite $`\Leftrightarrow`$ ringwoodite $`\Leftrightarrow`$ post-spinel kinetics to 2D compressible subduction simulations, varying the ringwoodite $`\Leftrightarrow`$ post-spinel kinetic prefactor $`Z_\mathrm{ri}`$ alongside slab temperature, strength, inflow velocity, and lower-mantle viscosity jump. Under the most sluggish kinetics permitted by experimental uncertainty, delayed ringwoodite decomposition amplifies thermal displacements of the 660 by 2--5 times and independently promotes slab stagnation, even in warm slabs. As reaction rates decrease, buoyant metastable ringwoodite drives slabs from penetration to stagnation, slowing descent up to tenfold, broadening the 660 to 34 km, and adding up to 64 km of kinetic displacement (80 km total). Kinetic stagnation at the 660 is progressive and persistent, a behavior essential for interpreting transition-zone seismic signatures and slab morphologies. Under nominal ringwoodite kinetics ($`Z_\mathrm{ri}`$ best-fit to experimental data), rapid ringwoodite decomposition holds the 660 near its equilibrium depth (6--12 km kinetic displacement), even in cold slabs. While nominal ringwoodite kinetics imply mostly thermal and/or compositional effects displacing the 660, sluggish ringwoodite kinetics reconcile 30--60 km depressions with modest Clapeyron slopes, motivating new experiments to address large laboratory uncertainties and natural variations in grain-size, water, and Fe-Mg content in slabs.
