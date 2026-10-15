# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

# Dependencies
KERSWELL_410_DATA := $(SIMULATION)/data/structure-summary-kerswell-et-al-2026.csv
PERPLEX_MODELS    := $(shell find $(PERPLEX) -type f -name '*.dat' -exec basename {} .dat \;)

# Cleanup: clean removes regenerable products (figures); suite data dirs are
# owned by the python mesh pipeline. deep-clean has nothing to add here.
CLEAN      := $(FIGS)/kubo $(FIGS_STRUCT_WARM) $(FIGS_STRUCT_COLD) $(FIGS_SEISMIC_WARM) $(FIGS_SEISMIC_COLD)
DEEP_CLEAN :=

# Targets
.PHONY: all visualize tables tables-warm tables-cold adiabat simulation simulation-warm simulation-cold seismic seismic-warm seismic-cold download upload clean deep-clean help

all: visualize
visualize: adiabat simulation seismic

tables: tables-warm tables-cold

tables-warm: SUITE := WARM
tables-cold: SUITE := COLD
tables-warm tables-cold:
	@Rscript $(R)/tables.R $(R)/utils $(COMBINED_CSV_FILTERED_$(SUITE)) $(DATA_$(SUITE))

adiabat:
	@for model in $(PERPLEX_MODELS); do Rscript $(R)/adiabat.R $(R)/utils $$model $(SIMULATION)/data $(FIGS)/adiabat; done

seismic: seismic-warm seismic-cold

# Mesh outputs owned by the python pipeline; building them on demand
# fixes `make clean && make visualize` (R previously ran before meshes).
MESH_CSV_WARM := $(DATA_WARM)/structure-summary-local.csv
MESH_CSV_COLD := $(DATA_COLD)/structure-summary-local.csv
$(MESH_CSV_WARM):
	@$(MAKE) --no-print-directory -C $(PYTHON) meshes-warm
$(MESH_CSV_COLD):
	@$(MAKE) --no-print-directory -C $(PYTHON) meshes-cold

seismic-warm: SUITE := WARM
seismic-cold: SUITE := COLD
seismic-warm: $(MESH_CSV_WARM)
seismic-cold: $(MESH_CSV_COLD)
seismic-warm seismic-cold:
	@Rscript $(R)/seismic.R $(R)/utils $(DATA_$(SUITE))/seismic_profiles $(FIGS_SEISMIC_$(SUITE))

simulation: simulation-warm simulation-cold

LINK_WARM := $(DATA_WARM)/structure-summary-kerswell-et-al-2026.csv
LINK_COLD := $(DATA_COLD)/structure-summary-kerswell-et-al-2026.csv
$(LINK_WARM) $(LINK_COLD): $(KERSWELL_410_DATA)
	@mkdir -p $(dir $@) && ln -sf ../$(notdir $(KERSWELL_410_DATA)) $@

simulation-warm: SUITE := WARM
simulation-cold: SUITE := COLD
simulation-warm: $(KERSWELL_410_DATA) $(LINK_WARM) $(MESH_CSV_WARM)
simulation-cold: $(KERSWELL_410_DATA) $(LINK_COLD) $(MESH_CSV_COLD)
simulation-warm simulation-cold:
	@Rscript $(R)/simulation.R $(R)/utils $(DATA_$(SUITE)) $(FIGS_STRUCT_$(SUITE)) $(COMBINED_CSV_RAW_$(SUITE)) $(COMBINED_CSV_FILTERED_$(SUITE)) $(SAVE_CSV) $(FORCE_REWRITE)

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
