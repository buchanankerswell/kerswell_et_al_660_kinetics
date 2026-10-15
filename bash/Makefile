# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

# Cleanup
CLEAN      := $(PROJECT_ROOT)/log-*.out
DEEP_CLEAN :=

# Targets
.PHONY: clean deep-clean help

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

deep-clean:
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

help:
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    clean            Remove generated files (safe)"
	@echo "    deep-clean       Remove results and data (use with caution!)"
