# --------------------------------------------------
# Warm-sluggish UID registration
# --------------------------------------------------
$(foreach dynp,$(DYNAMIC_P),\
$(foreach zol,$(Z_OL_WARM_SLUGGISH),\
$(foreach zwd,$(Z_WD_WARM_SLUGGISH),\
$(foreach zri,$(Z_RI_WARM_SLUGGISH),\
$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMPERATURE_BC_WARM_SLUGGISH),\
$(eval $(call REGISTER_UIDS,UIDS_KN_WARM_SLUGGISH,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

# --------------------------------------------------
# Cold-nominal slab UID registration (slab-only, Temp10e+02, nominal Z).
# Nominal Z runs ONLY at the cold anomaly, so the cartesian product here
# never mixes sluggish-Z with cold-T or vice versa.
# --------------------------------------------------
$(foreach dynp,$(DYNAMIC_P),\
$(foreach zol,$(Z_OL_COLD_NOMINAL),\
$(foreach zwd,$(Z_WD_COLD_NOMINAL),\
$(foreach zri,$(Z_RI_COLD_NOMINAL),\
$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMPERATURE_BC_COLD_NOMINAL),\
$(eval $(call REGISTER_UIDS,UIDS_KN_COLD_NOMINAL,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

# --------------------------------------------------
# Sluggish-410 tests (explicit, NOT part of the cartesian sweep)
# Nominal Z_ol/Z_wd at the bottom of the published 410 range (3.0e0, 7.0e0)
# paired with cold-nominal slab temperatures (Temp10e+02) in the penetrating corner
# only (EtaTherm5, b=1, Vel5e-02, Zri6.0e-01). Now named AC1/AC2 and registered
# with the 410-anchor suite below. T3-T4 (Vel20e-02 fast-descent twins) stay here.
# --------------------------------------------------
$(eval $(call REGISTER_UIDS,UIDS_KN_COLD_NOMINAL,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,1,100,20e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_COLD_NOMINAL,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,1,100,20e-02,10e+02))

# --------------------------------------------------
# 410 anchors (explicit, NOT part of the cartesian sweep)
# 410-rate sweep at fixed 660 kinetics (Z_ri 6.0e-01), matched
# EtaTherm5/Vel5e-02 forcing, b=1 plus b=50 twin. Warm set (Temp5e+02,
# sluggish Z_ol/Z_wd 3.0e0/7.0e0) reproduces the bottom end of the previous
# 410 sweep. Cold set (Temp10e+02, same Z_ol/Z_wd) pairs b=1 (AC1/AC2) with
# b=50 twins (AC3/AC4). Must match ID_AW1-AW4/ID_AC1-AC4 in project.mk. Flows
# through KN_ANCHOR_410 wiring (configs, runs, sync, meshes-anchor-410).
# --------------------------------------------------
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,1,100,5e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,1,100,5e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,1,100,5e-02,5e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,1,100,5e-02,5e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,50,100,5e-02,5e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,50,100,5e-02,5e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,50,100,5e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_KN_ANCHOR_410,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,50,100,5e-02,10e+02))

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
PRMS_GLOBALS_KN_WARM_SLUGGISH           := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_KN_WARM_SLUGGISH            := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_KN_WARM_SLUGGISH          := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_KN_WARM_SLUGGISH          := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_KN_WARM_SLUGGISH       := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_PLUME_KN_WARM_SLUGGISH    := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/velocity-plume.prm)
PRMS_VELOCITY_SLAB_KN_WARM_SLUGGISH     := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_PLUME_KN_WARM_SLUGGISH := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/temperature-plume.prm)
PRMS_TEMPERATURE_SLAB_KN_WARM_SLUGGISH  := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_KN_WARM_SLUGGISH       := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_PLUME_KN_WARM_SLUGGISH             := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/plume_$(uid).prm)
PRMS_SLAB_KN_WARM_SLUGGISH              := $(foreach uid,$(UIDS_KN_WARM_SLUGGISH),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# Cold-nominal slab-only parameter files (no cold-nominal plumes)
PRMS_GLOBALS_KN_COLD_NOMINAL          := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_KN_COLD_NOMINAL           := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_KN_COLD_NOMINAL         := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_KN_COLD_NOMINAL         := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_KN_COLD_NOMINAL      := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_SLAB_KN_COLD_NOMINAL    := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_SLAB_KN_COLD_NOMINAL := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_KN_COLD_NOMINAL      := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_SLAB_KN_COLD_NOMINAL             := $(foreach uid,$(UIDS_KN_COLD_NOMINAL),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# 410-anchor slab-only parameter files (no anchor plumes)
PRMS_GLOBALS_KN_ANCHOR_410          := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_KN_ANCHOR_410           := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_KN_ANCHOR_410         := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_KN_ANCHOR_410         := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_KN_ANCHOR_410      := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_SLAB_KN_ANCHOR_410    := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_SLAB_KN_ANCHOR_410 := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_KN_ANCHOR_410      := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_SLAB_KN_ANCHOR_410             := $(foreach uid,$(UIDS_KN_ANCHOR_410),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# --------------------------------------------------
# .prm pattern rules
# --------------------------------------------------
# Shared templates
$(PRMS_GEOMETRY_KN_WARM_SLUGGISH) $(PRMS_GEOMETRY_KN_COLD_NOMINAL) $(PRMS_GEOMETRY_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/geometry.prm: $(ASPECT_TEMPLATES)/shared/geometry.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_PLUME_KN_WARM_SLUGGISH): $(ASPECT_CONFIGS)/%/velocity-plume.prm: $(ASPECT_TEMPLATES)/shared/velocity-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_SLAB_KN_WARM_SLUGGISH) $(PRMS_VELOCITY_SLAB_KN_COLD_NOMINAL) $(PRMS_VELOCITY_SLAB_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/velocity-slab.prm: $(ASPECT_TEMPLATES)/shared/velocity-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)

# KN templates
$(PRMS_GLOBALS_KN_WARM_SLUGGISH) $(PRMS_GLOBALS_KN_COLD_NOMINAL) $(PRMS_GLOBALS_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/globals.prm: $(ASPECT_TEMPLATES)/KN/globals.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SOLVER_KN_WARM_SLUGGISH) $(PRMS_SOLVER_KN_COLD_NOMINAL) $(PRMS_SOLVER_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/solver.prm: $(ASPECT_TEMPLATES)/KN/solver.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_MATERIAL_KN_WARM_SLUGGISH) $(PRMS_MATERIAL_KN_COLD_NOMINAL) $(PRMS_MATERIAL_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/material.prm: $(ASPECT_TEMPLATES)/KN/material.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_COMPOSITION_KN_WARM_SLUGGISH) $(PRMS_COMPOSITION_KN_COLD_NOMINAL) $(PRMS_COMPOSITION_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/composition.prm: $(ASPECT_TEMPLATES)/KN/composition.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_PLUME_KN_WARM_SLUGGISH): $(ASPECT_CONFIGS)/%/temperature-plume.prm: $(ASPECT_TEMPLATES)/KN/temperature-plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_SLAB_KN_WARM_SLUGGISH) $(PRMS_TEMPERATURE_SLAB_KN_COLD_NOMINAL) $(PRMS_TEMPERATURE_SLAB_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/temperature-slab.prm: $(ASPECT_TEMPLATES)/KN/temperature-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_POSTPROCESS_KN_WARM_SLUGGISH) $(PRMS_POSTPROCESS_KN_COLD_NOMINAL) $(PRMS_POSTPROCESS_KN_ANCHOR_410): $(ASPECT_CONFIGS)/%/postprocess.prm: $(ASPECT_TEMPLATES)/KN/postprocess.prm
	$(call GENERATE_PRM,$<,$*,$@)

# Top-level configs
$(PRMS_PLUME_KN_WARM_SLUGGISH): $(ASPECT_CONFIGS)/plume_%.prm: $(ASPECT_TEMPLATES)/KN/plume.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SLAB_KN_WARM_SLUGGISH) $(PRMS_SLAB_KN_COLD_NOMINAL) $(PRMS_SLAB_KN_ANCHOR_410): $(ASPECT_CONFIGS)/slab_%.prm: $(ASPECT_TEMPLATES)/KN/slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
