#!/usr/bin/env bash
# Shared gutter logging for bash scripts.
# Glyphs live in the 4-char gutter only; continuation lines indent 4 spaces.
#   " .. " info step | " -- " detail | " -> " artifact | " !! " warning/error
# Lines wrap at screen width ($COLUMNS, else tput cols, else 80).

_log_width() {
  if [[ -n "${COLUMNS:-}" ]]; then
    printf '%s' "$COLUMNS"
  else
    tput cols 2>/dev/null || printf '80'
  fi
}

_log_emit() {
  local glyph="$1"
  shift
  local msg="$*"
  local width
  width=$(($(_log_width) - 4))
  ((width < 20)) && width=20
  local line first=1
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -z "$line" ]]; then
      first=0
      continue
    fi
    while ((${#line} > width)); do
      local chunk="${line:0:$width}"
      chunk="${chunk% *}"
      [[ "$chunk" == "${line:0:$width}" ]] && chunk="${line:0:$width}"
      if ((first)); then
        printf ' %s %s\n' "$glyph" "$chunk"
        first=0
      else
        printf '    %s\n' "$chunk"
      fi
      line="${line:${#chunk}}"
      line="${line# }"
    done
    if ((first)); then
      printf ' %s %s\n' "$glyph" "$line"
      first=0
    else
      printf '    %s\n' "$line"
    fi
  done <<<"$msg"
}

log_info() { _log_emit ".." "$*"; }
log_detail() { _log_emit "--" "$*"; }
log_artifact() { _log_emit "->" "$*"; }
log_warn() { _log_emit "!!" "$*"; }

# Indent piped tool output as gutter-blank continuations.
log_pipe() { sed 's/^/    /'; }
