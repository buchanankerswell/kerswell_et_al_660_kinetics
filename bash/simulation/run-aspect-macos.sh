#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/log.sh"

if [ $# -ne 3 ]; then
  log_warn "Usage: $0 <NTASKS> <ASPECT_EXEC> <CONFIG_FILE>"
  exit 1
fi

NTASKS=$1
ASPECT_EXEC=$2
CONFIG_FILE=$3

date_start=$(date +%s)
log_info "MacOS job submitted: $(date)"
log_detail "Hostname: $(hostname)"
log_detail "Current directory: $(pwd)"
log_detail "Config file: $CONFIG_FILE"
log_detail "Job user: $USER"
log_detail "Number of processors: $NTASKS"
log_detail "CPU architecture: $(uname -m)"
log_detail "Operating System: $(uname)"
log_detail "MacOS Version: $(sw_vers -productVersion)"
log_info "Job output begins ..."
pkill -f mpirun || true && sleep 5
mpirun -np "$NTASKS" "$ASPECT_EXEC" "$CONFIG_FILE" 2>&1 | log_pipe
EXIT_CODE=$?
log_info "Job output ends ..."
date_end=$(date +%s)
seconds=$((date_end - date_start))
minutes=$((seconds / 60))
seconds=$((seconds - 60 * minutes))
hours=$((minutes / 60))
minutes=$((minutes - 60 * hours))
log_info "MacOS job finished: $(date)"
log_detail "Total run time: $hours Hours $minutes Minutes $seconds Seconds"

if [ $EXIT_CODE -eq 0 ]; then
  RUN_FILE="${CONFIG_FILE%.prm}.run"
  touch "$RUN_FILE"
  log_artifact "$RUN_FILE"
else
  log_warn "ASPECT run failed with exit code $EXIT_CODE. No .run file created."
fi
