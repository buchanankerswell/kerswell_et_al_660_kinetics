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
CLEAN      += $(FIGS)/adiabat $(FIGS_SIM_WARM) $(FIGS_SIM_COLD) $(DATA_WARM) $(DATA_COLD)
DEEP_CLEAN :=

# Targets
.PHONY: all visualize sync-barkla compositions-main compositions-warm compositions-cold setup kubo meshes meshes-warm meshes-cold clean deep-clean help

all: visualize
visualize: setup kubo meshes compositions-main

sync-barkla:
	@FORCE_SYNC=$(FORCE_SYNC) $(BASH)/simulation/sync-barkla2.sh "$(notdir $(RESULTS_KN_WARM) $(RESULTS_KN_COLD_SLAB))" "$(TIMESTEPS_SYNC_PLUME)" "$(TIMESTEPS_SYNC_SLAB)" "$(SIMULATION)" "$(BARKLA2_SIMULATION)"

compositions-main: compositions-warm compositions-cold

compositions-warm:
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0050" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0100" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0050" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_WARM)/meshes" "$(FIGS_SIM_WARM)/compositions" "0100" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)")
	@printf ' -> %s\n' "$(patsubst $(PROJECT_ROOT)/%,%,$(FIGS_SIM_WARM)/compositions)"

compositions-cold:
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_COLD)/meshes" "$(FIGS_SIM_COLD)/compositions" "0100" "b01" "$(ID_C1)" "$(ID_C2)" "$(ID_C3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS_SIM_COLD)/meshes" "$(FIGS_SIM_COLD)/compositions" "0100" "b50" "$(ID_C4)" "$(ID_C5)" "$(ID_C6)")
	@printf ' -> %s\n' "$(patsubst $(PROJECT_ROOT)/%,%,$(FIGS_SIM_COLD)/compositions)"

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
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    visualize    Visualize all results"
	@echo "    sync-barkla  Fetch simulation results from barkla"
	@echo "    setup        Visualize initial numerical setup"
	@echo "    kubo         Visualize Kubo 2022 dataset regression"
	@echo "    meshes       Visualize ASPECT models (warm + cold)"
	@echo "    meshes-warm  Visualize sluggish-warm suite"
	@echo "    meshes-cold  Visualize best-fit-cold suite"
	@echo "    compositions-main  Compose montage figures (warm + cold)"
	@echo "    clean        Remove generated files (safe)"
	@echo "    deep-clean   Remove results and data (use with caution!)"
