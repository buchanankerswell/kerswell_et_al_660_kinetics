# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include local.mk

# All simulation runs
ALL_RUNS := $(PRMS_PLUME_LH:.prm=.run) $(PRMS_SLAB_LH:.prm=.run) $(PRMS_PLUME_KN:.prm=.run) $(PRMS_SLAB_KN:.prm=.run)

# Core components for each type of model
CORE_LH := $(PRMS_GLOBALS_LH) $(PRMS_SOLVER_LH) $(PRMS_GEOMETRY_LH) $(PRMS_MATERIAL_LH) $(PRMS_POSTPROCESS_LH)
CORE_KN := $(PRMS_GLOBALS_KN) $(PRMS_SOLVER_KN) $(PRMS_GEOMETRY_KN) $(PRMS_MATERIAL_KN) $(PRMS_COMPOSITION_KN) $(PRMS_POSTPROCESS_KN)

# Cleanup
CLEAN      := $(ASPECT_PLUGIN) $(ASPECT_CONFIGS)
DEEP_CLEAN := $(ASPECT_RESULTS) $(ASPECT_DATA)

# Targets
.PHONY: all all-models plume-models-lh slab-models-lh plume-models-kn slab-models-kn clean deep-clean help
.PRECIOUS: $(ASPECT_CONFIGS)

all: all-models
all-models: $(ALL_RUNS)
plume-models-lh: $(ASPECT_EXE) $(ASPECT_PROFILES) $(PRMS_PLUME_LH:.prm=.run)
slab-models-lh: $(ASPECT_EXE) $(ASPECT_PROFILES) $(PRMS_SLAB_LH:.prm=.run)
plume-models-kn: $(ASPECT_EXE) $(ASPECT_PROFILES) $(PRMS_PLUME_KN:.prm=.run)
slab-models-kn: $(ASPECT_EXE) $(ASPECT_PROFILES) $(PRMS_SLAB_KN:.prm=.run)

$(PRMS_PLUME_KN:.prm=.run): $(ASPECT_PLUGIN)
$(PRMS_SLAB_KN:.prm=.run): $(ASPECT_PLUGIN)

$(PRMS_SLAB_LH): $(CORE_LH) $(PRMS_VELOCITY_SLAB_LH) $(PRMS_TEMPERATURE_SLAB_LH)
$(PRMS_PLUME_LH): $(CORE_LH) $(PRMS_VELOCITY_PLUME_LH) $(PRMS_TEMPERATURE_PLUME_LH)

$(PRMS_SLAB_KN): $(CORE_KN) $(PRMS_VELOCITY_SLAB_KN) $(PRMS_TEMPERATURE_SLAB_KN)
$(PRMS_PLUME_KN): $(CORE_KN) $(PRMS_VELOCITY_PLUME_KN) $(PRMS_TEMPERATURE_PLUME_KN)

$(ASPECT_CONFIGS)/%.prm: $(ASPECT_PROFILES)

$(PRMS_GLOBALS_KN) $(PRMS_GLOBALS_LH): | $(ASPECT_CONFIGS)

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

$(ASPECT_PLUGIN):
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
	@echo "    models        Run ASPECT models"
	@echo "    plume-models  Run ASPECT plume models"
	@echo "    slab-models   Run ASPECT slab models"
	@echo "    clean         Remove generated files (safe)"
	@echo "    deep-clean    Remove results and data (use with caution!)"
