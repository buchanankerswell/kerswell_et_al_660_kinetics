# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include $(SIMULATION)/local.mk

PROFILES           := $(foreach g,$(MG_NUM),$(SIMULATION)/data/olivine-wadsleyite-profile-Mg$(g).tsv)
MODELS_SW_SUITE    := $(notdir $(RESULTS_SW_SUITE))
MODELS_NC_SUITE    := $(notdir $(RESULTS_NC_SUITE))
MODELS_TEST_SUITE  := $(notdir $(RESULTS_TEST_SUITE))

CLEAN := $(PYTHON)/**/__pycache__ \
	 $(PYTHON)/simulation/**/__pycache__ \
	 $(FIGS)/adiabat \
	 $(FIGS_SW_SUITE) \
	 $(FIGS_NC_SUITE) \
	 $(FIGS_TEST_SUITE) \
	 $(FIGS_SIMULATION) \
	 $(FIGS_SETUP) \
	 $(FIGS_KUBO) \
	 $(DATA_MESH_SW_SUITE) \
	 $(DATA_MESH_NC_SUITE) \
	 $(DATA_MESH_TEST_SUITE) \
	 $(POSTPROCESSED_CSV)

.PHONY: all visualize sync-barkla postprocess compositions-si setup kubo adiabat meshes meshes-sw-suite meshes-nc-suite meshes-test-suite clean help

all: visualize
visualize: setup kubo meshes compositions-si

# Delegates to bash/Makefile so each .sh is invoked once.
sync-barkla:
	@$(MAKE) --no-print-directory -C $(BASH) sync-barkla

compositions-si:
	@$(MAKE) --no-print-directory -C $(BASH) compositions-si

postprocess: meshes-sw-suite meshes-nc-suite meshes-test-suite $(POSTPROCESSED_CSV)

.PHONY: $(POSTPROCESSED_CSV)
$(POSTPROCESSED_CSV):
	@mkdir -p $(dir $@)
	@PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/mesh/export-postprocessed.py \
	  --data-dir $(SIMULATION)/data \
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
	  --out-fig-dir $(FIGS_SETUP) \
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
	  --a-slab $(A_SLAB)

kubo:
	@PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/misc/kubo.py --out-fig-dir $(FIGS_KUBO)

meshes: meshes-sw-suite meshes-nc-suite

meshes-sw-suite: SUITE := SW_SUITE
meshes-nc-suite: SUITE := NC_SUITE
meshes-test-suite: SUITE := TEST_SUITE
meshes-sw-suite meshes-nc-suite meshes-test-suite: $(PROFILES)
	@$(eval MODELS := $(MODELS_$(SUITE)))
	@$(eval DIRS := $(addprefix $(SIMULATION)/results/, $(MODELS)))
	@$(eval VIS := $(VIS_MODELS_$(SUITE)))
	@PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/mesh/main.py \
	  $(SIMULATION)/data/olivine-wadsleyite-profile-Mg$(MG_NUM).tsv \
	  $(SIMULATION)/data/wadsleyite-ringwoodite-profile-Mg$(MG_NUM).tsv \
	  $(SIMULATION)/data/ringwoodite-postspinel-profile-Mg$(MG_NUM).tsv \
	  $(MODEL_HEIGHT) \
	  $(SURFACE_PRESSURE) \
	  $(FIGS_SIM_$(SUITE)) \
	  $(SIMULATION)/data \
	  --model-ids $(MODELS) \
	  --timesteps $(TIMESTEPS_MESH_$(SUITE)) \
	  --suite-tag $(TAG_$(SUITE)) \
	  --in-dirs $(DIRS) \
	  --visualize-ids $(VIS) \
	  --depth-corr-ol-wd=$(DEPTH_CORRECTION_OL_WD) \
	  --depth-corr-wd-ri=$(DEPTH_CORRECTION_WD_RI) \
	  --depth-corr-ri-ps=$(DEPTH_CORRECTION_RI_PS) \
	  --mode=$(POSTPROCESS_MODE) \
	  --save-csv=$(SAVE_CSV) \
	  --force-reprocess=$(FORCE_REPROCESS) \
	  --verbosity=$(POSTPROCESS_VERBOSITY) \
	  --chunk-size=$(CHUNK_SIZE)

adiabat: $(PROFILES)

$(PROFILES): $(SIMULATION)/data/olivine-wadsleyite-profile-Mg%.tsv:
	@for model in $(PERPLEX_MODELS); do \
	  cd $(PERPLEX)/$$model && PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/adiabat/main.py $$model $* $(SIMULATION)/data $(FIGS)/adiabat; \
	done

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,visualize          Visualize all results (SW + NC + TEST + combined))
	$(call LOG_DETAIL,sync-barkla        Fetch simulation results from Barkla2 (delegates to bash))
	$(call LOG_DETAIL,setup              Visualize initial numerical setup (slab-only))
	$(call LOG_DETAIL,adiabat            Build PerpleX phase profiles + adiabat figures)
	$(call LOG_DETAIL,kubo               Visualize Kubo 2022 regression + parameter ranges)
	$(call LOG_DETAIL,meshes             Visualize ASPECT models (SW + NC))
	$(call LOG_DETAIL,meshes-test-suite  Visualize TEST-suite meshes)
	$(call LOG_DETAIL,postprocess         Export postprocessed table (thermal-kinetic split))
	$(call LOG_DETAIL,clean              Remove generated files (safe))
