"""Shared gutter logging for python scripts.

Glyphs live in the 4-char gutter only; continuation lines indent 4 spaces.
  " .. " info step | " -- " detail | " -> " artifact | " !! " warning | " XX " error
Lines wrap at screen width (shutil.get_terminal_size, fallback 80).
"""

import os
import shutil
import sys
import textwrap


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


def _emit(glyph: str, msg: str) -> None:
    width = max(_width() - 4, 20)
    out: list[str] = []
    for para in str(msg).split("\n"):
        for line in textwrap.wrap(para, width=width, break_long_words=False, break_on_hyphens=False) or [""]:
            out.append(f" {glyph} {line}" if not out else f"    {line}")
    print("\n".join(out))


def log_info(msg: object) -> None:
    _emit("..", str(msg))


def log_detail(msg: object) -> None:
    _emit("--", str(msg))


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


def log_artifact(path: object) -> None:
    _emit("->", _relpath(path))


def log_warn(msg: object) -> None:
    _emit("!!", f"Warning: {msg}")


def log_error(msg: object) -> None:
    _emit("XX", f"Error: {msg}")


def gutter_tqdm(iterable, desc: str, unit: str = "model", ncols: int = 150):
    """tqdm with gutter prefix at fixed width (other logs use full screen width).

    Animation is disabled when stdout is piped (e.g. make | tee), where
    carriage-return redraws would be captured literally as garbled lines.
    """
    from tqdm import tqdm as _tqdm

    return _tqdm(
        iterable,
        desc=f" .. {desc}",
        unit=unit,
        ncols=ncols,
        disable=not sys.stdout.isatty(),
        bar_format="{desc}: [{bar}] {n_fmt}/{total_fmt}",
    )
