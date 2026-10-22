include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

CLEAN := $(FIGS)/kubo $(FIGS_STRUCT_WARM_SLUGGISH) $(FIGS_STRUCT_COLD_NOMINAL) $(FIGS_STRUCT_BOTH) $(FIGS_SEISMIC_WARM_SLUGGISH) $(FIGS_SEISMIC_COLD_NOMINAL) $(FIGS_SEISMIC_BOTH)

.PHONY: all visualize tables tables-warm-sluggish tables-cold-nominal adiabat simulation simulation-warm-sluggish simulation-cold-nominal simulation-both seismic seismic-warm-sluggish seismic-cold-nominal seismic-both download upload clean help

all: visualize
visualize: adiabat simulation seismic

tables: tables-warm-sluggish tables-cold-nominal

tables-warm-sluggish: SUITE := WARM_SLUGGISH
tables-cold-nominal: SUITE  := COLD_NOMINAL
tables-warm-sluggish tables-cold-nominal:
	@Rscript $(R)/tables.R $(R)/utils $(COMBINED_CSV_FILTERED_$(SUITE)) $(DATA_$(SUITE))

adiabat:
	@for model in $(PERPLEX_MODELS); do Rscript $(R)/adiabat.R $(R)/utils $$model $(SIMULATION)/data $(FIGS)/adiabat; done

seismic: seismic-warm-sluggish seismic-cold-nominal seismic-both

$(MESH_CSV_WARM_SLUGGISH):
	@$(MAKE) --no-print-directory -C $(PYTHON) meshes-warm-sluggish
$(MESH_CSV_COLD_NOMINAL):
	@$(MAKE) --no-print-directory -C $(PYTHON) meshes-cold-nominal

seismic-warm-sluggish: SUITE := WARM_SLUGGISH
seismic-cold-nominal: SUITE  := COLD_NOMINAL
seismic-warm-sluggish: $(MESH_CSV_WARM_SLUGGISH)
seismic-cold-nominal: $(MESH_CSV_COLD_NOMINAL)
seismic-warm-sluggish seismic-cold-nominal:
	@Rscript $(R)/seismic.R $(R)/utils $(DATA_$(SUITE))/seismic_profiles $(FIGS_SEISMIC_$(SUITE))

seismic-both: $(MESH_CSV_WARM_SLUGGISH) $(MESH_CSV_COLD_NOMINAL)
seismic-both:
	@Rscript $(R)/seismic-combined.R $(R)/utils $(DATA_WARM_SLUGGISH)/seismic_profiles $(DATA_COLD_NOMINAL)/seismic_profiles $(FIGS_SEISMIC_BOTH)

simulation: simulation-warm-sluggish simulation-cold-nominal simulation-both

$(LINK_WARM_SLUGGISH) $(LINK_COLD_NOMINAL): $(KERSWELL_410_DATA)
	@mkdir -p $(dir $@) && ln -sf ../$(notdir $(KERSWELL_410_DATA)) $@

simulation-warm-sluggish: SUITE := WARM_SLUGGISH
simulation-cold-nominal: SUITE  := COLD_NOMINAL
simulation-warm-sluggish: $(KERSWELL_410_DATA) $(LINK_WARM_SLUGGISH) $(MESH_CSV_WARM_SLUGGISH)
simulation-cold-nominal: $(KERSWELL_410_DATA) $(LINK_COLD_NOMINAL) $(MESH_CSV_COLD_NOMINAL)
simulation-warm-sluggish simulation-cold-nominal:
	@Rscript $(R)/simulation.R $(R)/utils $(DATA_$(SUITE)) $(FIGS_STRUCT_$(SUITE)) $(COMBINED_CSV_RAW_$(SUITE)) $(COMBINED_CSV_FILTERED_$(SUITE)) $(SAVE_CSV) $(FORCE_REWRITE)

$(SPLIT_CSV_BOTH):
	@$(MAKE) --no-print-directory -C $(PYTHON) split
simulation-both: $(KERSWELL_410_DATA) $(LINK_WARM_SLUGGISH) $(MESH_CSV_WARM_SLUGGISH) $(MESH_CSV_COLD_NOMINAL) $(SPLIT_CSV_BOTH)
simulation-both:
	@mkdir -p $(DATA_BOTH)
	@Rscript $(R)/simulation-combined.R $(R)/utils $(DATA_WARM_SLUGGISH) $(DATA_COLD_NOMINAL) $(FIGS_STRUCT_BOTH) $(COMBINED_CSV_RAW_BOTH) $(COMBINED_CSV_FILTERED_BOTH) $(SAVE_CSV) $(FORCE_REWRITE) $(SPLIT_CSV_BOTH)

download:
	@Rscript $(R)/osf.R $(R)/utils $(ASPECT_RESULTS) $(SIMULATION)/data "download"

upload:
	@Rscript $(R)/osf.R $(R)/utils $(ASPECT_RESULTS) $(SIMULATION)/data "upload"

$(KERSWELL_410_DATA):
	@Rscript $(R)/download.R $(R)/utils $(SIMULATION)/data

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,visualize   Visualize all results)
	$(call LOG_DETAIL,adiabat     Visualize adiabatic profiles)
	$(call LOG_DETAIL,simulation  Visualize simulation results (warm-sluggish + cold-nominal + combined))
	$(call LOG_DETAIL,seismic     Visualize seismic profiles (warm-sluggish + cold-nominal))
	$(call LOG_DETAIL,tables      Write result tables (warm-sluggish + cold-nominal))
	$(call LOG_DETAIL,download    Download ASPECT results from OSF)
	$(call LOG_DETAIL,upload      Upload ASPECT results to OSF)
	$(call LOG_DETAIL,clean       Remove generated files (safe))
