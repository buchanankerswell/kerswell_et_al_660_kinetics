# Include definitions
include project.mk

# Targets
.PHONY: build models plume-models slab-models sync-barkla visualize manuscript download environments clean deep-clean help

build: environments download visualize manuscript
	@echo "    --------------------------------------------------"
	@echo "    Study built successfully!"
	@echo "    --------------------------------------------------"

models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) all-models

plume-models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) plume-models-kn-warm

slab-models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) slab-models-kn-warm
	@$(MAKE) --no-print-directory -C $(SIMULATION) slab-models-kn-cold

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

clean:
	@$(MAKE) --no-print-directory -C $(BASH) clean
	@$(MAKE) --no-print-directory -C $(PYTHON) clean
	@$(MAKE) --no-print-directory -C $(R) clean
	@$(MAKE) --no-print-directory -C $(SIMULATION) clean
	@$(MAKE) --no-print-directory -C $(DRAFT) clean
	@find . -name ".DS_Store" -type f -delete

deep-clean: clean
	@$(MAKE) --no-print-directory -C $(BASH) deep-clean
	@$(MAKE) --no-print-directory -C $(PYTHON) deep-clean
	@$(MAKE) --no-print-directory -C $(R) deep-clean
	@$(MAKE) --no-print-directory -C $(SIMULATION) deep-clean
	@$(MAKE) --no-print-directory -C $(DRAFT) deep-clean

help:
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    build         Fetch data and reproduce figures and manuscript"
	@echo "    models        Run ASPECT models (needs aspect/dealii links)"
	@echo "    plume-models  Run ASPECT plume models"
	@echo "    slab-models   Run ASPECT slab models"
	@echo "    sync-barkla   Sync data from barkla2"
	@echo "    visualize     Visualize all results"
	@echo "    environments  Create Conda environments"
	@echo "    clean         Remove generated files (safe)"
	@echo "    deep-clean    Remove results and data (use with caution!)"
