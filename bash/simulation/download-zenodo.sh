#!/usr/bin/env bash
# Fetch archived datasets from Zenodo and extract them at the project root.
# The concept DOI always resolves to the latest published version; the
# resolved version record is logged so builds record what they fetched.
# Skips files whose contents are already present unless FORCE=1.
#
# Usage: download-zenodo.sh <concept-doi> <project-root> "<tarball ...>" [force]
set -euo pipefail

DOI="${1:?usage: download-zenodo.sh <concept-doi> <project-root> \"<tarball ...>\" [force]}"
PROJECT_ROOT="${2:?usage: download-zenodo.sh <concept-doi> <project-root> \"<tarball ...>\" [force]}"
FILES="${3:?usage: download-zenodo.sh <concept-doi> <project-root> \"<tarball ...>\" [force]}"
FORCE="${4:-0}"

# shellcheck disable=SC1091
. "$(dirname "$0")/../utils/log.sh"

RESOLVED_URL="$(curl -fsSL -o /dev/null -w '%{url_effective}' "https://doi.org/${DOI}")"
RECID="${RESOLVED_URL##*/}"
BASE_URL="https://zenodo.org/api/records/${RECID}/files"
log_detail "Resolved ${DOI} to version record ${RECID}"

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

complete() {
  [ -f "${PROJECT_ROOT}/simulation/data/postprocessed.csv" ] &&
    [ "$(find "${PROJECT_ROOT}/simulation/results" -maxdepth 1 -name 'slab_*' 2>/dev/null | wc -l)" -ge 132 ]
}

if [ "${FORCE}" != "1" ] && complete; then
  log_info "Found local data (132 models + postprocessed.csv), skipping download"
  exit 0
fi

STAGE="$(mktemp -d "${TMPDIR:-/tmp}/zenodo-download.XXXXXX")"
trap 'rm -rf "${STAGE}"' EXIT

log_info "Downloading archived data from ${DOI} (record ${RECID})"
curl -fSL --retry 3 "${BASE_URL}/SHA256SUMS/content" -o "${STAGE}/SHA256SUMS"
for f in ${FILES}; do
  log_detail "Fetching ${f}"
  curl -fSL --retry 3 "${BASE_URL}/${f}/content" -o "${STAGE}/${f}"
done

log_info "Verifying checksums"
for f in ${FILES}; do
  expected="$(awk -v name="${f}" '$2 == name {print $1}' "${STAGE}/SHA256SUMS")"
  actual="$(sha256_file "${STAGE}/${f}")"
  [ "${actual}" = "${expected}" ] || { log_error "checksum mismatch: ${f}"; exit 1; }
done

log_info "Extracting to ${PROJECT_ROOT}"
for f in ${FILES}; do
  tar -xzf "${STAGE}/${f}" -C "${PROJECT_ROOT}"
  log_artifact "${f}"
done
