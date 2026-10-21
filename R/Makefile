# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

# Dependencies
KERSWELL_410_DATA := $(SIMULATION)/data/structure-summary-kerswell-et-al-2026.csv
PERPLEX_MODELS    := $(shell find $(PERPLEX) -type f -name '*.dat' -exec basename {} .dat \;)

# Cleanup: clean removes regenerable products (figures); suite data dirs are
# owned by the python mesh pipeline. deep-clean has nothing to add here.
CLEAN      := $(FIGS)/kubo $(FIGS_STRUCT_WARM) $(FIGS_STRUCT_COLD) $(FIGS_STRUCT_BOTH) $(FIGS_SEISMIC_WARM) $(FIGS_SEISMIC_COLD) $(FIGS_SEISMIC_BOTH)
DEEP_CLEAN :=

# Targets
.PHONY: all visualize tables tables-warm tables-cold adiabat simulation simulation-warm simulation-cold simulation-both seismic seismic-warm seismic-cold seismic-both download upload clean deep-clean help

all: visualize
visualize: adiabat simulation seismic

tables: tables-warm tables-cold

tables-warm: SUITE := WARM
tables-cold: SUITE := COLD
tables-warm tables-cold:
	@Rscript $(R)/tables.R $(R)/utils $(COMBINED_CSV_FILTERED_$(SUITE)) $(DATA_$(SUITE))

adiabat:
	@for model in $(PERPLEX_MODELS); do Rscript $(R)/adiabat.R $(R)/utils $$model $(SIMULATION)/data $(FIGS)/adiabat; done

seismic: seismic-warm seismic-cold seismic-both

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

seismic-both: $(MESH_CSV_WARM) $(MESH_CSV_COLD)
seismic-both:
	@Rscript $(R)/seismic-combined.R $(R)/utils $(DATA_WARM)/seismic_profiles $(DATA_COLD)/seismic_profiles $(FIGS_SEISMIC_BOTH)

simulation: simulation-warm simulation-cold simulation-both

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

# Merged warm+cold figures (single composition + 16-scenario tiles on a shared
# log-Z axis). Reuses the warm kerswell link; per-suite outputs stay untouched.
$(SPLIT_CSV_BOTH):
	@$(MAKE) --no-print-directory -C $(PYTHON) split
simulation-both: $(KERSWELL_410_DATA) $(LINK_WARM) $(MESH_CSV_WARM) $(MESH_CSV_COLD) $(SPLIT_CSV_BOTH)
simulation-both:
	@mkdir -p $(DATA_BOTH)
	@Rscript $(R)/simulation-combined.R $(R)/utils $(DATA_WARM) $(DATA_COLD) $(FIGS_STRUCT_BOTH) $(COMBINED_CSV_RAW_BOTH) $(COMBINED_CSV_FILTERED_BOTH) $(SAVE_CSV) $(FORCE_REWRITE) $(SPLIT_CSV_BOTH)

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
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,visualize   Visualize all results)
	$(call LOG_DETAIL,adiabat     Visualize adiabatic profiles)
	$(call LOG_DETAIL,simulation  Visualize simulation results (warm + cold + combined))
	$(call LOG_DETAIL,seismic     Visualize seismic profiles (warm + cold))
	$(call LOG_DETAIL,tables      Write result tables (warm + cold))
	$(call LOG_DETAIL,download    Download ASPECT results from OSF)
	$(call LOG_DETAIL,upload      Upload ASPECT results to OSF)
	$(call LOG_DETAIL,clean       Remove generated files (safe))
	$(call LOG_DETAIL,deep-clean  Remove results and data (use with caution!))
