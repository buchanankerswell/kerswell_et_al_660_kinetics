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
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,clean            Remove generated files (safe))
	$(call LOG_DETAIL,deep-clean       Remove results and data (use with caution!))
