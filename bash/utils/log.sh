#!/usr/bin/env bash
# Shared gutter logging for bash scripts.
# Glyphs live in the 4-char gutter only; continuation lines indent 4 spaces.
#   " .. " info step | " -- " detail | " -> " artifact | " !! " warning | " XX " error
# Lines wrap at screen width ($COLUMNS, else tput cols, else 80).
# Colors (dim gutter, cyan steps, green artifacts, yellow warnings, red
# errors) emit only on a tty without NO_COLOR. Lines wrap before color
# codes are added, so widths stay exact either way.

_log_width() {
  if [[ -n "${COLUMNS:-}" ]]; then
    printf '%s' "$COLUMNS"
    return
  fi
  # stdout is often piped (e.g. make | tee), so ask the controlling
  # terminal directly for the real screen width.
  local tty_cols
  tty_cols=$( { stty size < /dev/tty 2>/dev/null; } 2>/dev/null | awk '{print $2}')
  if [[ "$tty_cols" =~ ^[0-9]+$ ]] && ((tty_cols > 0)); then
    printf '%s' "$tty_cols"
    return
  fi
  tput cols 2>/dev/null || printf '80'
}

_log_use_color() { [[ -t 1 && -z "${NO_COLOR:-}" ]]; }

# Evaluated once per emit in the calling shell: inside $(...) fd 1 is a
# capture pipe, so the tty check must not run there.
_LOG_COLOR=0

_log_paint() {
  if [[ "$_LOG_COLOR" == 1 && -n "$1" ]]; then
    printf '\033[%sm%s\033[0m' "$1" "$2"
  else
    printf '%s' "$2"
  fi
}

_log_emit() {
  local glyph="$1" gcol="$2" mcol="$3"
  shift 3
  local msg="$*"
  if _log_use_color; then _LOG_COLOR=1; else _LOG_COLOR=0; fi
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
        printf ' %s %s\n' "$(_log_paint "$gcol" "$glyph")" "$(_log_paint "$mcol" "$chunk")"
        first=0
      else
        printf '    %s\n' "$chunk"
      fi
      line="${line:${#chunk}}"
      line="${line# }"
    done
    if ((first)); then
      printf ' %s %s\n' "$(_log_paint "$gcol" "$glyph")" "$(_log_paint "$mcol" "$line")"
      first=0
    else
      printf '    %s\n' "$line"
    fi
  done <<<"$msg"
}

log_info() { _log_emit ".." "2" "36" "$*"; }
log_detail() { _log_emit "--" "2" "" "$*"; }
log_artifact() {
  local p="$*"
  if [[ -n "${PROJECT_ROOT:-}" && "$p" == "$PROJECT_ROOT"* ]]; then
    p="${p#$PROJECT_ROOT/}"
  fi
  _log_emit "->" "2" "32" "$p"
}
log_warn() { _log_emit "!!" "33" "33" "Warning: $*"; }
log_error() { _log_emit "XX" "31" "31" "Error: $*"; }

# Indent piped tool output as gutter-blank continuations.
log_pipe() { sed 's/^/    /'; }
