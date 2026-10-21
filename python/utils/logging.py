"""Shared gutter logging for python scripts.

Glyphs live in the 4-char gutter only; continuation lines indent 4 spaces.
  " .. " info step | " -- " detail | " -> " artifact | " !! " warning | " XX " error | " xx " deletion
Lines wrap at screen width (shutil.get_terminal_size, fallback 80), except
progress bars which are fixed at 80 columns.

Colors (muted gutter, cyan steps, green artifacts, yellow warnings, red
errors) emit only when stdout is a tty and NO_COLOR is unset. Messages
are wrapped before color codes are added, so widths stay exact either way.
"""

import atexit
import os
import shutil
import sys
import textwrap
import threading

_PALETTE = {"muted": "90", "cyan": "36", "green": "32", "yellow": "33", "red": "31"}
_SPINNER_FRAMES = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"


def _color_enabled() -> bool:
    if os.environ.get("NO_COLOR", "") != "":
        return False
    try:
        return sys.stdout.isatty()
    except Exception:
        return False


def _paint(code: str, text: str) -> str:
    if code and _color_enabled():
        return f"\033[{_PALETTE.get(code, code)}m{text}\033[0m"
    return text


def _width() -> int:
    cols = os.environ.get("COLUMNS", "")
    if cols.isdigit() and int(cols) > 0:
        return max(int(cols), 40)
    # stdout is often piped (e.g. make | tee), so ask the controlling
    # terminal directly for the real screen width.
    try:
        with open("/dev/tty") as f:
            return max(os.get_terminal_size(f.fileno()).columns, 40)
    except Exception:
        pass
    try:
        return max(shutil.get_terminal_size(fallback=(80, 24)).columns, 40)
    except Exception:
        return 80


def _emit(glyph: str, msg: str, glyph_color: str = "muted", msg_color: str = "") -> None:
    width = max(_width() - 4, 20)
    out: list[str] = []
    for para in str(msg).split("\n"):
        for line in textwrap.wrap(para, width=width, break_long_words=False, break_on_hyphens=False) or [""]:
            if not out:
                out.append(f" {_paint(glyph_color, glyph)} {_paint(msg_color, line)}")
            else:
                out.append(f"    {line}")
    print("\n".join(out))


def log_info(msg: object) -> None:
    _emit("..", str(msg), msg_color="cyan")


def log_detail(msg: object) -> None:
    _emit("--", str(msg))


def log_artifact(path: object) -> None:
    _emit("->", _relpath(path), msg_color="green")


def log_warn(msg: object) -> None:
    _emit("!!", f"Warning: {msg}", glyph_color="yellow", msg_color="yellow")


def log_error(msg: object) -> None:
    _emit("XX", f"Error: {msg}", glyph_color="red", msg_color="red")


def log_delete(path: object) -> None:
    _emit("xx", str(path))


def _relpath(path: object) -> str:
    """Return path relative to PROJECT_ROOT when possible."""
    try:
        from pathlib import Path as _P

        p = _P(str(path))
        root = _P(str(__import__("os").environ.get("PROJECT_ROOT", "")))
        if str(root) and root in p.parents or p == root:
            return str(p.relative_to(root))
    except Exception:
        pass
    return str(path)


def gutter_tqdm(iterable, desc: str, unit: str = "model", ncols: int = 80):
    """tqdm with gutter prefix at fixed width (other logs use full screen width).

    Animation is disabled when stdout is piped (e.g. make | tee), where
    carriage-return redraws would be captured literally as garbled lines.
    """
    from tqdm import tqdm as _tqdm

    return _tqdm(
        iterable,
        desc=_paint("muted", " ..") + " " + _paint("cyan", desc),
        unit=unit,
        ncols=ncols,
        disable=not _color_enabled(),
        colour="cyan",
        ascii="─╸━",
        bar_format="{desc}: [{bar}] {n_fmt}/{total_fmt}",
    )


class Spinner:
    """Braille spinner for indeterminate work (silent unless terminal is live)."""

    def __init__(self, desc: str):
        self.desc = desc
        self.i = 0
        self.active = _color_enabled()

    def tick(self) -> None:
        if not self.active:
            return
        frame = _SPINNER_FRAMES[self.i % len(_SPINNER_FRAMES)]
        sys.stdout.write(f"\r{_paint('muted', ' ..')} {_paint('cyan', self.desc)} {frame} ")
        sys.stdout.flush()
        self.i += 1

    def done(self) -> None:
        if not self.active:
            return
        sys.stdout.write("\r" + " " * _width() + "\r")
        sys.stdout.flush()


# ---------------------------------------------------------------------------
# Native stderr filtering
# ---------------------------------------------------------------------------
# macOS graphics frameworks (Metal/CoreAnalytics) report a benign notice on
# stderr whenever a rendering context is torn down:
#   "Context leak detected, CoreAnalytics returned false"
# VTK builds a fresh off-screen render window per figure, so a full suite run
# trips this repeatedly and the notice lands in the middle of the tqdm bar.
# The renders themselves are unaffected -- the notice comes from Apple's own
# framework stack, not from VTK or pyvista -- and it is written by native
# code straight to file descriptor 2, so it never passes through Python.
# Dropping it therefore needs a descriptor-level filter rather than a
# sys.stderr wrapper. The pattern is matched without its trailing text
# because the wording of the tail varies between macOS releases.
_NATIVE_NOISE = (b"Context leak detected",)

_stderr_filter_installed = False


def _find_first(buf: bytes, start: int, patterns: tuple[bytes, ...]) -> int:
    """Index of the earliest pattern occurrence at or after start, or -1."""
    hit = -1
    for pat in patterns:
        idx = buf.find(pat, start)
        if idx != -1 and (hit == -1 or idx < hit):
            hit = idx
    return hit


def _partial_start(buf: bytes, start: int, patterns: tuple[bytes, ...]) -> int:
    """Index from which buf may still be the beginning of a pattern.

    Bytes from that index on are held back until more data arrives, so a
    pattern split across two reads is still matched. A pattern never spans a
    newline, so only the text after the last newline can be such a start.
    """
    region_start = buf.rfind(b"\n", start) + 1
    if region_start >= len(buf):
        return len(buf)

    region = buf[region_start:]
    best = len(buf)
    for pat in patterns:
        for k in range(min(len(pat) - 1, len(region)), 0, -1):
            if region.endswith(pat[:k]):
                best = min(best, region_start + len(region) - k)
                break
    return best


def _copy_filtered(read_fd: int, write_fd: int, patterns: tuple[bytes, ...]) -> None:
    """Copy read_fd to write_fd, dropping lines that carry a noisy pattern.

    Operates on raw bytes rather than whole lines so carriage-return progress
    bars keep streaming through untouched. Text before a match is kept and
    everything from the match to the end of its line is dropped, which leaves
    the progress bar that precedes the notice intact.
    """
    max_drop = 512
    buf = b""
    dropping = False

    while True:
        chunk = os.read(read_fd, 4096)
        if not chunk:
            break

        buf += chunk
        out = bytearray()
        start = 0

        while start < len(buf):
            if dropping:
                newline = buf.find(b"\n", start)
                if newline == -1:
                    if len(buf) - start <= max_drop:
                        break  # wait for the end of the noisy line
                    start += max_drop  # no newline: stop dropping here
                    dropping = False
                    continue
                start = newline + 1
                dropping = False
                continue

            hit = _find_first(buf, start, patterns)
            if hit == -1:
                break

            out += buf[start:hit]
            start = hit
            dropping = True

        if not dropping:
            tail = _partial_start(buf, start, patterns)
            out += buf[start:tail]
            start = tail

        buf = buf[start:]
        if out:
            os.write(write_fd, out)

    if buf and not dropping:
        os.write(write_fd, buf)


def install_stderr_filter(patterns: tuple[bytes, ...] = _NATIVE_NOISE) -> bool:
    """Suppress known native noise on stderr.

    Redirects file descriptor 2 through a pipe and copies it to the real
    stderr, dropping the rest of any line that contains one of `patterns`.
    Text before the match is kept, so a progress bar that shares the line
    with the notice survives. Returns True when the filter was installed,
    False when it was already active or the descriptors could not be set up.
    """
    global _stderr_filter_installed
    if _stderr_filter_installed or not patterns:
        return False

    try:
        saved = os.dup(2)
        read_fd, write_fd = os.pipe()
        os.dup2(write_fd, 2)
        os.close(write_fd)
    except OSError:
        return False

    _stderr_filter_installed = True
    worker = threading.Thread(target=_copy_filtered, args=(read_fd, saved, patterns), daemon=True)
    worker.start()

    def _restore() -> None:
        try:
            sys.stderr.flush()
        except Exception:
            pass
        try:
            # Restoring fd 2 drops the pipe's last write end, so the worker sees EOF.
            os.dup2(saved, 2)
            worker.join(timeout=5)
            os.close(saved)
        except Exception:
            pass

    atexit.register(_restore)
    return True
