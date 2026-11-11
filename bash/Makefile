# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include $(SIMULATION)/local.mk

.PHONY: all sync-barkla compositions-si run-aspect download clean help

all: ;

# Fetch archived datasets from Zenodo (all suites: SW + NC + TEST).
download:
	@$(BASH)/simulation/download-zenodo.sh "$(ZENODO_DATASET_DOI)" "$(PROJECT_ROOT)" "$(ZENODO_FILES)" "$(FORCE_DOWNLOAD)"

sync-barkla:
	@FORCE_SYNC=$(FORCE_SYNC) $(BASH)/simulation/sync-barkla2.sh \
	  "$(notdir $(RESULTS_SW_SUITE) $(RESULTS_NC_SUITE) $(RESULTS_TEST_SUITE))" "$(TIMESTEPS_SYNC)" "$(SIMULATION)" "$(BARKLA2_SIMULATION)"

compositions-si:
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_SW_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen04" "$(ID_SW1)" "$(ID_SW2)" "$(ID_SW3)"
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_SW_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen00" "$(ID_SW4)" "$(ID_SW5)" "$(ID_SW6)"
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_SW_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen06" "$(ID_SW7)" "$(ID_SW8)" "$(ID_SW9)"
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_SW_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen03" "$(ID_SW10)" "$(ID_SW11)" "$(ID_SW12)"
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_NC_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen12" "$(ID_NC1)" "$(ID_NC2)" "$(ID_NC3)"
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_NC_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen08" "$(ID_NC4)" "$(ID_NC5)" "$(ID_NC6)"
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_NC_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen14" "$(ID_NC7)" "$(ID_NC8)" "$(ID_NC9)"
	@TITLE_ROWS=1 FORCE_COMPOSE=$(FORCE_COMPOSE) $(BASH)/simulation/make-compositions.sh \
	  "$(FIGS_SIM_NC_SUITE)/meshes" "$(FIGS_SIMULATION)/compositions" "0100" "scen11" "$(ID_NC10)" "$(ID_NC11)" "$(ID_NC12)"
	$(call LOG_ARTIFACT,$(FIGS_SIMULATION)/compositions)

# Run one ASPECT model: `make -C bash run-aspect PRM=<path/to/model.prm>`.
PRM_NAME := $(basename $(notdir $(PRM)))
RUN      := $(PRM:.prm=.run)
run-aspect:
	@mkdir -p $(SIMULATION)/results/$(PRM_NAME)
	@if [ ! -f "$(RUN)" ]; then \
	  if [ "$(OS_SYSTEM)" = "rocky" ]; then \
	    sbatch --job-name="$(PRM_NAME)" \
	      --output="$(SIMULATION)/results/$(PRM_NAME)/$(PRM_NAME).log" \
	      --partition="nodes" \
	      --ntasks=$(NTASKS) \
	      --ntasks-per-node=$(NTASKSPERNODE) \
	      --time=$(TIME) \
	      --mail-user=$(MAIL_ADDRESS) \
	      --mail-type=$(MAIL_TYPE) \
	      --export=ALL,LOG_SH=$(LOG_SH) \
	      $(RUN_ASPECT) $(ASPECT_EXE) "$(PRM)" $(GCC) $(OPENMPI) $(OPENBLAS) $(CMAKE) 2>&1 | sed 's/^/ .. /'; \
	  else \
	    $(RUN_ASPECT) $(NTASKS) $(ASPECT_EXE) "$(PRM)" 2>&1 | tee -a "$(SIMULATION)/results/$(PRM_NAME)/$(PRM_NAME).log"; \
	  fi \
	fi

clean:
	@: nothing generated here

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,sync-barkla                Fetch simulation results from Barkla2 (all suites))
	$(call LOG_DETAIL,compositions-si            SI montages (SW + NC triplets))
	$(call LOG_DETAIL,run-aspect PRM=<file.prm>  Run one ASPECT model (used by simulation/Makefile))
	$(call LOG_DETAIL,download                  Fetch archived datasets from Zenodo (all suites))
	$(call LOG_DETAIL,clean                      Nothing to remove (no-op))
