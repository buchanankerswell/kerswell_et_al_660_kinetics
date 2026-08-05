#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 4 ]; then
    echo "    Usage: $0 <CONFIG_LIST> <TIMESTEP_LIST> <LOCAL_SIM_DIR> <REMOTE_SIM_DIR>"
    exit 1
fi

# Read input arrays
read -r -a CONFIG_LIST <<<"$1"
read -r -a TIMESTEP_LIST <<<"$2"
LOCAL_SIM_DIR="$3"
REMOTE_SIM_DIR="$4"

# Remote details
REMOTE_USER="kersweb"
REMOTE_HOST="barklaviz2.liv.ac.uk"

# SSH with ControlMaster to reduce overhead
CONTROL_SOCKET="$HOME/.ssh/cm_socket_%h_%p_%r"
SSH_BASE=(ssh -o ControlMaster=auto -o ControlPersist=15m -o ControlPath="$CONTROL_SOCKET")

# rsync options: archive, compression, filename-only output
RSYNC_OPTS=(-az --out-format='%f' -e "${SSH_BASE[*]}")

echo " .. Establishing SSH multiplexed connection"
"${SSH_BASE[@]}" -MNf "${REMOTE_USER}@${REMOTE_HOST}" 2>&1 | sed 's/^/    /'

# Sync .run files
REMOTE_CONFIGS_DIR="${REMOTE_SIM_DIR}/configs"
LOCAL_CONFIGS_DIR="${LOCAL_SIM_DIR}/configs"
mkdir -p "$LOCAL_CONFIGS_DIR"

echo " .. Syncing .run files"
rsync "${RSYNC_OPTS[@]}" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_CONFIGS_DIR}/*.run" "$LOCAL_CONFIGS_DIR/" 2>/dev/null | sed 's/^/    /' || true

# Loop over models
for prm_path in "${CONFIG_LIST[@]}"; do
    model_name="$(basename "$prm_path" .prm)"

    REMOTE_RESULTS_DIR="${REMOTE_SIM_DIR}/results/$model_name"
    REMOTE_SOLUTION_DIR="${REMOTE_RESULTS_DIR}/solution"
    LOCAL_RESULTS_DIR="${LOCAL_SIM_DIR}/results/$model_name"
    LOCAL_SOLUTION_DIR="${LOCAL_RESULTS_DIR}/solution"
    mkdir -p "$LOCAL_SOLUTION_DIR"

    echo " .. Syncing $model_name"

    # Build rsync filters for the specific timesteps
    RSYNC_FILTERS=()
    for tstep in "${TIMESTEP_LIST[@]}"; do
        RSYNC_FILTERS+=(--include="solution-00*${tstep}.*.vtu")
        RSYNC_FILTERS+=(--include="solution-00*${tstep}.pvtu")
    done
    RSYNC_FILTERS+=(--include="*/" --exclude="*") # include dirs, exclude everything else

    # Run a single rsync per model
    rsync "${RSYNC_OPTS[@]}" "${RSYNC_FILTERS[@]}" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_SOLUTION_DIR}/" "$LOCAL_SOLUTION_DIR/" 2>/dev/null | sed 's/^/    /' || true
done
