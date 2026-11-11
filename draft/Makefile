# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)
include local.mk

# Cleanup
EXTS       := aux bbl blg log toc out tex pdf docx
CLEAN      := $(foreach doc,$(DOCS) $(addprefix diff-,$(DOCS)),$(addprefix $(DRAFT)/$(doc).,$(EXTS)))
DEEP_CLEAN :=

# Prevent make from deleting .tex files on failure
.PRECIOUS: $(DRAFT)/%.tex

# Targets
.PHONY: all manuscript supplementary-information response diff clean deep-clean help

all: $(PDFS) $(DOCXS)
manuscript: $(DRAFT)/manuscript.pdf $(DRAFT)/manuscript.docx
supplementary-information: $(DRAFT)/supplementary-information.pdf $(DRAFT)/supplementary-information.docx
response: $(DRAFT)/response.pdf $(DRAFT)/response.docx
diff: all $(DRAFT)/diff-manuscript.pdf $(DRAFT)/diff-supplementary-information.pdf

UPDATE_DATE = $(if $(META),sed -i.bak -E "s/^date: \".*\"/date: \"$(shell date '+%d %B %Y')\"/" $(META) && rm -f $(META).bak)

$(DRAFT)/%.docx: $(DRAFT)/%.md
	$(call LOG_ARTIFACT,$@)
	@$(UPDATE_DATE)
	@pandoc $< -o $@ $(PANDOC_FLAGS)

$(DRAFT)/%.tex: $(DRAFT)/%.md
	$(call LOG_ARTIFACT,$@)
	@$(UPDATE_DATE)
	@pandoc $< -o $@ $(PANDOC_FLAGS)

$(DRAFT)/%.pdf: $(DRAFT)/%.tex
	$(call LOG_ARTIFACT,$@)
	@pandoc $(subst .tex,.md,$<) -o $@ $(PANDOC_FLAGS)

$(DRAFT)/bak/%.tex: ;

$(DRAFT)/diff-%.pdf: $(DRAFT)/bak/%-$(BACKUP_DATE).tex $(DRAFT)/%.tex
	$(call LOG_ARTIFACT,$@ [bak: $(BACKUP_DATE)])
	@if [ ! -f "$<" ]; then \
	  . "$(BASH)/utils/log.sh"; log_error "Backup file $< not found!"; \
	  exit 1; \
	fi
	@latexdiff $(DIFF_FLAGS) $< $(word 2,$^) > $(DRAFT)/diff-$*.tex
	@$(PDFLATEX) $(DRAFT)/diff-$*.tex > /dev/null 2>&1
	@$(PDFLATEX) $(DRAFT)/diff-$*.tex > /dev/null 2>&1

clean:
	@$(call SAFE_RM_LIST,$(CLEAN))

deep-clean:
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,all                                 Render manuscript + SI + response)
	$(call LOG_DETAIL,manuscript                          Render manuscript PDF and DOCX)
	$(call LOG_DETAIL,supplementary-information           Render SI PDF and DOCX)
	$(call LOG_DETAIL,response                            Render response PDF and DOCX)
	$(call LOG_DETAIL,diff-manuscript.pdf                 Generate manuscript diff)
	$(call LOG_DETAIL,diff-supplementary-information.pdf  Generate SI diff)
	$(call LOG_DETAIL,clean                               Cleanup unnecessary files)
