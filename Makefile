# Include definitions
include project.mk

# Targets
.PHONY: build install uninstall models plume-models slab-models sync-barkla visualize manuscript download environments clean deep-clean help

build: environments download visualize manuscript
	@echo "    --------------------------------------------------"
	@echo "    Study built successfully!"
	@echo "    --------------------------------------------------"
	@open draft/manuscript.pdf

install:
	@$(MAKE) --no-print-directory -C $(BASH) install

uninstall:
	@$(MAKE) --no-print-directory -C $(BASH) uninstall

models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) all-models

plume-models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) plume-models-lh
	@$(MAKE) --no-print-directory -C $(SIMULATION) plume-models-kn

slab-models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) slab-models-lh
	@$(MAKE) --no-print-directory -C $(SIMULATION) slab-models-kn

sync-barkla:
	@$(MAKE) --no-print-directory -C $(PYTHON) sync-barkla

visualize:
	@$(MAKE) --no-print-directory -C $(R) visualize
	@$(MAKE) --no-print-directory -C $(PYTHON) visualize

manuscript:
	@$(MAKE) --no-print-directory -C $(DRAFT) manuscript

download:
	@$(MAKE) --no-print-directory -C $(R) download

environments:
	@if ! conda info --envs | awk '{print $$1}' | grep -qx "kerswell-et-al-mtz-kinetics"; then  conda env create -f $(PYTHON)/environment.yaml; fi
	@Rscript $(R)/environment.R

$(LOG_FILE):
	@mkdir -p $(dir $(LOG_FILE))
	@touch $(LOG_FILE)

clean:
	@$(MAKE) --no-print-directory -C $(BASH) clean || true
	@$(MAKE) --no-print-directory -C $(PYTHON) clean || true
	@$(MAKE) --no-print-directory -C $(R) clean || true
	@$(MAKE) --no-print-directory -C $(SIMULATION) clean || true
	@$(MAKE) --no-print-directory -C $(DRAFT) clean || true
	@find . -name ".DS_Store" -type f -delete

deep-clean: clean
	@$(MAKE) --no-print-directory -C $(BASH) deep-clean || true
	@$(MAKE) --no-print-directory -C $(PYTHON) deep-clean || true
	@$(MAKE) --no-print-directory -C $(R) deep-clean || true
	@$(MAKE) --no-print-directory -C $(SIMULATION) deep-clean || true
	@$(MAKE) --no-print-directory -C $(DRAFT) deep-clean || true

help:
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    install       Build deal.II and ASPECT"
	@echo "    uninstall     Uninstall deal.II and ASPECT"
	@echo "    models        Run ASPECT models"
	@echo "    plume-models  Run ASPECT plume models"
	@echo "    slab-models   Run ASPECT slab models"
	@echo "    sync-barkla   Sync data from barkla2"
	@echo "    visualize     Visualize all results"
	@echo "    environments  Create Conda environments"
	@echo "    clean         Remove generated files (safe)"
	@echo "    deep-clean    Remove results and data (use with caution!)"
