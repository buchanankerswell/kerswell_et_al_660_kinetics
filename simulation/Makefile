# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include local.mk

ALL_RUNS := $(PRMS_SLAB_SW_SUITE:.prm=.run) $(PRMS_SLAB_NC_SUITE:.prm=.run) $(PRMS_SLAB_TEST_SUITE:.prm=.run)

CORE_SW_SUITE   := $(PRMS_GLOBALS_SW_SUITE) $(PRMS_SOLVER_SW_SUITE) $(PRMS_GEOMETRY_SW_SUITE) $(PRMS_MATERIAL_SW_SUITE) $(PRMS_COMPOSITION_SW_SUITE) $(PRMS_POSTPROCESS_SW_SUITE)
CORE_NC_SUITE   := $(PRMS_GLOBALS_NC_SUITE) $(PRMS_SOLVER_NC_SUITE) $(PRMS_GEOMETRY_NC_SUITE) $(PRMS_MATERIAL_NC_SUITE) $(PRMS_COMPOSITION_NC_SUITE) $(PRMS_POSTPROCESS_NC_SUITE)
CORE_TEST_SUITE := $(PRMS_GLOBALS_TEST_SUITE) $(PRMS_SOLVER_TEST_SUITE) $(PRMS_GEOMETRY_TEST_SUITE) $(PRMS_MATERIAL_TEST_SUITE) $(PRMS_COMPOSITION_TEST_SUITE) $(PRMS_POSTPROCESS_TEST_SUITE)

CLEAN      := $(ASPECT_PLUGIN) $(ASPECT_CONFIGS)
DEEP_CLEAN := $(ASPECT_RESULTS) $(ASPECT_DATA)

.PHONY: all all-models slab-models-sw-suite slab-models-nc-suite slab-models-test-suite configs configs-sw-suite configs-nc-suite configs-test-suite clean deep-clean help
.PRECIOUS: $(ASPECT_CONFIGS)

all: all-models
all-models: $(ALL_RUNS)
configs: configs-sw-suite configs-nc-suite configs-test-suite
configs-sw-suite: $(PRMS_SLAB_SW_SUITE)
configs-nc-suite: $(PRMS_SLAB_NC_SUITE)
configs-test-suite: $(PRMS_SLAB_TEST_SUITE)
slab-models-sw-suite: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_SLAB_SW_SUITE:.prm=.run)
slab-models-nc-suite: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_SLAB_NC_SUITE:.prm=.run)
slab-models-test-suite: $(ASPECT_EXE) $(DEALII_ENABLE) $(ASPECT_PROFILES) $(PRMS_SLAB_TEST_SUITE:.prm=.run)

$(PRMS_SLAB_SW_SUITE:.prm=.run): $(ASPECT_PLUGIN)
$(PRMS_SLAB_NC_SUITE:.prm=.run): $(ASPECT_PLUGIN)
$(PRMS_SLAB_TEST_SUITE:.prm=.run): $(ASPECT_PLUGIN)

$(PRMS_SLAB_SW_SUITE): $(CORE_SW_SUITE) $(PRMS_VELOCITY_SLAB_SW_SUITE) $(PRMS_TEMPERATURE_SLAB_SW_SUITE)
$(PRMS_SLAB_NC_SUITE): $(CORE_NC_SUITE) $(PRMS_VELOCITY_SLAB_NC_SUITE) $(PRMS_TEMPERATURE_SLAB_NC_SUITE)
$(PRMS_SLAB_TEST_SUITE): $(CORE_TEST_SUITE) $(PRMS_VELOCITY_SLAB_TEST_SUITE) $(PRMS_TEMPERATURE_SLAB_TEST_SUITE)

$(ASPECT_CONFIGS)/%.prm: $(ASPECT_PROFILES)

$(PRMS_GLOBALS_SW_SUITE): | $(ASPECT_CONFIGS)

$(ASPECT_CONFIGS):
	@mkdir -p $@

# Delegates to bash/Makefile so each .sh is invoked once.
%.run: %.prm
	@$(MAKE) --no-print-directory -C $(BASH) run-aspect PRM=$<

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
	$(call LOG_DETAIL,all-models                 Run all ASPECT models (SW + NC + TEST))
	$(call LOG_DETAIL,slab-models-sw-suite    Run SW-suite ASPECT slab models)
	$(call LOG_DETAIL,slab-models-nc-suite    Run NC-suite ASPECT slab models)
	$(call LOG_DETAIL,slab-models-test-suite  Run TEST-suite ASPECT slabs (T1-T4))
	$(call LOG_DETAIL,configs                    Generate configs only (all suites))
	$(call LOG_DETAIL,clean                      Remove generated files (safe))
	$(call LOG_DETAIL,deep-clean                 Remove results and data (use with caution!))
