# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include local.mk

# All simulation runs
ALL_RUNS := $(PRMS_PLUME_KN_WARM:.prm=.run) $(PRMS_SLAB_KN_WARM:.prm=.run) $(PRMS_SLAB_KN_COLD:.prm=.run)

# Core components for each type of model
CORE_KN_WARM := $(PRMS_GLOBALS_KN_WARM) $(PRMS_SOLVER_KN_WARM) $(PRMS_GEOMETRY_KN_WARM) $(PRMS_MATERIAL_KN_WARM) $(PRMS_COMPOSITION_KN_WARM) $(PRMS_POSTPROCESS_KN_WARM)
CORE_KN_COLD := $(PRMS_GLOBALS_KN_COLD) $(PRMS_SOLVER_KN_COLD) $(PRMS_GEOMETRY_KN_COLD) $(PRMS_MATERIAL_KN_COLD) $(PRMS_COMPOSITION_KN_COLD) $(PRMS_POSTPROCESS_KN_COLD)

# Cleanup
CLEAN      := $(ASPECT_PLUGIN) $(ASPECT_CONFIGS)
DEEP_CLEAN := $(ASPECT_RESULTS) $(ASPECT_DATA)

# Targets
.PHONY: all all-models plume-models-kn-warm slab-models-kn-warm slab-models-kn-cold configs configs-kn-warm configs-kn-cold clean deep-clean help
.PRECIOUS: $(ASPECT_CONFIGS)

all: all-models
all-models: $(ALL_RUNS)
configs: configs-kn-warm configs-kn-cold
configs-kn-warm: $(PRMS_PLUME_KN_WARM) $(PRMS_SLAB_KN_WARM)
configs-kn-cold: $(PRMS_SLAB_KN_COLD)
plume-models-kn-warm: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_PLUME_KN_WARM:.prm=.run)
slab-models-kn-warm: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_SLAB_KN_WARM:.prm=.run)
slab-models-kn-cold: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_SLAB_KN_COLD:.prm=.run)

$(PRMS_PLUME_KN_WARM:.prm=.run): $(ASPECT_PLUGIN)
$(PRMS_SLAB_KN_WARM:.prm=.run): $(ASPECT_PLUGIN)
$(PRMS_SLAB_KN_COLD:.prm=.run): $(ASPECT_PLUGIN)

$(PRMS_SLAB_KN_WARM): $(CORE_KN_WARM) $(PRMS_VELOCITY_SLAB_KN_WARM) $(PRMS_TEMPERATURE_SLAB_KN_WARM)
$(PRMS_PLUME_KN_WARM): $(CORE_KN_WARM) $(PRMS_VELOCITY_PLUME_KN_WARM) $(PRMS_TEMPERATURE_PLUME_KN_WARM)
$(PRMS_SLAB_KN_COLD): $(CORE_KN_COLD) $(PRMS_VELOCITY_SLAB_KN_COLD) $(PRMS_TEMPERATURE_SLAB_KN_COLD)

$(ASPECT_CONFIGS)/%.prm: $(ASPECT_PROFILES)

$(PRMS_GLOBALS_KN_WARM): | $(ASPECT_CONFIGS)

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
	      $(RUN_ASPECT) $(ASPECT_EXE) "$<" 2>&1 | sed 's/^/ .. /'; \
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
	    echo " xx $$item"; \
	    rm "$$item"; \
	  fi; \
	done

deep-clean:
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

help:
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    all-models         Run all ASPECT models"
	@echo "    plume-models-kn-warm    Run ASPECT plume models"
	@echo "    slab-models-kn-warm     Run warm ASPECT slab models"
	@echo "    slab-models-kn-cold Run cold ASPECT slab models"
	@echo "    configs            Generate configs only"
	@echo "    clean              Remove generated files (safe)"
	@echo "    deep-clean         Remove results and data (use with caution!)"
