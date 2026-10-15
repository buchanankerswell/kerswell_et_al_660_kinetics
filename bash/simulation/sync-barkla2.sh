#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 5 ]; then
    echo "    Usage: $0 <CONFIG_LIST> <PLUME_TIMESTEPS> <SLAB_TIMESTEPS> <LOCAL_SIM_DIR> <REMOTE_SIM_DIR>"
    exit 1
fi

# Read input arrays
read -r -a CONFIG_LIST <<<"$1"
read -r -a PLUME_TIMESTEPS <<<"$2"
read -r -a SLAB_TIMESTEPS <<<"$3"
LOCAL_SIM_DIR="$4"
REMOTE_SIM_DIR="$5"

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
SYNCED=0
SKIPPED=0
for prm_path in "${CONFIG_LIST[@]}"; do
    model_name="$(basename "$prm_path" .prm)"

    REMOTE_RESULTS_DIR="${REMOTE_SIM_DIR}/results/$model_name"
    REMOTE_SOLUTION_DIR="${REMOTE_RESULTS_DIR}/solution"
    LOCAL_RESULTS_DIR="${LOCAL_SIM_DIR}/results/$model_name"
    LOCAL_SOLUTION_DIR="${LOCAL_RESULTS_DIR}/solution"
    mkdir -p "$LOCAL_SOLUTION_DIR"

    # Build rsync filters for the model-type timesteps
    # Plumes sync at 50 Ma, slabs at 100 Ma.
    if [[ "$model_name" == plume_* ]]; then
        MODEL_TIMESTEPS=("${PLUME_TIMESTEPS[@]}")
    else
        MODEL_TIMESTEPS=("${SLAB_TIMESTEPS[@]}")
    fi

    # Skip models whose target timesteps are already present locally.
    # Set FORCE_SYNC=1 to re-sync everything.
    if [[ "${FORCE_SYNC:-0}" != "1" ]]; then
        model_complete=true
        for tstep in "${MODEL_TIMESTEPS[@]}"; do
            if ! compgen -G "$LOCAL_SOLUTION_DIR/solution-00*${tstep}.pvtu" > /dev/null; then
                model_complete=false
                break
            fi
            if ! compgen -G "$LOCAL_SOLUTION_DIR/solution-00*${tstep}.*.vtu" > /dev/null; then
                model_complete=false
                break
            fi
        done
        if $model_complete; then
            echo " .. Skipping $model_name (already synced)"
            SKIPPED=$((SKIPPED + 1))
            continue
        fi
    fi

    echo " .. Syncing $model_name"
    RSYNC_FILTERS=()
    for tstep in "${MODEL_TIMESTEPS[@]}"; do
        RSYNC_FILTERS+=(--include="solution-00*${tstep}.*.vtu")
        RSYNC_FILTERS+=(--include="solution-00*${tstep}.pvtu")
    done
    RSYNC_FILTERS+=(--include="*/" --exclude="*") # include dirs, exclude everything else

    # Run a single rsync per model
    rsync "${RSYNC_OPTS[@]}" "${RSYNC_FILTERS[@]}" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_SOLUTION_DIR}/" "$LOCAL_SOLUTION_DIR/" 2>/dev/null | sed 's/^/    /' || true
    SYNCED=$((SYNCED + 1))
done

echo " .. Synced: $SYNCED, skipped: $SKIPPED"
