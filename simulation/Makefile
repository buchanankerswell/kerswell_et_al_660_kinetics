# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include local.mk

# All simulation runs
ALL_RUNS := $(PRMS_PLUME_KN_WARM_SLUGGISH:.prm=.run) $(PRMS_SLAB_KN_WARM_SLUGGISH:.prm=.run) $(PRMS_SLAB_KN_COLD_NOMINAL:.prm=.run)

# Core components for each type of model
CORE_KN_WARM_SLUGGISH := $(PRMS_GLOBALS_KN_WARM_SLUGGISH) $(PRMS_SOLVER_KN_WARM_SLUGGISH) $(PRMS_GEOMETRY_KN_WARM_SLUGGISH) $(PRMS_MATERIAL_KN_WARM_SLUGGISH) $(PRMS_COMPOSITION_KN_WARM_SLUGGISH) $(PRMS_POSTPROCESS_KN_WARM_SLUGGISH)
CORE_KN_COLD_NOMINAL  := $(PRMS_GLOBALS_KN_COLD_NOMINAL) $(PRMS_SOLVER_KN_COLD_NOMINAL) $(PRMS_GEOMETRY_KN_COLD_NOMINAL) $(PRMS_MATERIAL_KN_COLD_NOMINAL) $(PRMS_COMPOSITION_KN_COLD_NOMINAL) $(PRMS_POSTPROCESS_KN_COLD_NOMINAL)

# Cleanup
CLEAN      := $(ASPECT_PLUGIN) $(ASPECT_CONFIGS)
DEEP_CLEAN := $(ASPECT_RESULTS) $(ASPECT_DATA)

# Targets
.PHONY: all all-models plume-models-kn-warm-sluggish slab-models-kn-warm-sluggish slab-models-kn-cold-nominal configs configs-kn-warm-sluggish configs-kn-cold-nominal clean deep-clean help
.PRECIOUS: $(ASPECT_CONFIGS)

all: all-models
all-models: $(ALL_RUNS)
configs: configs-kn-warm-sluggish configs-kn-cold-nominal
configs-kn-warm-sluggish: $(PRMS_PLUME_KN_WARM_SLUGGISH) $(PRMS_SLAB_KN_WARM_SLUGGISH)
configs-kn-cold-nominal: $(PRMS_SLAB_KN_COLD_NOMINAL)
plume-models-kn-warm-sluggish: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_PLUME_KN_WARM_SLUGGISH:.prm=.run)
slab-models-kn-warm-sluggish: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_SLAB_KN_WARM_SLUGGISH:.prm=.run)
slab-models-kn-cold-nominal: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_SLAB_KN_COLD_NOMINAL:.prm=.run)

$(PRMS_PLUME_KN_WARM_SLUGGISH:.prm=.run): $(ASPECT_PLUGIN)
$(PRMS_SLAB_KN_WARM_SLUGGISH:.prm=.run): $(ASPECT_PLUGIN)
$(PRMS_SLAB_KN_COLD_NOMINAL:.prm=.run): $(ASPECT_PLUGIN)

$(PRMS_SLAB_KN_WARM_SLUGGISH): $(CORE_KN_WARM_SLUGGISH) $(PRMS_VELOCITY_SLAB_KN_WARM_SLUGGISH) $(PRMS_TEMPERATURE_SLAB_KN_WARM_SLUGGISH)
$(PRMS_PLUME_KN_WARM_SLUGGISH): $(CORE_KN_WARM_SLUGGISH) $(PRMS_VELOCITY_PLUME_KN_WARM_SLUGGISH) $(PRMS_TEMPERATURE_PLUME_KN_WARM_SLUGGISH)
$(PRMS_SLAB_KN_COLD_NOMINAL): $(CORE_KN_COLD_NOMINAL) $(PRMS_VELOCITY_SLAB_KN_COLD_NOMINAL) $(PRMS_TEMPERATURE_SLAB_KN_COLD_NOMINAL)

$(ASPECT_CONFIGS)/%.prm: $(ASPECT_PROFILES)

$(PRMS_GLOBALS_KN_WARM_SLUGGISH): | $(ASPECT_CONFIGS)

$(ASPECT_CONFIGS):
	@mkdir -p $@

%.run: %.prm
	@$(eval PRM_NAME := $(basename $(notdir $<)))
	@mkdir -p $(SIMULATION)/results/$(PRM_NAME)
	@if [ ! -f "$@" ]; then \
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
	      $(RUN_ASPECT) $(ASPECT_EXE) "$<" $(GCC) $(OPENMPI) $(OPENBLAS) $(CMAKE) 2>&1 | sed 's/^/ .. /'; \
	  else \
	    $(RUN_ASPECT) $(NTASKS) $(ASPECT_EXE) "$<" 2>&1 | tee -a "$(SIMULATION)/results/$(PRM_NAME)/$(PRM_NAME).log"; \
	  fi \
	fi

$(ASPECT_PLUGIN): $(ASPECT_EXE) $(DEALII_ENABLE)
	@if [ "$(OS_SYSTEM)" = "rocky" ]; then \
	  module load $(GCC) $(OPENMPI) $(OPENBLAS) $(CMAKE); \
	  cd $(SIMULATION)/plugins; \
	  cmake . -D CMAKE_EXPORT_COMPILE_COMMANDS=ON -D Aspect_DIR=$(dir $(ASPECT_EXE)) -D CMAKE_CXX_COMPILER=mpicxx -W no-dev; \
	  make; \
	else \
	  cd $(SIMULATION)/plugins; \
	  cmake . -D CMAKE_EXPORT_COMPILE_COMMANDS=ON -D Aspect_DIR=$(dir $(ASPECT_EXE)) -W no-dev 2>&1 | sed 's/^/ /'; \
	  make 2>&1 | sed 's/^/ -- /'; \
	fi

$(ASPECT_PROFILES):
	@$(MAKE) --no-print-directory -C $(PYTHON) adiabat

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))
	@find $(PROJECT_ROOT)/simulation -type l -path '*/plugins/aspect*' | while read -r item; do \
	  if [[ "$$item" == $(PROJECT_ROOT)* ]]; then \
	    . "$(BASH)/utils/log.sh"; log_delete "$$item"; \
	    rm "$$item"; \
	  fi; \
	done

deep-clean:
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,all-models                     Run all ASPECT models)
	$(call LOG_DETAIL,plume-models-kn-warm-sluggish  Run ASPECT plume models)
	$(call LOG_DETAIL,slab-models-kn-warm-sluggish   Run warm-sluggish ASPECT slab models)
	$(call LOG_DETAIL,slab-models-kn-cold-nominal    Run cold-nominal ASPECT slab models)
	$(call LOG_DETAIL,configs                        Generate configs only)
	$(call LOG_DETAIL,clean                          Remove generated files (safe))
	$(call LOG_DETAIL,deep-clean                     Remove results and data (use with caution!))
