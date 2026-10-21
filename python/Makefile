# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include $(SIMULATION)/local.mk

# Dependencies
PROFILES       := $(foreach g,$(MG_NUM),$(SIMULATION)/data/olivine-wadsleyite-profile-Mg$(g).tsv)
PERPLEX_MODELS := $(shell find $(PERPLEX) -type f -name '*.dat' -exec basename {} .dat \;)
MODELS_WARM    := $(notdir $(RESULTS_KN_WARM))
MODELS_COLD    := $(notdir $(RESULTS_KN_COLD_SLAB))

# Cleanup: clean removes regenerable products; deep-clean adds fetched content
CLEAN      := $(PYTHON)/**/__pycache__ $(PYTHON)/simulation/**/__pycache__
CLEAN      += $(FIGS)/adiabat $(FIGS_SIM_WARM) $(FIGS_SIM_COLD) $(FIGS_SIM_BOTH) $(FIGS)/setup $(DATA_WARM) $(DATA_COLD) $(DATA_BOTH)
DEEP_CLEAN :=

# Targets
.PHONY: all visualize sync-barkla split compositions-main compositions-warm compositions-cold compositions-pair setup kubo meshes meshes-warm meshes-cold clean deep-clean help

all: visualize
visualize: setup kubo meshes compositions-main

sync-barkla:
	@FORCE_SYNC=$(FORCE_SYNC) $(BASH)/simulation/sync-barkla2.sh "$(notdir $(RESULTS_KN_WARM) $(RESULTS_KN_COLD_SLAB))" "$(TIMESTEPS_SYNC_PLUME)" "$(TIMESTEPS_SYNC_SLAB)" "$(SIMULATION)" "$(BARKLA2_SIMULATION)"

compositions-main: compositions-warm compositions-cold compositions-pair

compositions-warm:
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0050" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0100" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0050" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0100" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)")
	$(call LOG_ARTIFACT,$(FIGS_SIM_WARM)/compositions)

compositions-cold:
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_COLD)/meshes" "$(FIGS_SIM_COLD)/compositions" "0100" "b01" "$(ID_C1)" "$(ID_C2)" "$(ID_C3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_COLD)/meshes" "$(FIGS_SIM_COLD)/compositions" "0100" "b50" "$(ID_C4)" "$(ID_C5)" "$(ID_C6)")
	$(call LOG_ARTIFACT,$(FIGS_SIM_COLD)/compositions)

compositions-pair:
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_BOTH)/compositions" "0100" "W1C1" "$(ID_W1)" PAIR "$(ID_C1)" "$(FIGS_SIM_COLD)/meshes")
	$(call LOG_ARTIFACT,$(FIGS_SIM_BOTH)/compositions)

split: meshes-warm meshes-cold $(SPLIT_CSV_BOTH)

$(SPLIT_CSV_BOTH):
	@mkdir -p $(dir $@)
	@PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/mesh/thermal_split.py \
	  --warm-data $(DATA_WARM) \
	  --cold-data $(DATA_COLD) \
	  --out-csv $@ \
	  --profile-ol-wd $(SIMULATION)/data/olivine-wadsleyite-profile-Mg100.tsv \
	  --profile-wd-ri $(SIMULATION)/data/wadsleyite-ringwoodite-profile-Mg100.tsv \
	  --profile-ri-ps $(SIMULATION)/data/ringwoodite-postspinel-profile-Mg100.tsv \
	  --model-height $(MODEL_HEIGHT) \
	  --surface-pressure $(SURFACE_PRESSURE) \
	  --depth-corr-ol-wd=$(DEPTH_CORRECTION_OL_WD) \
	  --depth-corr-wd-ri=$(DEPTH_CORRECTION_WD_RI) \
	  --depth-corr-ri-ps=$(DEPTH_CORRECTION_RI_PS) \
	  --force
	$(call LOG_ARTIFACT,$@)

setup:
	@PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/misc/setup.py \
	  --out-fig-dir $(FIGS)/setup \
	  --width $(MODEL_WIDTH) \
	  --height $(MODEL_HEIGHT) \
	  --x0-slab $(X0_SLAB) \
	  --y0-slab $(Y0_SLAB) \
	  --x1-slab $(X1_SLAB) \
	  --y1-slab $(Y1_SLAB) \
	  --dx-slab $(DX_SLAB) \
	  --dy-slab $(DY_SLAB) \
	  --w-slab $(W_SLAB) \
	  --l-slab $(L_SLAB) \
	  --a-slab $(A_SLAB) \
	  --x0-plume $(X0_PLUME) \
	  --y0-plume $(Y0_PLUME) \
	  --x1-plume $(X1_PLUME) \
	  --y1-plume $(Y1_PLUME) \
	  --dx-plume $(DX_PLUME) \
	  --dy-plume $(DY_PLUME) \
	  --w-plume $(W_PLUME) \
	  --l-plume $(L_PLUME) \
	  --a-plume $(A_PLUME)

kubo:
	@PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/misc/kubo.py --out-fig-dir $(FIGS)/kubo

meshes: meshes-warm meshes-cold

meshes-warm: SUITE := WARM
meshes-cold: SUITE := COLD
meshes-warm meshes-cold: $(PROFILES)
	@$(eval MODELS := $(MODELS_$(SUITE)))
	@$(eval DIRS := $(addprefix $(SIMULATION)/results/, $(MODELS)))
	@$(eval VIS := $(VIS_MODELS_$(SUITE)))
	@for mg in $(MG_NUM); do \
	  PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/mesh/main.py \
	    $(SIMULATION)/data/olivine-wadsleyite-profile-Mg$$mg.tsv \
	    $(SIMULATION)/data/wadsleyite-ringwoodite-profile-Mg$$mg.tsv \
	    $(SIMULATION)/data/ringwoodite-postspinel-profile-Mg$$mg.tsv \
	    $(MODEL_HEIGHT) \
	    $(SURFACE_PRESSURE) \
	    $(FIGS_SIM_$(SUITE)) \
	    $(DATA_$(SUITE)) \
	    --model-ids $(MODELS) \
	    --timesteps $(TIMESTEPS_MESH_$(SUITE)) \
	    --in-dirs $(DIRS) \
	    --visualize-ids $(VIS) \
	    --depth-corr-ol-wd=$(DEPTH_CORRECTION_OL_WD) \
	    --depth-corr-wd-ri=$(DEPTH_CORRECTION_WD_RI) \
	    --depth-corr-ri-ps=$(DEPTH_CORRECTION_RI_PS) \
	    --mode=$(POSTPROCESS_MODE) \
	    --save-csv=$(SAVE_CSV) \
	    --force-reprocess=$(FORCE_REPROCESS) \
	    --verbosity=$(POSTPROCESS_VERBOSITY) \
	    --chunk-size=$(CHUNK_SIZE); \
	done

adiabat: $(PROFILES)

$(PROFILES): $(SIMULATION)/data/olivine-wadsleyite-profile-Mg%.tsv:
	@for model in $(PERPLEX_MODELS); do \
	  cd $(PERPLEX)/$$model && PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/adiabat/main.py $$model $* $(SIMULATION)/data $(FIGS)/adiabat; \
	done

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

deep-clean:
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,visualize    Visualize all results)
	$(call LOG_DETAIL,sync-barkla  Fetch simulation results from barkla)
	$(call LOG_DETAIL,setup        Visualize initial numerical setup)
	$(call LOG_DETAIL,kubo         Visualize Kubo 2022 dataset regression)
	$(call LOG_DETAIL,meshes       Visualize ASPECT models (warm + cold))
	$(call LOG_DETAIL,meshes-warm  Visualize sluggish-warm suite)
	$(call LOG_DETAIL,meshes-cold  Visualize best-fit-cold suite)
	$(call LOG_DETAIL,compositions-main  Compose montage figures (warm + cold))
	$(call LOG_DETAIL,compositions-pair  Compose W1-vs-C1 pair montage)
	$(call LOG_DETAIL,split          Export thermal-kinetic split (warm + cold))
	$(call LOG_DETAIL,clean        Remove generated files (safe))
	$(call LOG_DETAIL,deep-clean   Remove results and data (use with caution!))
	$(call LOG_DETAIL,note         Set VIS_ALL=true (project.mk) to render every model)
