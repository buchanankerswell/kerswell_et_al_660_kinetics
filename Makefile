# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include project.mk

# Targets
.PHONY: build models plume-models slab-models sync-barkla visualize manuscript download environments clean deep-clean help

build: environments download visualize manuscript
	$(call LOG_INFO,Study built successfully!)

models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) all-models

plume-models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) plume-models-kn-warm-sluggish

slab-models:
	@$(MAKE) --no-print-directory -C $(SIMULATION) slab-models-kn-warm-sluggish
	@$(MAKE) --no-print-directory -C $(SIMULATION) slab-models-kn-cold-nominal

sync-barkla:
	@$(MAKE) --no-print-directory -C $(PYTHON) sync-barkla

visualize:
	@$(MAKE) --no-print-directory -C $(PYTHON) visualize
	@$(MAKE) --no-print-directory -C $(R) visualize

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
	@$(MAKE) --no-print-directory -C $(SIMULATION) deep-clean
	@$(MAKE) --no-print-directory -C $(DRAFT) deep-clean

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,build         Fetch data and reproduce figures and manuscript)
	$(call LOG_DETAIL,models        Run ASPECT models (needs aspect/dealii links))
	$(call LOG_DETAIL,plume-models  Run ASPECT plume models)
	$(call LOG_DETAIL,slab-models   Run ASPECT slab models)
	$(call LOG_DETAIL,sync-barkla   Sync data from barkla2)
	$(call LOG_DETAIL,visualize     Visualize all results)
	$(call LOG_DETAIL,environments  Create Conda environments)
	$(call LOG_DETAIL,clean         Remove generated files (safe))
	$(call LOG_DETAIL,deep-clean    Remove results and data (use with caution!))
