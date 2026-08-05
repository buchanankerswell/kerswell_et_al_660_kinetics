#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ $# -ne 7 ]; then
  echo "    Usage: $0 <FIG_DIR> <OUT_DIR> <TIMESTEP> <BATCH_NAME> <ID1> <ID2> <ID3>"
  exit 1
fi

FIG_DIR="$1"
OUT_DIR="$2"
TIMESTEP="$3"
BATCH="$4"
ID1="$5"
ID2="$6"
ID3="$7"
Y_CROP=9

mkdir -p "${OUT_DIR}"

compose_figures() {
  local TYPE="$1"
  local MODE="$2"
  local SUFFIX="$3"
  local OUT_NAME="$4"

  local OUT_PATH="${OUT_DIR}/${OUT_NAME}-${BATCH}-${TIMESTEP}.png"

  if [[ -f "$OUT_PATH" ]]; then
    return
  fi

  echo " -> ${OUT_PATH}"

  if [[ "$MODE" == "triple" ]]; then
    local DIR1="${TYPE}_${ID1}"
    local DIR2="${TYPE}_${ID2}"
    local DIR3="${TYPE}_${ID3}"

    local FILE_ID1="${ID1//_/-}"
    local FILE_ID2="${ID2//_/-}"
    local FILE_ID3="${ID3//_/-}"

    local FILE1="${TYPE}-${FILE_ID1}"
    local FILE2="${TYPE}-${FILE_ID2}"
    local FILE3="${TYPE}-${FILE_ID3}"

    for f in \
      "${FIG_DIR}/${DIR1}/tiles/${FILE1}-${SUFFIX}-${TIMESTEP}.png" \
      "${FIG_DIR}/${DIR2}/tiles/${FILE2}-${SUFFIX}-${TIMESTEP}.png" \
      "${FIG_DIR}/${DIR3}/tiles/${FILE3}-${SUFFIX}-${TIMESTEP}.png"; do
      [[ -f "$f" ]] || exit 0
    done

    magick \
      \( "${FIG_DIR}/${DIR1}/tiles/${FILE1}-${SUFFIX}-${TIMESTEP}.png" -gravity south -chop "0x${Y_CROP}%" \) \
      \( "${FIG_DIR}/${DIR2}/tiles/${FILE2}-${SUFFIX}-${TIMESTEP}.png" -gravity south -chop "0x${Y_CROP}%" \) \
      \( "${FIG_DIR}/${DIR3}/tiles/${FILE3}-${SUFFIX}-${TIMESTEP}.png" -gravity south -chop "0x${Y_CROP}%" \) \
      -append "${OUT_PATH}" || true
  fi
}

COMP_SETS=(
  "set1:temperature-nonadiabatic-density-nonadiabatic-velocity-vertical"
  "set2:temperature-nonadiabatic-viscosity-X-ps"
  "set3:another-composition-suffix-here"
)

for TYPE in "slab" "plume"; do
  for ITEM in "${COMP_SETS[@]}"; do
    SET_NAME="${ITEM%%:*}"
    SUFFIX="${ITEM#*:}"

    OUT_NAME="${TYPE}-${SET_NAME}-composition"

    compose_figures "$TYPE" "triple" "$SUFFIX" "$OUT_NAME"
  done
done
