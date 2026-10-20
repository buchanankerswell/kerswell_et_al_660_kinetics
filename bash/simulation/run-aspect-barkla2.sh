#!/usr/bin/bash -l

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -r "${LOG_SH:-}" ]]; then
  for candidate in "${PROJECT_ROOT:-}/bash/utils/log.sh" "$SCRIPT_DIR/../utils/log.sh"; do
    [[ -r "$candidate" ]] && { LOG_SH="$candidate"; break; }
  done
fi

if [[ -r "${LOG_SH:-}" ]]; then
  source "$LOG_SH"
else
  printf ' !! log helpers not found (LOG_SH=%s); using plain output\n' "${LOG_SH:-unset}" >&2
  log_info() { printf ' .. %s\n' "$*"; }
  log_detail() { printf ' -- %s\n' "$*"; }
  log_artifact() { printf ' -> %s\n' "$*"; }
  log_warn() { printf ' !! %s\n' "$*"; }
  log_error() { printf ' XX %s\n' "$*"; }
fi

if [ $# -ne 2 ] && [ $# -ne 6 ]; then
  log_warn "Usage: $0 <ASPECT_EXEC> <CONFIG_FILE> [GCC] [OPENMPI] [OPENBLAS] [CMAKE]"
  exit 1
fi

ASPECT_EXEC=$1
CONFIG_FILE=$2
GCC=${3:-gcc/14.2.0}
OPENMPI=${4:-openmpi/5.0.8-gcc14.2.0}
OPENBLAS=${5:-openblas/0.3.29/gcc-14.2.0}
CMAKE=${6:-cmake/3.30.5-gcc14.2.0}

module purge
module load $GCC $OPENMPI $OPENBLAS $CMAKE
module list

# Ensure GCC 14.2.0 runtime libraries are found before GCC 11
GCC_DIR="$(dirname "$(dirname "$(which gcc)")")"
export LD_LIBRARY_PATH=$GCC_DIR/lib64:$GCC_DIR/lib:$LD_LIBRARY_PATH

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

ulimit -s unlimited

export CC=mpicc
export CXX=mpicxx
export FC=mpif90
export FF=mpif77

log_info "SLURM job submitted: $(date)"
date_start=$(date +%s)
log_detail "Hostname: $(hostname)"
log_detail "Current directory: $(pwd)"
log_detail "Config file: $CONFIG_FILE"
log_detail "Job name: $SLURM_JOB_NAME"
log_detail "Job ID: $SLURM_JOB_ID"
log_detail "Job user: $SLURM_JOB_USER"
log_detail "Job array index: $SLURM_ARRAY_TASK_ID"
log_detail "Submit directory: $SLURM_SUBMIT_DIR"
log_detail "Submit host: $SLURM_SUBMIT_HOST"
log_detail "Queue/Partition name: $SLURM_JOB_PARTITION"
log_detail "Node list: $SLURM_JOB_NODELIST"
log_detail "Hostname of 1st node: $HOSTNAME"
log_detail "Number of nodes allocated: $SLURM_JOB_NUM_NODES"
log_detail "Number of tasks: $SLURM_NTASKS"
log_detail "Number of tasks per node: $SLURM_TASKS_PER_NODE"
log_detail "Initiated tasks per node: $SLURM_NTASKS_PER_NODE"
log_detail "Requested CPUs per task: $SLURM_CPUS_PER_TASK"
log_detail "Requested CPUs on the node: $SLURM_CPUS_ON_NODE"
log_detail "Scheduling priority: $SLURM_PRIO_PROCESS"
log_info "Job output begins ..."
mpirun -np "$SLURM_NTASKS" "$ASPECT_EXEC" "$CONFIG_FILE"
EXIT_CODE=$?
log_info "Job output ends ..."
date_end=$(date +%s)
seconds=$((date_end - date_start))
minutes=$((seconds / 60))
seconds=$((seconds - 60 * minutes))
hours=$((minutes / 60))
minutes=$((minutes - 60 * hours))
log_info "SLURM job finished: $(date)"
log_detail "Total run time: $hours Hours $minutes Minutes $seconds Seconds"

if [ $EXIT_CODE -eq 0 ]; then
  RUN_FILE="${CONFIG_FILE%.prm}.run"
  touch "$RUN_FILE"
  log_artifact "$RUN_FILE"
else
  log_error "ASPECT run failed with exit code $EXIT_CODE. No .run file created."
fi
