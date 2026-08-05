# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

# Dependencies
KERSWELL_410_DATA := $(SIMULATION)/data/structure-summary-kerswell-et-al-2026.csv
PERPLEX_MODELS    := $(shell find $(PERPLEX) -type f -name '*.dat' -exec basename {} .dat \;)

# Cleanup
CLEAN      :=
DEEP_CLEAN := $(FIGS)/kubo

# Targets
.PHONY: all visualize tables adiabat simulation download upload clean deep-clean help

all: visualize
visualize: adiabat simulation seismic

tables:
	@Rscript $(R)/tables.R $(R)/utils $(SIMULATION)/data/structure-summary-combined-filtered.csv $(SIMULATION)/data

adiabat:
	@for model in $(PERPLEX_MODELS); do Rscript $(R)/adiabat.R $(R)/utils $$model $(SIMULATION)/data $(FIGS)/adiabat; done

seismic: $(SEISMIC_PROFILES)
	@Rscript $(R)/seismic.R $(R)/utils $(SIMULATION)/data/seismic_profiles $(FIGS)/seisimc_profiles

simulation: $(KERSWELL_410_DATA)
	@Rscript $(R)/simulation.R $(R)/utils $(SIMULATION)/data $(FIGS)/structure $(COMBINED_CSV_RAW) $(COMBINED_CSV_FILTERED) $(SAVE_CSV) $(FORCE_REWRITE)

download:
	@Rscript $(R)/osf.R $(R)/utils $(ASPECT_RESULTS) $(SIMULATION)/data "download"

upload:
	@Rscript $(R)/osf.R $(R)/utils $(ASPECT_RESULTS) $(SIMULATION)/data "upload"

$(KERSWELL_410_DATA):
	@Rscript $(R)/download.R $(R)/utils $(SIMULATION)/data

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

deep-clean:
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

help:
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    visualize   Visualize all results"
	@echo "    adiabat     Visualize adiabatic profiles"
	@echo "    simulation  Visualize simulation results"
	@echo "    download    Download ASPECT results from OSF"
	@echo "    upload      Upload ASPECT results to OSF"
	@echo "    clean       Remove generated files (safe)"
	@echo "    deep-clean  Remove results and data (use with caution!)"
