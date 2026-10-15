# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

# Dependencies
KERSWELL_410_DATA := $(SIMULATION)/data/structure-summary-kerswell-et-al-2026.csv
PERPLEX_MODELS    := $(shell find $(PERPLEX) -type f -name '*.dat' -exec basename {} .dat \;)

# Cleanup
CLEAN      :=
DEEP_CLEAN := $(FIGS)/kubo

# Targets
.PHONY: all visualize tables tables-warm tables-cold adiabat simulation simulation-warm simulation-cold seismic seismic-warm seismic-cold download upload clean deep-clean help

all: visualize
visualize: adiabat simulation seismic

tables: tables-warm tables-cold

tables-warm:
	@Rscript $(R)/tables.R $(R)/utils $(COMBINED_CSV_FILTERED_WARM) $(DATA_WARM)

tables-cold:
	@Rscript $(R)/tables.R $(R)/utils $(COMBINED_CSV_FILTERED_COLD) $(DATA_COLD)

adiabat:
	@for model in $(PERPLEX_MODELS); do Rscript $(R)/adiabat.R $(R)/utils $$model $(SIMULATION)/data $(FIGS)/adiabat; done

seismic: seismic-warm seismic-cold

seismic-warm: $(DATA_WARM)/seismic_profiles
	@Rscript $(R)/seismic.R $(R)/utils $(DATA_WARM)/seismic_profiles $(FIGS_SEISMIC_WARM)

seismic-cold: $(DATA_COLD)/seismic_profiles
	@Rscript $(R)/seismic.R $(R)/utils $(DATA_COLD)/seismic_profiles $(FIGS_SEISMIC_COLD)

simulation: simulation-warm simulation-cold

simulation-warm: $(KERSWELL_410_DATA)
	@Rscript $(R)/simulation.R $(R)/utils $(DATA_WARM) $(FIGS_STRUCT_WARM) $(COMBINED_CSV_RAW_WARM) $(COMBINED_CSV_FILTERED_WARM) $(SAVE_CSV) $(FORCE_REWRITE)

simulation-cold: $(KERSWELL_410_DATA)
	@Rscript $(R)/simulation.R $(R)/utils $(DATA_COLD) $(FIGS_STRUCT_COLD) $(COMBINED_CSV_RAW_COLD) $(COMBINED_CSV_FILTERED_COLD) $(SAVE_CSV) $(FORCE_REWRITE)

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
	@echo "    simulation  Visualize simulation results (warm + cold)"
	@echo "    seismic     Visualize seismic profiles (warm + cold)"
	@echo "    tables      Write result tables (warm + cold)"
	@echo "    download    Download ASPECT results from OSF"
	@echo "    upload      Upload ASPECT results to OSF"
	@echo "    clean       Remove generated files (safe)"
	@echo "    deep-clean  Remove results and data (use with caution!)"
