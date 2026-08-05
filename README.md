![](draft/repo-banner.png)

***Figure:*** *Reference slab simulations with moderate inflow velocity, intermediate slab strength, and no lower-mantle viscosity jump. Rows show stagnation (top row: $`Z_\mathrm{ri}`$ = 1.6 $`\times`$ 10$`^{-3}`$ mol$`^2`$ J$`^{-2}`$ s$`^{-1}`$), intermediate (middle row: $`Z_\mathrm{ri}`$ = 6.0 $`\times`$ 10$`^{-1}`$ mol$`^2`$ J$`^{-2}`$ s$`^{-1}`$), and quasi-equilibrium (bottom row: $`Z_\mathrm{ri}`$ = 1.6 $`\times`$ 10$`^{3}`$ mol$`^2`$ J$`^{-2}`$ s$`^{-1}`$) kinetic regimes after 100 Ma. Columns show dynamic temperature $`\hat{T}`$ (left column), dynamic density $`\hat{\rho}`$ (middle column), and vertical velocity $`\vec{u}_y`$ (right column). Thick black lines (left column) highlight the 10% and 90% wadsleyite and post-spinel volume fraction contours used to define 660 displacement and width. The background grid pattern indicates ASPECT's adaptive mesh refinement near high thermal gradients and phase transitions. White trace (left column) indicates the representative depth profile used to extract data, and the white arrows indicate where the 660 structure is evaluated.*

# Kerswell et al. (2026b; submitted)

## Repository

This repository provides all materials for the manuscript *Beyond Equilibrium II: Ringwoodite Decomposition Kinetics Amplify 660 km Discontinuity Depressions and Offer an Independent Control on Slab Stagnation* (Kerswell et al., 2026b; submitted), including all datasets required to compile the study and scripts to reproduce all results and figures.

## Prerequisite software

### Python

I recommend installing the [miniforge](https://github.com/conda-forge/miniforge) python distribution. This includes a minimal installation of python (plus some dependencies) and the package manager [conda](https://docs.conda.io/en/latest/), which is required to build the necessary python environment for this study.

### R

R is a programming language used to visualize the results in this study. R can be downloaded from the [R Project homepage](https://www.r-project.org). Follow their instructions to install R on your machine.

### Pandoc

Pandoc is a universal document converter used to build a PDF version of the manuscript, which written in Markdown. Pandoc can be downloaded from the [Pandoc homepage](https://pandoc.org). Follow their instructions to install Pandoc on your machine.

## Reproducing the study

The full set of ASPECT solution files and 660 structural measurement dataset can be downloaded from the [Open Science Framework repository](https://osf.io/kur93/files). The following steps will download all necessary data, reproduce the results and figures, and build a pdf version of the manuscript:

```bash
# Clone this repository
git clone https://github.com/buchanankerswell/kerswell_et_al_660_kinetics.git

# Change into the directory
cd kerswell_et_al_660_kinetics

# Get data and reproduce figures
make build
```

## Coauthors

- [John Wheeler](https://scholar.google.com/citations?user=jsfp2-8AAAAJ&hl=en&oi=ao) (Department of Earth, Oceans and Ecological Sciences, University of Liverpool)
- [Rene Gassmöller](https://scholar.google.com/citations?user=Vk8SmssAAAAJ&hl=en&oi=ao) (GEOMAR Helmholtz Centre for Ocean Research Kiel)
- [J. Huw Davies](https://scholar.google.com/citations?user=T5ygdwcAAAAJ&hl=en&oi=ao) (School of Earth and Environmental Sciences, Cardiff University)
- Isabel Papanagnou (Bullard Laboratories, Department of Earth Sciences, University of Cambridge)
- [Sanne Cottaar](https://scholar.google.com/citations?user=l5JtmzkAAAAJ&hl=en&oi=ao) (Bullard Laboratories, Department of Earth Sciences, University of Cambridge)
- [David Dobson](https://scholar.google.com/citations?user=kAkS0tcAAAAJ&hl=en&oi=ao) (Department of Earth Sciences, University College London)

## Acknowledgement

This work was funded by the UKRI NERC Large Grant no. NE/V018477/1. All computations were undertaken on Barkla2, part of the High Performance Computing facilities at the University of Liverpool, who graciously provided expert support. We thank the Computational Infrastructure for Geodynamics ([https://geodynamics.org](https://geodynamics.org)) which is funded by the National Science Foundation under awards EAR-0949446 and EAR-1550901 for supporting the development of ASPECT.

## Data Availability

All data, code, and relevant information for reproducing this work are archived on the OSF ([Kerswell, 2026a](https://doi.org/10.17605/OSF.IO/KUR93)) and Zenodo ([Kerswell, 2026b](https://doi.org/xx.xxxx/zenodo.xxxxxxxx)) repositories. All code within these repositories is MIT Licensed and free for use and distribution (see license details). ASPECT version 3.0.0 ([Bangerth et al., 2024](https://doi.org/10.5281/zenodo.14371679)) was used for the computations in this study and is freely available under the GPL v2.0 or later license.

## Abstract

The 660 km seismic discontinuity ('660') varies beneath subduction zones, ranging from modest depressions consistent with equilibrium thermodynamics to anomalously deep, broad transitions challenging purely thermal interpretations. Laboratory experiments establish that the ringwoodite decomposition responsible for the 660 proceeds via diffusion-controlled kinetics, yet their quantitative effects on 660 structure and slab dynamics have not been evaluated in compressible mantle flow simulations. We couple ringwoodite decomposition kinetics to simulations of mantle plumes and subducting slabs, varying kinetic parameters across six orders of magnitude. Results reveal a fundamental asymmetry between hot and cold environments. In plumes, elevated temperatures produce uplifted, narrow 660s that are relatively insensitive to kinetics due to rapid reaction rates. In slabs, kinetics exert strong control through three regimes: 1) a quasi-equilibrium regime producing 660s consistent with Clapeyron-slope predictions; 2) an intermediate regime where metastable ringwoodite accumulates within a broadening buoyant zone, slowing slab descent; and 3) a stagnation regime where slabs pond above the 660, producing the deepest, broadest 660s and slowest descent velocities. The endothermic Clapeyron slope and kinetic inhibition reinforce each other, amplifying temperature-driven 660 deflection by a factor of 2--4 while independently promoting slab stagnation. Slabs smoothly transition through each regime as reaction rates slow, without abrupt reactions at overstepped metastable conditions. These findings establish ringwoodite kinetics as a first-order control on slab stagnation dynamics and 660 seismic structure under Earth-like conditions, explaining the diverse slab behaviors observed at the base of the mantle transition zone.

# License

MIT License

Copyright (c) 2026 Buchanan Kerswell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
