#!/usr/bin/bash -l

if [ $# -ne 2 ]; then
  echo "    Usage: $0 <ASPECT_EXEC> <CONFIG_FILE>"
  exit 1
fi

ASPECT_EXEC=$1
CONFIG_FILE=$2

GCC=gcc/14.2.0
OPENMPI=openmpi/5.0.8-gcc14.2.0
OPENBLAS=openblas/0.3.29/gcc-14.2.0
CMAKE=cmake/3.30.5-gcc14.2.0

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

echo "    ========================================================="
echo "    SLURM job: submitted  date = $(date)"
date_start=$(date +%s)
hostname
echo "    Current directory: $(pwd)"
echo "    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "    Config file                : $CONFIG_FILE"
echo "    Job name                   : $SLURM_JOB_NAME"
echo "    Job ID                     : $SLURM_JOB_ID"
echo "    Job user                   : $SLURM_JOB_USER"
echo "    Job array index            : $SLURM_ARRAY_TASK_ID"
echo "    Submit directory           : $SLURM_SUBMIT_DIR"
echo "    Submit host                : $SLURM_SUBMIT_HOST"
echo "    Queue/Partition name       : $SLURM_JOB_PARTITION"
echo "    Node list                  : $SLURM_JOB_NODELIST"
echo "    Hostname of 1st node       : $HOSTNAME"
echo "    Number of nodes allocated  : $SLURM_JOB_NUM_NODES"
echo "    Number of tasks            : $SLURM_NTASKS"
echo "    Number of tasks per node   : $SLURM_TASKS_PER_NODE"
echo "    Initiated tasks per node   : $SLURM_NTASKS_PER_NODE"
echo "    Requested CPUs per task    : $SLURM_CPUS_PER_TASK"
echo "    Requested CPUs on the node : $SLURM_CPUS_ON_NODE"
echo "    Scheduling priority        : $SLURM_PRIO_PROCESS"
echo "    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "    Job output begins ..."
echo "    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
mpirun -np "$SLURM_NTASKS" "$ASPECT_EXEC" "$CONFIG_FILE"
EXIT_CODE=$?
echo "    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "    Job output ends ..."
date_end=$(date +%s)
seconds=$((date_end - date_start))
minutes=$((seconds / 60))
seconds=$((seconds - 60 * minutes))
hours=$((minutes / 60))
minutes=$((minutes - 60 * hours))
echo "    ========================================================="
echo "    SLURM job: finished date = $(date)"
echo "    Total run time : $hours Hours $minutes Minutes $seconds Seconds"
echo "    ========================================================="

if [ $EXIT_CODE -eq 0 ]; then
  RUN_FILE="${CONFIG_FILE%.prm}.run"
  touch "$RUN_FILE"
  echo "    Run completed successfully. Created $RUN_FILE"
else
  echo "    ASPECT run failed with exit code $EXIT_CODE. No .run file created."
fi
