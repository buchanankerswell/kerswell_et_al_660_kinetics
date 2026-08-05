# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include $(SIMULATION)/local.mk

# Dependencies
PROFILES       := $(foreach g,$(MG_NUM),$(SIMULATION)/data/olivine-wadsleyite-profile-Mg$(g).tsv)
PERPLEX_MODELS := $(shell find $(PERPLEX) -type f -name '*.dat' -exec basename {} .dat \;)

# Composition plots
ID_1 := KN_Dynp0_Zol1.4e+04_Zwd1.4e+04_Zri1.6e-03_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02
ID_2 := KN_Dynp0_Zol1.4e+04_Zwd1.4e+04_Zri6.0e-01_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02
ID_3 := KN_Dynp0_Zol1.4e+04_Zwd1.4e+04_Zri1.6e+03_EtaTherm5_EtaTrans1-1-1-1_MG100_Vel5e-02_Temp5e+02
ID_4 := KN_Dynp0_Zol1.4e+04_Zwd1.4e+04_Zri1.6e-03_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02
ID_5 := KN_Dynp0_Zol1.4e+04_Zwd1.4e+04_Zri6.0e-01_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02
ID_6 := KN_Dynp0_Zol1.4e+04_Zwd1.4e+04_Zri1.6e+03_EtaTherm5_EtaTrans1-1-1-50_MG100_Vel5e-02_Temp5e+02

# Cleanup
CLEAN      := $(PYTHON)/**/__pycache__ $(PYTHON)/simulation/**/__pycache__
DEEP_CLEAN := $(FIGS)/adiabat $(FIGS)/simulation

# Targets
.PHONY: all visualize sync-barkla compositions-main setup kubo meshes clean deep-clean help

all: visualize
visualize: setup kubo meshes compositions-main

sync-barkla:
	@$(BASH)/simulation/sync-barkla2.sh "$(notdir $(RESULTS_LH) $(RESULTS_KN))" "$(TIMESTEPS_SYNC)" "$(SIMULATION)" "$(BARKLA2_SIMULATION)"

compositions-main:
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS)/simulation/meshes" "$(FIGS)/simulation/compositions" "0050" "b01" "$(ID_1)" "$(ID_2)" "$(ID_3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS)/simulation/meshes" "$(FIGS)/simulation/compositions" "0100" "b01" "$(ID_1)" "$(ID_2)" "$(ID_3)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS)/simulation/meshes" "$(FIGS)/simulation/compositions" "0050" "b50" "$(ID_4)" "$(ID_5)" "$(ID_6)")
	@(cd $(BASH)/simulation && ./make-compositions.sh "$(FIGS)/simulation/meshes" "$(FIGS)/simulation/compositions" "0100" "b50" "$(ID_4)" "$(ID_5)" "$(ID_6)")

setup:
	@$(CONDA_PYTHON) -u $(PYTHON)/simulation/misc/setup.py \
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
	@$(CONDA_PYTHON) -u $(PYTHON)/simulation/misc/kubo.py --out-fig-dir $(FIGS)/kubo

meshes: $(PROFILES)
	@$(eval MODELS := $(notdir $(RESULTS_LH) $(RESULTS_KN)))
	@$(eval DIRS := $(addprefix $(SIMULATION)/results/, $(MODELS)))
	@for mg in $(MG_NUM); do \
	  PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/mesh/main.py \
	    $(SIMULATION)/data/olivine-wadsleyite-profile-Mg$$mg.tsv \
	    $(SIMULATION)/data/wadsleyite-ringwoodite-profile-Mg$$mg.tsv \
	    $(SIMULATION)/data/ringwoodite-postspinel-profile-Mg$$mg.tsv \
	    $(MODEL_HEIGHT) \
	    $(SURFACE_PRESSURE) \
	    $(FIGS)/simulation \
	    $(SIMULATION)/data \
	    --model-ids $(MODELS) \
	    --timesteps $(TIMESTEPS_MESH) \
	    --in-dirs $(DIRS) \
	    --depth-corr-ol-wd=$(DEPTH_CORRECTION_OL_WD) \
	    --depth-corr-wd-ri=$(DEPTH_CORRECTION_WD_RI) \
	    --depth-corr-ri-ps=$(DEPTH_CORRECTION_RI_PS) \
	    --mode=$(POSTPROCESS_MODE) \
	    --save-csv=$(SAVE_CSV) \
	    --force-reprocess=$(FORCE_REPROCESS) \
	    --verbosity=$(POSTPROCESS_VERBOSITY); \
	done

adiabat: $(PROFILES)

$(PROFILES): $(SIMULATION)/data/olivine-wadsleyite-profile-Mg%.tsv:
	@for model in $(PERPLEX_MODELS); do \
	  cd $(PERPLEX)/$$model && $(CONDA_PYTHON) -u $(PYTHON)/adiabat/main.py $$model $* $(SIMULATION)/data $(FIGS)/adiabat; \
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
	@echo "    meshes       Visualize ASPECT models"
	@echo "    clean        Remove generated files (safe)"
	@echo "    deep-clean   Remove results and data (use with caution!)"
