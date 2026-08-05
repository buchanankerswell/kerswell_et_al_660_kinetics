# --------------------------------------------------
# Environments and top-level directories (no edits)
# --------------------------------------------------
# Canonical project root (works from any subdir)
PROJECT_ROOT       := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/.)

# Top-level directories
ASPECT             := $(PROJECT_ROOT)/aspect/build
DEALII             := $(PROJECT_ROOT)/dealii
BASH               := $(PROJECT_ROOT)/bash
DRAFT              := $(PROJECT_ROOT)/draft
PYTHON             := $(PROJECT_ROOT)/python
R                  := $(PROJECT_ROOT)/R
SIMULATION         := $(PROJECT_ROOT)/simulation
FIGS               := $(PROJECT_ROOT)/figs
PERPLEX            := $(PROJECT_ROOT)/perplex

# Remote Barkla2 directories
BARKLA2_ROOT       := /users/kersweb/scratch/kerswell_et_al_660_kinetics
BARKLA2_SIMULATION := $(BARKLA2_ROOT)/simulation

# --------------------------------------------------
# ASPECT model postprocessing (can edit)
# --------------------------------------------------
MODEL_TYPES           := plume slab
ASPECT_RESULTS        := $(SIMULATION)/results
POSTPROCESS_MODE      := full
POSTPROCESS_VERBOSITY := 0
SAVE_CSV              := true
FORCE_REPROCESS       := false
COMBINED_CSV_RAW      := $(SIMULATION)/data/structure-summary-combined.csv
COMBINED_CSV_FILTERED := $(SIMULATION)/data/structure-summary-combined-filtered.csv
FORCE_REWRITE         := true
SEISMIC_PROFILES      := $(SIMULATION)/data/seismic_profiles
RESULTS_LH             = $(foreach type,$(MODEL_TYPES), $(addprefix $(ASPECT_RESULTS)/$(type)_, $(UIDS_LH)))
RESULTS_KN             = $(foreach type,$(MODEL_TYPES), $(addprefix $(ASPECT_RESULTS)/$(type)_, $(UIDS_KN)))
TIMESTEPS_SYNC        := $(shell seq -f "%03g" 0 50 100)
TIMESTEPS_MESH        := $(shell seq -f "%03g" 0 50 100)

# --------------------------------------------------
# ASPECT model parameter space (can edit)
# --------------------------------------------------
# Globals
END_TIME            := 150e+06
SURFACE_TEMPERATURE := 1706
SURFACE_PRESSURE    := 2e+09
SOLVER_TOLERANCE    := 1e-04
MAX_SOLVER_ITER     := 100
MAX_SOLVER_TSTEP    := 25e+04

# Postprocess
VIZ_OUT_TIME        := 1e+06
CHECKPOINT_TIME     := 300

# Use dynamic pressure correction [0: false, 1: true]
DYNAMIC_P           := 0

# Material composition [100: pure MgO, 90: Mg90, etc.]
MG_NUM              := 100

# Viscosity [reference, min, max, thermal exponent, Gibbs: defines width of ETA jump]
ETA_REF     := 1e+21
ETA_MIN     := 1e+19
ETA_MAX     := 1e+24
ETA_GIBBS   := 1e+03
ETA_THERM   := 5 10

# Material prefactors [1: no contrast, 100: 100x contrast, etc.]
ETA_PREF_OL := 1
ETA_PREF_WD := 1
ETA_PREF_RI := 1
ETA_PREF_PS := 1 50

# Phase transition kinetics [Z: prefactor, H: activation enthalpy, V: activation volume, E: activation energy]
Z_OL := 1.4e+04
Z_WD := 1.4e+04
Z_RI := 1.6e-03 1.2e-02 8.3e-02 6.0e-01 4.3e+00 3.1e+01 2.2e+02 1.6e+03

V_OL := 3.3e-06
V_WD := 3.3e-06

H_OL := 274e+03
H_WD := 274e+03

E_RI := 355e+03

DEPTH_CORRECTION_OL_WD := 5e+03
DEPTH_CORRECTION_WD_RI := 5e+03
DEPTH_CORRECTION_RI_PS := 15e+03

# Plume/slab initial and boundary conditions
VELOCITY_BC        :=    5e-02 10e-02
TEMPERATURE_BC     :=    5e+02

# Geometry inputs
MODEL_WIDTH        := 1500e+03
MODEL_HEIGHT       := 1000e+03
MESH_X             :=        3
MESH_Y             :=        2
MESH_REFINE_GLOBAL :=        3
MESH_REFINE_ADAPT  :=        3
MESH_REFINE_TSTEP  :=       10

SLAB_XC            :=  617e+03
SLAB_YC            := 1050e+03
SLAB_L             :=  250e+03
SLAB_FW            :=   66e+03
SLAB_A             :=    5e+03
SLAB_DIP           :=       65

PLUME_XC           :=  750e+03
PLUME_YC           :=    0e+03
PLUME_L            :=  280e+03
PLUME_FW           :=   66e+03
PLUME_A            :=    5e+03

# --------------------------------------------------
# Evaluate slab/plume geometry
# --------------------------------------------------
CONDA_ENV    := kerswell-et-al-mtz-kinetics
CONDA_PYTHON := $(shell conda run -n $(CONDA_ENV) which python 2>/dev/null || echo python3)

_SLAB  := $(shell $(CONDA_PYTHON) -u $(PYTHON)/simulation/params/geometry.py slab $(SLAB_XC) $(SLAB_YC) $(SLAB_L) $(SLAB_FW) --dip $(SLAB_DIP))
_PLUME := $(shell $(CONDA_PYTHON) -u $(PYTHON)/simulation/params/geometry.py plume $(PLUME_XC) $(PLUME_YC) $(PLUME_L) $(PLUME_FW))

X0_SLAB := $(word 1,$(_SLAB))
Y0_SLAB := $(word 2,$(_SLAB))
X1_SLAB := $(word 3,$(_SLAB))
Y1_SLAB := $(word 4,$(_SLAB))
DX_SLAB := $(word 5,$(_SLAB))
DY_SLAB := $(word 6,$(_SLAB))
W_SLAB  := $(word 7,$(_SLAB))
L_SLAB  := $(SLAB_L)
A_SLAB  := $(SLAB_A)

X0_PLUME := $(word 1,$(_PLUME))
Y0_PLUME := $(word 2,$(_PLUME))
X1_PLUME := $(word 3,$(_PLUME))
Y1_PLUME := $(word 4,$(_PLUME))
DX_PLUME := $(word 5,$(_PLUME))
DY_PLUME := $(word 6,$(_PLUME))
W_PLUME  := $(word 7,$(_PLUME))
L_PLUME  := $(PLUME_L)
A_PLUME  := $(PLUME_A)

# --------------------------------------------------
# Macro definitions
# --------------------------------------------------
# Derived phase transitions
define COMPUTE_PHASES
  $(eval _OL_WD  := $(SIMULATION)/data/olivine-wadsleyite-profile-Mg$(1).tsv)
  $(eval _WD_RI  := $(SIMULATION)/data/wadsleyite-ringwoodite-profile-Mg$(1).tsv)
  $(eval _RI_PS  := $(SIMULATION)/data/ringwoodite-postspinel-profile-Mg$(1).tsv)
  $(eval _PH_OUT := $(shell $(CONDA_PYTHON) -u $(PYTHON)/simulation/params/transitions.py $(_OL_WD) $(_WD_RI) $(_RI_PS) $(MODEL_HEIGHT) $(SURFACE_PRESSURE)))
  $(eval TRANS_OL_WD_Y_$(1)      := $(word 1,$(_PH_OUT)))
  $(eval TRANS_OL_WD_DEPTH_$(1)  := $(word 2,$(_PH_OUT)))
  $(eval TRANS_OL_WD_T_$(1)      := $(word 3,$(_PH_OUT)))
  $(eval TRANS_OL_WD_CLAP_$(1)   := $(word 4,$(_PH_OUT)))
  $(eval TRANS_OL_WD_DRHO_$(1)   := $(word 5,$(_PH_OUT)))
  $(eval TRANS_WD_RI_Y_$(1)      := $(word 6,$(_PH_OUT)))
  $(eval TRANS_WD_RI_DEPTH_$(1)  := $(word 7,$(_PH_OUT)))
  $(eval TRANS_WD_RI_T_$(1)      := $(word 8,$(_PH_OUT)))
  $(eval TRANS_WD_RI_CLAP_$(1)   := $(word 9,$(_PH_OUT)))
  $(eval TRANS_WD_RI_DRHO_$(1)   := $(word 10,$(_PH_OUT)))
  $(eval TRANS_RI_PS_Y_$(1)      := $(word 11,$(_PH_OUT)))
  $(eval TRANS_RI_PS_DEPTH_$(1)  := $(word 12,$(_PH_OUT)))
  $(eval TRANS_RI_PS_T_$(1)      := $(word 13,$(_PH_OUT)))
  $(eval TRANS_RI_PS_CLAP_$(1)   := $(word 14,$(_PH_OUT)))
  $(eval TRANS_RI_PS_DRHO_$(1)   := $(word 15,$(_PH_OUT)))
endef

# UID generators
define MAKE_KN_UID
  KN_Dynp$(1)_Zol$(2)_Zwd$(3)_Zri$(4)_EtaTherm$(5)_EtaTrans$(6)-$(7)-$(8)-$(9)_MG$(10)_Vel$(11)_Temp$(12)
endef

define MAKE_LH_UID
  LH_EtaTherm$(1)_EtaTrans$(2)-$(3)-$(4)-$(5)_MG$(6)_Vel$(7)_Temp$(8)
endef

# Derived UIDs
define REGISTER_UIDS_KN
  $(eval _uid := $(strip $(call MAKE_KN_UID,$(1),$(2),$(3),$(4),$(5),$(6),$(7),$(8),$(9),$(10),$(11),$(12))))
  UIDS_KN                += $(_uid)
  PARAM_dynp_$(_uid)     := $(1)
  PARAM_zol_$(_uid)      := $(2)
  PARAM_zwd_$(_uid)      := $(3)
  PARAM_zri_$(_uid)      := $(4)
  PARAM_etatherm_$(_uid) := $(5)
  PARAM_etaol_$(_uid)    := $(6)
  PARAM_etawd_$(_uid)    := $(7)
  PARAM_etari_$(_uid)    := $(8)
  PARAM_etaps_$(_uid)    := $(9)
  PARAM_mgnum_$(_uid)    := $(10)
  PARAM_vel_$(_uid)      := $(11)
  PARAM_dt_$(_uid)       := $(12)
endef

define REGISTER_UIDS_LH
  $(eval _uid := $(strip $(call MAKE_LH_UID,$(1),$(2),$(3),$(4),$(5),$(6),$(7),$(8))))
  UIDS_LH                += $(_uid)
  PARAM_etatherm_$(_uid) := $(1)
  PARAM_etaol_$(_uid)    := $(2)
  PARAM_etawd_$(_uid)    := $(3)
  PARAM_etari_$(_uid)    := $(4)
  PARAM_etaps_$(_uid)    := $(5)
  PARAM_mgnum_$(_uid)    := $(6)
  PARAM_vel_$(_uid)      := $(7)
  PARAM_dt_$(_uid)       := $(8)
endef

# Parameter file generator
define GENERATE_PRM
	$(eval _MG := $(PARAM_mgnum_$(2)))
	$(call COMPUTE_PHASES,$(_MG))
	@echo " -> $(3)"
	@mkdir -p $(dir $(3))
	@$(CONDA_PYTHON) $(PYTHON)/simulation/params/generator.py $(1) $(3) \
	  "end-time=$(END_TIME)" \
	  "surface-temperature=$(SURFACE_TEMPERATURE)" \
	  "surface-pressure=$(SURFACE_PRESSURE)" \
	  "solver-tolerance=$(SOLVER_TOLERANCE)" \
	  "max-solver-iter=$(MAX_SOLVER_ITER)" \
	  "max-solver-tstep=$(MAX_SOLVER_TSTEP)" \
	  "viz-out-time=$(VIZ_OUT_TIME)" \
	  "checkpoint-time=$(CHECKPOINT_TIME)" \
	  "model-width=$(MODEL_WIDTH)" \
	  "model-height=$(MODEL_HEIGHT)" \
	  "mesh-x=$(MESH_X)" \
	  "mesh-y=$(MESH_Y)" \
	  "mesh-refine-adapt=$(MESH_REFINE_ADAPT)" \
	  "mesh-refine-global=$(MESH_REFINE_GLOBAL)" \
	  "mesh-refine-tstep=$(MESH_REFINE_TSTEP)" \
	  "dynp-gibbs=$(if $(filter 1,$(PARAM_dynp_$(2))),true,false)" \
	  "z-ol=$(PARAM_zol_$(2))" \
	  "z-wd=$(PARAM_zwd_$(2))" \
	  "z-ri=$(PARAM_zri_$(2))" \
	  "h-ol=$(H_OL)" \
	  "h-wd=$(H_WD)" \
	  "v-ol=$(V_OL)" \
	  "v-wd=$(V_WD)" \
	  "e-ri=$(E_RI)" \
	  "eta-ref=$(ETA_REF)" \
	  "eta-min=$(ETA_MIN)" \
	  "eta-max=$(ETA_MAX)" \
	  "eta-gibbs=$(ETA_GIBBS)" \
	  "eta-thermal-exp=$(PARAM_etatherm_$(2))" \
	  "eta-pref-olivine=$(PARAM_etaol_$(2))" \
	  "eta-pref-wadsleyite=$(PARAM_etawd_$(2))" \
	  "eta-pref-ringwoodite=$(PARAM_etari_$(2))" \
	  "eta-pref-postspinel=$(PARAM_etaps_$(2))" \
	  "mg-num=$(_MG)" \
	  "velocity=$(PARAM_vel_$(2))" \
	  "dt-anomaly=$(PARAM_dt_$(2))" \
	  "transition-ol-wd=$(TRANS_OL_WD_Y_$(_MG))" \
	  "transition-wd-ri=$(TRANS_WD_RI_Y_$(_MG))" \
	  "transition-ri-ps=$(TRANS_RI_PS_Y_$(_MG))" \
	  "trans-ol-wd-depth=$(TRANS_OL_WD_DEPTH_$(_MG))" \
	  "trans-wd-ri-depth=$(TRANS_WD_RI_DEPTH_$(_MG))" \
	  "trans-ri-ps-depth=$(TRANS_RI_PS_DEPTH_$(_MG))" \
	  "trans-ol-wd-T=$(TRANS_OL_WD_T_$(_MG))" \
	  "trans-wd-ri-T=$(TRANS_WD_RI_T_$(_MG))" \
	  "trans-ri-ps-T=$(TRANS_RI_PS_T_$(_MG))" \
	  "trans-ol-wd-clap=$(TRANS_OL_WD_CLAP_$(_MG))" \
	  "trans-wd-ri-clap=$(TRANS_WD_RI_CLAP_$(_MG))" \
	  "trans-ri-ps-clap=$(TRANS_RI_PS_CLAP_$(_MG))" \
	  "trans-ol-wd-drho=$(TRANS_OL_WD_DRHO_$(_MG))" \
	  "trans-wd-ri-drho=$(TRANS_WD_RI_DRHO_$(_MG))" \
	  "trans-ri-ps-drho=$(TRANS_RI_PS_DRHO_$(_MG))" \
	  "x0-slab=$(X0_SLAB)" \
	  "x1-slab=$(X1_SLAB)" \
	  "dx-slab=$(DX_SLAB)" \
	  "y0-slab=$(Y0_SLAB)" \
	  "y1-slab=$(Y1_SLAB)" \
	  "dy-slab=$(DY_SLAB)" \
	  "l-slab=$(L_SLAB)" \
	  "w-slab=$(W_SLAB)" \
	  "a-slab=$(A_SLAB)" \
	  "x0-plume=$(X0_PLUME)" \
	  "x1-plume=$(X1_PLUME)" \
	  "dx-plume=$(DX_PLUME)" \
	  "y0-plume=$(Y0_PLUME)" \
	  "y1-plume=$(Y1_PLUME)" \
	  "dy-plume=$(DY_PLUME)" \
	  "l-plume=$(L_PLUME)" \
	  "w-plume=$(W_PLUME)" \
	  "a-plume=$(A_PLUME)" \
	  "uid=$(2)"
endef

# --------------------------------------------------
# Check dependencies
# --------------------------------------------------
ifeq ($(shell command -v conda 2>/dev/null),)
  $(error !! ERROR: 'conda' not found in PATH)
endif

ifeq ($(shell conda info --envs | grep -q "$(CONDA_ENV)" && echo "exists"),)
  $(warning !! WARNING: Conda environment '$(CONDA_ENV)' not found)
  $(warning !!          Run 'make environments' to set up the workspace)
endif

ifeq ($(shell command -v Rscript 2>/dev/null),)
  $(error !! ERROR: 'Rscript' not found in PATH. This project requires R)
endif

# ifeq ($(shell command -v pandoc 2>/dev/null),)
#   $(error !! ERROR: 'pandoc' not found in PATH. Required for rendering the manuscript)
# endif

# --------------------------------------------------
# DEAL.II and ASPECT configuration
# --------------------------------------------------
# Check operating system
UNAME_SHELL := $(shell uname)
OS_SYSTEM   := $(shell [ -f /etc/os-release ] && . /etc/os-release && echo $$ID || echo unknown)

ASPECT_EXE     := $(ASPECT)/aspect-release
DEALII_VERSION := v9.7.0

ifeq ($(UNAME_SHELL), Darwin)
  # Install config
  DEALII_LIB       := $(DEALII)/deal.II-$(DEALII_VERSION)/lib/libdeal_II.dylib
  INSTALL_DEALII   := $(INSTALL)/dealii-macos.sh
  INSTALL_ASPECT   := $(INSTALL)/aspect-macos.sh
  TRILINOS_VERSION := AUTO

  # Run config
  RUN_ASPECT       := $(BASH)/simulation/run-aspect-macos.sh
  NTASKS           := 8
else ifeq ($(OS_SYSTEM), rocky)
  # Install config
  DEALII_LIB       := $(DEALII)/deal.II-$(DEALII_VERSION)/lib/libdeal_II.so
  INSTALL_DEALII   := $(INSTALL)/dealii-barkla2.sh
  INSTALL_ASPECT   := $(INSTALL)/aspect-barkla2.sh
  TRILINOS_VERSION := AUTO
  GCC              := gcc/14.2.0
  OPENMPI          := openmpi/5.0.8-gcc14.2.0
  OPENBLAS         := openblas/0.3.29/gcc-14.2.0
  CMAKE            := cmake/3.30.5-gcc14.2.0

  # Run config
  RUN_ASPECT       := $(BASH)/simulation/run-aspect-barkla2.sh
  NTASKS           := 128
  NTASKSPERNODE    := 168
  TIME             := 2-12:00:00
  MAIL_ADDRESS     := b.kerswell@liverpool.ac.uk
  MAIL_TYPE        := ALL
else
  $(error Unsupported OS: Only macOS and Rocky Linux are supported!)
endif

# --------------------------------------------------
# Logging
# --------------------------------------------------
DATE            := $(shell date +"%d-%m-%Y")
LOG_FILE        := .log/log-$(DATE).log
LOGGER          := 2>&1 | tee -a $(LOG_FILE)
SUPPRESS_STDERR := 2>/dev/null
SUPPRESS_STDOUT := > /dev/null

# --------------------------------------------------
# Safe removal macro
# --------------------------------------------------
define SAFE_RM
	if [ -e "$(1)" ]; then \
	  ABS_PATH=$$(realpath "$(1)"); \
	  if [[ "$$ABS_PATH" == $(PROJECT_ROOT)* ]]; then \
	    echo " xx $$ABS_PATH"; \
	    rm -rf "$$ABS_PATH"; \
	  fi; \
	fi
endef

# --------------------------------------------------
# Loop removal macro
# --------------------------------------------------
define SAFE_RM_LIST
	for item in $(1); do $(call SAFE_RM,$$item); done
endef
