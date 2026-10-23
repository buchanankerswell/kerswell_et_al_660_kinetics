# Set the default goal before includes
.DEFAULT_GOAL := help

# Include definitions
include $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../project.mk)

.PHONY: clean help

clean:
	@: nothing generated here

help:
	$(call LOG_INFO,Available targets:)
	$(call LOG_DETAIL,clean  Nothing to remove (no-op))
