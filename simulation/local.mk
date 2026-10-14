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

# --------------------------------------------------
# Cold slab UID registration (slab-only, Temp10e+02, nominal Z)
# Paired generation: nominal Z runs ONLY at the cold anomaly, so the
# cartesian product here never mixes warm-Z with cold-T or vice versa.
# --------------------------------------------------
$(foreach dynp,$(DYNAMIC_P),\
$(foreach zol,$(Z_OL_COLD),\
$(foreach zwd,$(Z_WD_COLD),\
$(foreach zri,$(Z_RI_COLD),\
$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMP_COLD),\
$(eval $(call REGISTER_UIDS_KN_COLD,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

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

# Cold slab-only parameter files (reuse KN templates; no cold plumes)
PRMS_GLOBALS_KN_COLD           := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_KN_COLD            := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_KN_COLD          := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_KN_COLD          := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_KN_COLD       := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_SLAB_KN_COLD     := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_SLAB_KN_COLD  := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_KN_COLD       := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_SLAB_KN_COLD              := $(foreach uid,$(UIDS_KN_COLD),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# --------------------------------------------------
# .prm pattern rules
# --------------------------------------------------
# Shared pattern rules
$(PRMS_GEOMETRY_KN) $(PRMS_GEOMETRY_KN_COLD): $(ASPECT_CONFIGS)/%/geometry.prm: $(ASPECT_TEMPLATES)/shared/geometry.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_PLUME_KN): $(ASPECT_CONFIGS)/%/velocity-plume.prm: $(ASPECT_TEMPLATES)/shared/velocity-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_SLAB_KN) $(PRMS_VELOCITY_SLAB_KN_COLD): $(ASPECT_CONFIGS)/%/velocity-slab.prm: $(ASPECT_TEMPLATES)/shared/velocity-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)

# KN pattern rules
$(PRMS_GLOBALS_KN) $(PRMS_GLOBALS_KN_COLD): $(ASPECT_CONFIGS)/%/globals.prm: $(ASPECT_TEMPLATES)/KN/globals.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SOLVER_KN) $(PRMS_SOLVER_KN_COLD): $(ASPECT_CONFIGS)/%/solver.prm: $(ASPECT_TEMPLATES)/KN/solver.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_MATERIAL_KN) $(PRMS_MATERIAL_KN_COLD): $(ASPECT_CONFIGS)/%/material.prm: $(ASPECT_TEMPLATES)/KN/material.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_COMPOSITION_KN) $(PRMS_COMPOSITION_KN_COLD): $(ASPECT_CONFIGS)/%/composition.prm: $(ASPECT_TEMPLATES)/KN/composition.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_PLUME_KN): $(ASPECT_CONFIGS)/%/temperature-plume.prm: $(ASPECT_TEMPLATES)/KN/temperature-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_SLAB_KN) $(PRMS_TEMPERATURE_SLAB_KN_COLD): $(ASPECT_CONFIGS)/%/temperature-slab.prm: $(ASPECT_TEMPLATES)/KN/temperature-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_POSTPROCESS_KN) $(PRMS_POSTPROCESS_KN_COLD): $(ASPECT_CONFIGS)/%/postprocess.prm: $(ASPECT_TEMPLATES)/KN/postprocess.prm
	$(call GENERATE_PRM,$<,$*,$@)

# Top-level config pattern rules
$(PRMS_PLUME_KN): $(ASPECT_CONFIGS)/plume_%.prm: $(ASPECT_TEMPLATES)/KN/plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SLAB_KN) $(PRMS_SLAB_KN_COLD): $(ASPECT_CONFIGS)/slab_%.prm: $(ASPECT_TEMPLATES)/KN/slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
