"""Shared gutter logging for python scripts.

Glyphs live in the 4-char gutter only; continuation lines indent 4 spaces.
  " .. " info step | " -- " detail | " -> " artifact | " !! " warning | " XX " error | " xx " deletion
Lines wrap at screen width (shutil.get_terminal_size, fallback 80), except
progress bars which are fixed at 80 columns.

Colors (dim gutter, cyan steps, green artifacts, yellow warnings, red
errors) emit only when stdout is a tty and NO_COLOR is unset. Messages
are wrapped before color codes are added, so widths stay exact either way.
"""

import os
import shutil
import sys
import textwrap

_PALETTE = {"dim": "2", "cyan": "36", "green": "32", "yellow": "33", "red": "31"}
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


def _emit(glyph: str, msg: str, glyph_color: str = "dim", msg_color: str = "") -> None:
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
        desc=_paint("dim", " ..") + " " + _paint("cyan", desc),
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
        sys.stdout.write(f"\r{_paint('dim', ' ..')} {_paint('cyan', self.desc)} {frame} ")
        sys.stdout.flush()
        self.i += 1

    def done(self) -> None:
        if not self.active:
            return
        sys.stdout.write("\r" + " " * _width() + "\r")
        sys.stdout.flush()
