#!/usr/bin/env bash

if [ $# -ne 3 ]; then
  echo "    Usage: $0 <NTASKS> <ASPECT_EXEC> <CONFIG_FILE>"
  exit 1
fi

NTASKS=$1
ASPECT_EXEC=$2
CONFIG_FILE=$3

date_start=$(date +%s)
echo "    ========================================================="
echo "    MacOS job: submitted date = $(date)"
echo "    Hostname: $(hostname)"
echo "    Current directory: $(pwd)"
echo "    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "    Config file          : $CONFIG_FILE"
echo "    Job user             : $USER"
echo "    Number of processors : $NTASKS"
echo "    CPU architecture     : $(uname -m)"
echo "    Operating System     : $(uname)"
echo "    MacOS Version        : $(sw_vers -productVersion)"
echo "    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "    Job output begins ..."
echo "    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
pkill -f mpirun || true && sleep 5
mpirun -np "$NTASKS" "$ASPECT_EXEC" "$CONFIG_FILE" 2>&1 | sed 's/^/    /'
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
echo "    MacOS job: finished date = $(date)"
echo "    Total run time : $hours Hours $minutes Minutes $seconds Seconds"
echo "    ========================================================="

if [ $EXIT_CODE -eq 0 ]; then
  RUN_FILE="${CONFIG_FILE%.prm}.run"
  touch "$RUN_FILE"
  echo "    Run completed successfully. Created $RUN_FILE"
else
  echo "    ASPECT run failed with exit code $EXIT_CODE. No .run file created."
fi
