# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

CLEAN := $(FIGS_KUBO) $(FIGS_STRUCTURE) $(FIGS_SEISMIC) $(POSTPROCESSED_CSV) $(POSTPROCESSED_MD)

.PHONY: all visualize tables adiabat simulation seismic clean help

all: visualize
visualize: adiabat simulation seismic

tables: $(POSTPROCESSED_CSV)
	@Rscript $(R)/tables.R $(R)/utils $(POSTPROCESSED_CSV) $(SIMULATION)/data

adiabat:
	@for model in $(PERPLEX_MODELS); do Rscript $(R)/adiabat.R $(R)/utils $$model $(SIMULATION)/data $(FIGS)/adiabat; done

seismic: $(MESH_CSV_SW_SUITE) $(MESH_CSV_NC_SUITE)
	@Rscript $(R)/seismic.R $(R)/utils $(SEISMIC_SW_SUITE) $(SEISMIC_NC_SUITE) $(FIGS_SEISMIC) $(FORCE_REWRITE)

simulation: $(MESH_CSV_SW_SUITE) $(MESH_CSV_NC_SUITE) $(POSTPROCESSED_CSV)
	@mkdir -p $(SIMULATION)/data
	@Rscript $(R)/simulation.R $(R)/utils $(MESH_CSV_SW_SUITE) $(MESH_CSV_NC_SUITE) $(FIGS_STRUCTURE) $(FORCE_REWRITE) $(POSTPROCESSED_CSV)

$(MESH_CSV_SW_SUITE):
	@$(MAKE) --no-print-directory -C $(PYTHON) meshes-sw-suite
$(MESH_CSV_NC_SUITE):
	@$(MAKE) --no-print-directory -C $(PYTHON) meshes-nc-suite

$(POSTPROCESSED_CSV):
	@$(MAKE) --no-print-directory -C $(PYTHON) postprocess

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,visualize   Visualize all results (SW + NC + TEST + combined))
	$(call LOG_DETAIL,adiabat     Visualize adiabatic profiles)
	$(call LOG_DETAIL,simulation  Visualize combined simulation results)
	$(call LOG_DETAIL,seismic     Visualize combined seismic profiles)
	$(call LOG_DETAIL,tables      Write combined result tables)
	$(call LOG_DETAIL,clean       Remove generated files (safe))
