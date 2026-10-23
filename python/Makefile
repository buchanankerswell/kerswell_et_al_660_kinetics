# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include $(SIMULATION)/local.mk

PROFILES             := $(foreach g,$(MG_NUM),$(SIMULATION)/data/olivine-wadsleyite-profile-Mg$(g).tsv)
MODELS_WARM_SLUGGISH := $(notdir $(RESULTS_KN_WARM_SLUGGISH))
MODELS_COLD_NOMINAL  := $(notdir $(RESULTS_KN_COLD_NOMINAL_SLAB))
MODELS_ANCHOR_410  := $(notdir $(RESULTS_KN_ANCHOR_410_SLAB))

CLEAN := $(PYTHON)/**/__pycache__ $(PYTHON)/simulation/**/__pycache__
CLEAN += $(FIGS)/adiabat $(FIGS_SIM_WARM_SLUGGISH) $(FIGS_SIM_COLD_NOMINAL) $(FIGS_SIM_ANCHOR_410) $(FIGS_SIM_REVISIONS) $(FIGS_SIM_SUBMISSION) $(FIGS)/setup $(DATA_WARM_SLUGGISH) $(DATA_COLD_NOMINAL) $(DATA_ANCHOR_410) $(DATA_REVISIONS)

.PHONY: all visualize visualize-submission sync-barkla sync-barkla-anchor-410 split-revisions compositions-main compositions-submission compositions-warm-sluggish compositions-cold-nominal compositions-pair setup kubo meshes meshes-warm-sluggish meshes-cold-nominal meshes-anchor-410 clean help

all: visualize
visualize: setup kubo meshes compositions-main
visualize-submission: setup kubo meshes-warm-sluggish compositions-submission

sync-barkla:
	@FORCE_SYNC=$(FORCE_SYNC) $(BASH)/simulation/sync-barkla2.sh "$(notdir $(RESULTS_KN_WARM_SLUGGISH) $(RESULTS_KN_COLD_NOMINAL_SLAB) $(RESULTS_KN_ANCHOR_410_SLAB))" "$(TIMESTEPS_SYNC_PLUME)" "$(TIMESTEPS_SYNC_SLAB)" "$(SIMULATION)" "$(BARKLA2_SIMULATION)"

sync-barkla-anchor-410:
	@FORCE_SYNC=$(FORCE_SYNC) $(BASH)/simulation/sync-barkla2.sh "$(MODELS_ANCHOR_410)" "$(TIMESTEPS_SYNC_PLUME)" "$(TIMESTEPS_SYNC_SLAB)" "$(SIMULATION)" "$(BARKLA2_SIMULATION)"

compositions-main: compositions-warm-sluggish compositions-cold-nominal compositions-pair

# Submission triples (warm-sluggish only) at the original submission paths.
compositions-submission:
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_SUBMISSION)/compositions" "0050" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)"
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_SUBMISSION)/compositions" "0100" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)"
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_SUBMISSION)/compositions" "0050" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)"
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_SUBMISSION)/compositions" "0100" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)"
	$(call LOG_ARTIFACT,$(FIGS_SIM_SUBMISSION)/compositions)

compositions-warm-sluggish:
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_WARM_SLUGGISH)/compositions" "0050" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)"
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_WARM_SLUGGISH)/compositions" "0100" "b01" "$(ID_W1)" "$(ID_W2)" "$(ID_W3)"
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_WARM_SLUGGISH)/compositions" "0050" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)"
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_WARM_SLUGGISH)/compositions" "0100" "b50" "$(ID_W4)" "$(ID_W5)" "$(ID_W6)"
	$(call LOG_ARTIFACT,$(FIGS_SIM_WARM_SLUGGISH)/compositions)

compositions-cold-nominal:
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_COLD_NOMINAL)/meshes" "$(FIGS_SIM_COLD_NOMINAL)/compositions" "0100" "b01" "$(ID_C1)" "$(ID_C2)" "$(ID_C3)"
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_COLD_NOMINAL)/meshes" "$(FIGS_SIM_COLD_NOMINAL)/compositions" "0100" "b50" "$(ID_C4)" "$(ID_C5)" "$(ID_C6)"
	$(call LOG_ARTIFACT,$(FIGS_SIM_COLD_NOMINAL)/compositions)

compositions-pair:
	@$(BASH)/simulation/make-compositions.sh "$(FIGS_SIM_WARM_SLUGGISH)/meshes" "$(FIGS_SIM_REVISIONS)/compositions" "0100" "W1-C1" "$(ID_W1)" PAIR "$(ID_C1)" "$(FIGS_SIM_COLD_NOMINAL)/meshes"
	$(call LOG_ARTIFACT,$(FIGS_SIM_REVISIONS)/compositions)

split-revisions: meshes-warm-sluggish meshes-cold-nominal $(SPLIT_CSV_REVISIONS)

$(SPLIT_CSV_REVISIONS):
	@mkdir -p $(dir $@)
	@PYTHONPATH=$(PYTHON) $(CONDA_PYTHON) -u $(PYTHON)/simulation/mesh/thermal-split.py \
	  --warm-sluggish-data $(DATA_WARM_SLUGGISH) \
	  --cold-nominal-data $(DATA_COLD_NOMINAL) \
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

meshes: meshes-warm-sluggish meshes-cold-nominal

meshes-warm-sluggish: SUITE := WARM_SLUGGISH
meshes-cold-nominal: SUITE  := COLD_NOMINAL
meshes-anchor-410: SUITE  := ANCHOR_410
meshes-warm-sluggish meshes-cold-nominal meshes-anchor-410: $(PROFILES)
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
	$(call LOG_DETAIL,visualize          Visualize all results)
	$(call LOG_DETAIL,visualize-submission Visualize submission figures (warm-sluggish only))
	$(call LOG_DETAIL,compositions-submission Submission triples at original paths)
	$(call LOG_DETAIL,sync-barkla        Fetch simulation results from barkla)
	$(call LOG_DETAIL,setup              Visualize initial numerical setup)
	$(call LOG_DETAIL,kubo               Visualize Kubo 2022 dataset regression)
	$(call LOG_DETAIL,meshes             Visualize ASPECT models (warm-sluggish + cold-nominal))
	$(call LOG_DETAIL,meshes-anchor-410  Visualize 410-anchor meshes)
	$(call LOG_DETAIL,split-revisions  Export revisions thermal-kinetic split)
	$(call LOG_DETAIL,clean              Remove generated files (safe))
