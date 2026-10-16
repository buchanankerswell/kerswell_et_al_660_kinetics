# --------------------------------------------------
# Execute UID registration
# --------------------------------------------------
$(foreach dynp,$(DYNAMIC_P),\
$(foreach zol,$(Z_OL_WARM),\
$(foreach zwd,$(Z_WD_WARM),\
$(foreach zri,$(Z_RI_WARM),\
$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMPERATURE_BC_WARM),\
$(eval $(call REGISTER_UIDS,UIDS_KN_WARM,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

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
$(foreach dt,$(TEMPERATURE_BC_COLD),\
$(eval $(call REGISTER_UIDS,UIDS_KN_COLD,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

# --------------------------------------------------
# Sluggish-410 tests (explicit, NOT part of the cartesian sweep)
# Nominal Z_ol/Z_wd at the bottom of the published 410 range (3.0e0, 7.0e0)
# paired with cold slab temperatures (Temp10e+02) in the penetrating corner
# only (EtaTherm5, b=1, Vel5e-02, Zri6.0e-01). Must match ID_T1/ID_T2 in
# project.mk exactly. Flows through all KN_COLD wiring (configs, runs,
# sync, meshes-cold) without exploding the sweep.
# --------------------------------------------------
$(eval $(call REGISTER_UIDS,UIDS_KN_COLD,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,1,100,5e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_COLD,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,1,100,5e-02,10e+02))

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
PRMS_GLOBALS_KN_WARM           := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_KN_WARM            := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_KN_WARM          := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_KN_WARM          := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_KN_WARM       := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_PLUME_KN_WARM    := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/velocity-plume.prm)
PRMS_VELOCITY_SLAB_KN_WARM     := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_PLUME_KN_WARM := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/temperature-plume.prm)
PRMS_TEMPERATURE_SLAB_KN_WARM  := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_KN_WARM       := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_PLUME_KN_WARM             := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/plume_$(uid).prm)
PRMS_SLAB_KN_WARM              := $(foreach uid,$(UIDS_KN_WARM),$(ASPECT_CONFIGS)/slab_$(uid).prm)

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
$(PRMS_GEOMETRY_KN_WARM) $(PRMS_GEOMETRY_KN_COLD): $(ASPECT_CONFIGS)/%/geometry.prm: $(ASPECT_TEMPLATES)/shared/geometry.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_PLUME_KN_WARM): $(ASPECT_CONFIGS)/%/velocity-plume.prm: $(ASPECT_TEMPLATES)/shared/velocity-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_SLAB_KN_WARM) $(PRMS_VELOCITY_SLAB_KN_COLD): $(ASPECT_CONFIGS)/%/velocity-slab.prm: $(ASPECT_TEMPLATES)/shared/velocity-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)

# KN pattern rules
$(PRMS_GLOBALS_KN_WARM) $(PRMS_GLOBALS_KN_COLD): $(ASPECT_CONFIGS)/%/globals.prm: $(ASPECT_TEMPLATES)/KN/globals.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SOLVER_KN_WARM) $(PRMS_SOLVER_KN_COLD): $(ASPECT_CONFIGS)/%/solver.prm: $(ASPECT_TEMPLATES)/KN/solver.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_MATERIAL_KN_WARM) $(PRMS_MATERIAL_KN_COLD): $(ASPECT_CONFIGS)/%/material.prm: $(ASPECT_TEMPLATES)/KN/material.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_COMPOSITION_KN_WARM) $(PRMS_COMPOSITION_KN_COLD): $(ASPECT_CONFIGS)/%/composition.prm: $(ASPECT_TEMPLATES)/KN/composition.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_PLUME_KN_WARM): $(ASPECT_CONFIGS)/%/temperature-plume.prm: $(ASPECT_TEMPLATES)/KN/temperature-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_SLAB_KN_WARM) $(PRMS_TEMPERATURE_SLAB_KN_COLD): $(ASPECT_CONFIGS)/%/temperature-slab.prm: $(ASPECT_TEMPLATES)/KN/temperature-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_POSTPROCESS_KN_WARM) $(PRMS_POSTPROCESS_KN_COLD): $(ASPECT_CONFIGS)/%/postprocess.prm: $(ASPECT_TEMPLATES)/KN/postprocess.prm
	$(call GENERATE_PRM,$<,$*,$@)

# Top-level config pattern rules
$(PRMS_PLUME_KN_WARM): $(ASPECT_CONFIGS)/plume_%.prm: $(ASPECT_TEMPLATES)/KN/plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SLAB_KN_WARM) $(PRMS_SLAB_KN_COLD): $(ASPECT_CONFIGS)/slab_%.prm: $(ASPECT_TEMPLATES)/KN/slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
