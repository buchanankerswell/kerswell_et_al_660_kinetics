# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

# Cleanup
CLEAN      := $(BASH)/log $(DEALII)/tmp $(LOG_FILE)
DEEP_CLEAN := $(BASH)/candi

# Targets
.PHONY: all install uninstall install-aspect install-dealii uninstall-dealii uninstall-aspect clean deep-clean help

all: install
install: install-dealii install-aspect
uninstall: uninstall-aspect uninstall-dealii
install-aspect: $(ASPECT_EXE)
install-dealii: $(DEALII_LIB)

uninstall-aspect:
	@$(call SAFE_RM_LIST,$(ASPECT))

uninstall-dealii:
	@$(call SAFE_RM_LIST,$(DEALII))

$(ASPECT_EXE): $(LOG_FILE)
	@if [ "$(OS_SYSTEM)" = "rocky" ]; then \
	  if echo "$(shell hostname)" | grep -q "login"; then \
	    echo " !! Warning: This script cannot be run on the BARKLA login node!" $(LOGGER); \
	    echo " !!          Start an interactive session with 'srun --ntasks=<N> --pty /bin/bash'" $(LOGGER); \
	    exit 1; \
	  fi; \
	  bash -i -c "source $(INSTALL_ASPECT) $(DEALII_VERSION) $(GCC) $(OPENMPI) $(OPENBLAS) $(CMAKE)" $(LOGGER) || exit 1; \
	else \
	  $(INSTALL_ASPECT) $(DEALII_VERSION) $(LOGGER); \
	fi

$(DEALII_LIB): $(LOG_FILE)
	@if [ "$(OS_SYSTEM)" = "rocky" ]; then \
	  if echo "$(shell hostname)" | grep -q "login"; then \
	    echo " !! Warning: This script cannot be run on the BARKLA login node!" $(LOGGER); \
	    echo " !!          Start an interactive session with 'srun --ntasks=<N> --pty /bin/bash'" $(LOGGER); \
	    exit 1; \
	  fi; \
	  bash -i -c "source $(INSTALL_DEALII) $(DEALII_VERSION) $(TRILINOS_VERSION) $(GCC) $(OPENMPI) $(OPENBLAS) $(CMAKE)" $(LOGGER) || exit 1; \
	else \
	  $(INSTALL_DEALII) $(DEALII_VERSION) $(LOGGER); \
	fi

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

deep-clean:
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

help:
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    install          Build deal.II and ASPECT"
	@echo "    install-aspect   Build ASPECT"
	@echo "    install-dealii   Build deal.II"
	@echo "    uninstall        Uninstall deal.II and ASPECT"
	@echo "    uninstall-aspect UninstallASPECT"
	@echo "    uninstall-dealii Uninstall deal.II"
	@echo "    clean            Remove generated files (safe)"
	@echo "    deep-clean       Remove results and data (use with caution!)"
