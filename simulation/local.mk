# --------------------------------------------------
# Execute UID registration
# --------------------------------------------------
$(foreach dynp,$(DYNAMIC_P),\
$(foreach zol,$(Z_OL),\
$(foreach zwd,$(Z_WD),\
$(foreach zri,$(Z_RI),\
$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMPERATURE_BC),\
$(eval $(call REGISTER_UIDS_KN,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMPERATURE_BC),\
$(eval $(call REGISTER_UIDS_LH,$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))

# --------------------------------------------------
# Derived file lists
# --------------------------------------------------
ASPECT_DATA      := $(SIMULATION)/data
ASPECT_TEMPLATES := $(SIMULATION)/params/templates
ASPECT_CONFIGS   := $(SIMULATION)/configs
ASPECT_PLUGIN    := $(SIMULATION)/plugins/libmtz-kinetics.release.so \
                    $(SIMULATION)/plugins/libmtz-kinetics.debug.so \
                    $(SIMULATION)/plugins/CMakeFiles \
                    $(SIMULATION)/plugins/Makefile \
                    $(SIMULATION)/plugins/CMakeCache.txt \
                    $(SIMULATION)/plugins/cmake_install.cmake \
                    $(SIMULATION)/plugins/.cache
ASPECT_PROFILES  := $(addprefix $(ASPECT_DATA)/olivine-wadsleyite-profile-Mg,$(addsuffix .tsv,$(MG_NUM))) \
                    $(addprefix $(ASPECT_DATA)/wadsleyite-ringwoodite-profile-Mg,$(addsuffix .tsv,$(MG_NUM))) \
                    $(addprefix $(ASPECT_DATA)/ringwoodite-postspinel-profile-Mg,$(addsuffix .tsv,$(MG_NUM)))

# Derived parameter files
PRMS_GLOBALS_KN           := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_KN            := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_KN          := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_KN          := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_KN       := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_PLUME_KN    := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/velocity-plume.prm)
PRMS_VELOCITY_SLAB_KN     := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_PLUME_KN := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/temperature-plume.prm)
PRMS_TEMPERATURE_SLAB_KN  := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_KN       := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_PLUME_KN             := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/plume_$(uid).prm)
PRMS_SLAB_KN              := $(foreach uid,$(UIDS_KN),$(ASPECT_CONFIGS)/slab_$(uid).prm)

PRMS_GLOBALS_LH           := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_LH            := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_LH          := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_LH          := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_VELOCITY_PLUME_LH    := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/velocity-plume.prm)
PRMS_VELOCITY_SLAB_LH     := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_PLUME_LH := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/temperature-plume.prm)
PRMS_TEMPERATURE_SLAB_LH  := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_LH       := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_PLUME_LH             := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/plume_$(uid).prm)
PRMS_SLAB_LH              := $(foreach uid,$(UIDS_LH),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# --------------------------------------------------
# .prm pattern rules
# --------------------------------------------------
# Shared pattern rules
$(PRMS_GEOMETRY_KN) $(PRMS_GEOMETRY_LH): $(ASPECT_CONFIGS)/%/geometry.prm: $(ASPECT_TEMPLATES)/shared/geometry.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_PLUME_KN) $(PRMS_VELOCITY_PLUME_LH): $(ASPECT_CONFIGS)/%/velocity-plume.prm: $(ASPECT_TEMPLATES)/shared/velocity-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_SLAB_KN) $(PRMS_VELOCITY_SLAB_LH): $(ASPECT_CONFIGS)/%/velocity-slab.prm: $(ASPECT_TEMPLATES)/shared/velocity-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)

# KN pattern rules
$(PRMS_GLOBALS_KN): $(ASPECT_CONFIGS)/%/globals.prm: $(ASPECT_TEMPLATES)/KN/globals.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SOLVER_KN): $(ASPECT_CONFIGS)/%/solver.prm: $(ASPECT_TEMPLATES)/KN/solver.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_MATERIAL_KN): $(ASPECT_CONFIGS)/%/material.prm: $(ASPECT_TEMPLATES)/KN/material.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_COMPOSITION_KN): $(ASPECT_CONFIGS)/%/composition.prm: $(ASPECT_TEMPLATES)/KN/composition.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_PLUME_KN): $(ASPECT_CONFIGS)/%/temperature-plume.prm: $(ASPECT_TEMPLATES)/KN/temperature-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_SLAB_KN): $(ASPECT_CONFIGS)/%/temperature-slab.prm: $(ASPECT_TEMPLATES)/KN/temperature-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_POSTPROCESS_KN): $(ASPECT_CONFIGS)/%/postprocess.prm: $(ASPECT_TEMPLATES)/KN/postprocess.prm
	$(call GENERATE_PRM,$<,$*,$@)

# LH pattern rules
$(PRMS_GLOBALS_LH): $(ASPECT_CONFIGS)/%/globals.prm: $(ASPECT_TEMPLATES)/LH/globals.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SOLVER_LH): $(ASPECT_CONFIGS)/%/solver.prm: $(ASPECT_TEMPLATES)/LH/solver.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_MATERIAL_LH): $(ASPECT_CONFIGS)/%/material.prm: $(ASPECT_TEMPLATES)/LH/material.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_PLUME_LH): $(ASPECT_CONFIGS)/%/temperature-plume.prm: $(ASPECT_TEMPLATES)/LH/temperature-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_SLAB_LH): $(ASPECT_CONFIGS)/%/temperature-slab.prm: $(ASPECT_TEMPLATES)/LH/temperature-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_POSTPROCESS_LH): $(ASPECT_CONFIGS)/%/postprocess.prm: $(ASPECT_TEMPLATES)/LH/postprocess.prm
	$(call GENERATE_PRM,$<,$*,$@)

# Top-level config pattern rules
$(PRMS_PLUME_KN): $(ASPECT_CONFIGS)/plume_%.prm: $(ASPECT_TEMPLATES)/KN/plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SLAB_KN): $(ASPECT_CONFIGS)/slab_%.prm: $(ASPECT_TEMPLATES)/KN/slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_PLUME_LH): $(ASPECT_CONFIGS)/plume_%.prm: $(ASPECT_TEMPLATES)/LH/plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SLAB_LH): $(ASPECT_CONFIGS)/slab_%.prm: $(ASPECT_TEMPLATES)/LH/slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
