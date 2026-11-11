# --------------------------------------------------
# SW-suite UID registration (warm slabs, sluggish kinetics)
# --------------------------------------------------
$(foreach dynp,$(DYNAMIC_P),\
$(foreach zol,$(Z_OL_SW_SUITE),\
$(foreach zwd,$(Z_WD_SW_SUITE),\
$(foreach zri,$(Z_RI_SW_SUITE),\
$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMPERATURE_BC_SW_SUITE),\
$(eval $(call REGISTER_UIDS,UIDS_SW_SUITE,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

# --------------------------------------------------
# NC-suite UID registration (slab-only, Temp10e+02, nominal Z).
# Nominal Z runs ONLY at the cold anomaly, so the cartesian product here
# never mixes sluggish-Z with cold-T or vice versa.
# --------------------------------------------------
$(foreach dynp,$(DYNAMIC_P),\
$(foreach zol,$(Z_OL_NC_SUITE),\
$(foreach zwd,$(Z_WD_NC_SUITE),\
$(foreach zri,$(Z_RI_NC_SUITE),\
$(foreach etatherm,$(ETA_THERM),\
$(foreach etaol,$(ETA_PREF_OL),\
$(foreach etawd,$(ETA_PREF_WD),\
$(foreach etari,$(ETA_PREF_RI),\
$(foreach etaps,$(ETA_PREF_PS),\
$(foreach mgnum,$(MG_NUM),\
$(foreach vel,$(VELOCITY_BC),\
$(foreach dt,$(TEMPERATURE_BC_NC_SUITE),\
$(eval $(call REGISTER_UIDS,UIDS_NC_SUITE,$(dynp),$(zol),$(zwd),$(zri),$(etatherm),$(etaol),$(etawd),$(etari),$(etaps),$(mgnum),$(vel),$(dt)))))))))))))))

# --------------------------------------------------
# TEST-suite UIDs (explicit, NOT part of the cartesian sweep)
# Sluggish-410 sensitivity tests at fixed 660 kinetics (Z_ri 6.0e-01),
# matched EtaTherm5/b=1 forcing, cold slabs only (Temp10e+02, Z_ol/Z_wd
# 3.0e0/7.0e0). T1/T2 at Vel5e-02, T3/T4 are fast-descent twins at Vel20e-02.
# Must match ID_T1-T4 in project.mk. Flows through TEST_SUITE wiring
# (configs, runs, sync, meshes-test-suite). Scenarios 16-19 in Table S1.
# --------------------------------------------------
$(eval $(call REGISTER_UIDS,UIDS_TEST_SUITE,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,1,100,5e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_TEST_SUITE,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,1,100,5e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_TEST_SUITE,0,3.0e0,3.0e0,6.0e-01,5,1,1,1,1,100,20e-02,10e+02))
$(eval $(call REGISTER_UIDS,UIDS_TEST_SUITE,0,7.0e0,7.0e0,6.0e-01,5,1,1,1,1,100,20e-02,10e+02))

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
PRMS_GLOBALS_SW_SUITE            := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_SW_SUITE             := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_SW_SUITE           := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_SW_SUITE           := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_SW_SUITE        := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_SLAB_SW_SUITE      := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_SLAB_SW_SUITE   := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_SW_SUITE        := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_SLAB_SW_SUITE               := $(foreach uid,$(UIDS_SW_SUITE),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# NC-suite slab-only parameter files
PRMS_GLOBALS_NC_SUITE            := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_NC_SUITE             := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_NC_SUITE           := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_NC_SUITE           := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_NC_SUITE        := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_SLAB_NC_SUITE      := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_SLAB_NC_SUITE   := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_NC_SUITE        := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_SLAB_NC_SUITE               := $(foreach uid,$(UIDS_NC_SUITE),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# TEST-suite slab-only parameter files
PRMS_GLOBALS_TEST_SUITE          := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/globals.prm)
PRMS_SOLVER_TEST_SUITE           := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/solver.prm)
PRMS_GEOMETRY_TEST_SUITE         := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/geometry.prm)
PRMS_MATERIAL_TEST_SUITE         := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/material.prm)
PRMS_COMPOSITION_TEST_SUITE      := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/composition.prm)
PRMS_VELOCITY_SLAB_TEST_SUITE    := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/velocity-slab.prm)
PRMS_TEMPERATURE_SLAB_TEST_SUITE := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/temperature-slab.prm)
PRMS_POSTPROCESS_TEST_SUITE      := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/$(uid)/postprocess.prm)
PRMS_SLAB_TEST_SUITE             := $(foreach uid,$(UIDS_TEST_SUITE),$(ASPECT_CONFIGS)/slab_$(uid).prm)

# --------------------------------------------------
# .prm pattern rules
# --------------------------------------------------
# Shared templates
$(PRMS_GEOMETRY_SW_SUITE) $(PRMS_GEOMETRY_NC_SUITE) $(PRMS_GEOMETRY_TEST_SUITE): $(ASPECT_CONFIGS)/%/geometry.prm: $(ASPECT_TEMPLATES)/shared/geometry.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_VELOCITY_SLAB_SW_SUITE) $(PRMS_VELOCITY_SLAB_NC_SUITE) $(PRMS_VELOCITY_SLAB_TEST_SUITE): $(ASPECT_CONFIGS)/%/velocity-slab.prm: $(ASPECT_TEMPLATES)/shared/velocity-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)

# KN templates
$(PRMS_GLOBALS_SW_SUITE) $(PRMS_GLOBALS_NC_SUITE) $(PRMS_GLOBALS_TEST_SUITE): $(ASPECT_CONFIGS)/%/globals.prm: $(ASPECT_TEMPLATES)/KN/globals.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_SOLVER_SW_SUITE) $(PRMS_SOLVER_NC_SUITE) $(PRMS_SOLVER_TEST_SUITE): $(ASPECT_CONFIGS)/%/solver.prm: $(ASPECT_TEMPLATES)/KN/solver.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_MATERIAL_SW_SUITE) $(PRMS_MATERIAL_NC_SUITE) $(PRMS_MATERIAL_TEST_SUITE): $(ASPECT_CONFIGS)/%/material.prm: $(ASPECT_TEMPLATES)/KN/material.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_COMPOSITION_SW_SUITE) $(PRMS_COMPOSITION_NC_SUITE) $(PRMS_COMPOSITION_TEST_SUITE): $(ASPECT_CONFIGS)/%/composition.prm: $(ASPECT_TEMPLATES)/KN/composition.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_TEMPERATURE_SLAB_SW_SUITE) $(PRMS_TEMPERATURE_SLAB_NC_SUITE) $(PRMS_TEMPERATURE_SLAB_TEST_SUITE): $(ASPECT_CONFIGS)/%/temperature-slab.prm: $(ASPECT_TEMPLATES)/KN/temperature-slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
$(PRMS_POSTPROCESS_SW_SUITE) $(PRMS_POSTPROCESS_NC_SUITE) $(PRMS_POSTPROCESS_TEST_SUITE): $(ASPECT_CONFIGS)/%/postprocess.prm: $(ASPECT_TEMPLATES)/KN/postprocess.prm
	$(call GENERATE_PRM,$<,$*,$@)

# Top-level configs
$(PRMS_SLAB_SW_SUITE) $(PRMS_SLAB_NC_SUITE) $(PRMS_SLAB_TEST_SUITE): $(ASPECT_CONFIGS)/slab_%.prm: $(ASPECT_TEMPLATES)/KN/slab.prm
	$(call GENERATE_PRM,$<,$*,$@)
