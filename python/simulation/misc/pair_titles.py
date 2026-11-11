"""Stack three composition tiles vertically with centered title bars.

Renders title text (including matplotlib mathtext) with matplotlib's bundled
DejaVuSans and composites with PIL, avoiding ImageMagick freetype entirely.
"""

import argparse
import re
from pathlib import Path

import matplotlib
import numpy as np
from matplotlib.backends.backend_agg import FigureCanvasAgg
from matplotlib.figure import Figure
from PIL import Image, ImageDraw, ImageFont


def render_title(text: str, width: int, height: int) -> Image.Image:
    if "$" in text:
        dpi = 100
        fig = Figure(figsize=(width / dpi, height / dpi), dpi=dpi, facecolor="white")
        canvas = FigureCanvasAgg(fig)
        fontsize = max(10, int(width * 0.025 * 72.0 / dpi))
        fig.text(0.5, 0.5, text, ha="center", va="center", fontsize=fontsize, color="black")
        canvas.draw()
        buf = np.asarray(canvas.buffer_rgba())[:, :, :3]
        return Image.fromarray(buf)

    img = Image.new("RGB", (width, height), "white")
    draw = ImageDraw.Draw(img)
    mpl_fonts = Path(matplotlib.__file__).parent / "mpl-data" / "fonts" / "ttf"
    candidates = ["DejaVuSans.ttf", "DejaVuSans-Bold.ttf"]
    font = None
    size = max(10, int(width * 0.028))
    for name in candidates:
        path = mpl_fonts / name
        if path.exists():
            try:
                font = ImageFont.truetype(str(path), size)
            except OSError:
                continue
            break
    if font is None:
        font = ImageFont.load_default()
    bbox = draw.textbbox((0, 0), text, font=font)
    draw.text(((width - (bbox[2] - bbox[0])) / 2, (height - (bbox[3] - bbox[1])) / 2 - bbox[1]), text, fill="black", font=font)
    return img


def format_exp(val_str: str) -> str:
    m = re.match(r"^([0-9.]+)e([+-]?[0-9]+)$", val_str)
    if not m:
        return val_str
    mant, exp = m.group(1), int(m.group(2))
    return f"{mant}e{exp}"


def title_from_tile_path(tile_path: str) -> str:
    name = Path(tile_path).name
    m_zri = re.search(r"Zri([0-9.]+e[+-]?[0-9]+)", name)
    m_therm = re.search(r"EtaTherm([0-9]+)", name)
    m_trans = re.search(r"EtaTrans1-1-1-([0-9]+)", name)
    m_vel = re.search(r"Vel([0-9]+)e-02", name)
    m_temp = re.search(r"Temp([0-9]+)e\+02", name)

    zri = format_exp(m_zri.group(1)) if m_zri else "?"
    B = int(m_therm.group(1)) if m_therm else 5
    b = int(m_trans.group(1)) if m_trans else 1
    vel = int(m_vel.group(1)) if m_vel else 5
    temp = int(m_temp.group(1)) if m_temp else 5

    suite = "SW" if temp == 5 else "NC"
    dt = -temp * 100
    offset = 0 if temp == 5 else 8
    vel_i = 0 if vel == 5 else 1
    therm_j = 0 if B == 5 else 1
    trans_k = 0 if b == 50 else 1
    scen = trans_k * 4 + vel_i * 2 + therm_j + offset

    return (
        f"{suite} (Scenario {scen}):  "
        f"$\\Delta T_0 = {dt}$ K,  "
        f"$\\vec{{u}}_\\mathrm{{in}} = {vel}$ cm/yr,  "
        f"$B = {B}$,  $b = {b}$,  "
        f"$Z_\\mathrm{{ri}} =$ {zri}"
    )


def stack_with_titles(tile_paths: list[str], titles: list[str], out_path: str, crop_pct: float = 9.0) -> None:
    rows = []
    for p in tile_paths:
        img = Image.open(p).convert("RGB")
        w, h = img.size
        crop = int(h * crop_pct / 100.0)
        rows.append(img.crop((0, 0, w, h - crop)))

    width = rows[0].size[0]
    rows = [
        r if r.size[0] == width else r.resize((width, int(r.size[1] * width / r.size[0])), Image.LANCZOS)
        for r in rows
    ]

    title_h = max(20, int(width * 0.045))
    title_imgs = [render_title(t, width, title_h) for t in titles]

    total_h = sum(t.size[1] + r.size[1] for t, r in zip(title_imgs, rows))
    canvas = Image.new("RGB", (width, total_h), "white")
    y = 0
    for t_img, r_img in zip(title_imgs, rows):
        canvas.paste(t_img, (0, y))
        y += t_img.size[1]
        canvas.paste(r_img, (0, y))
        y += r_img.size[1]
    Path(out_path).parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out_path)


def parse_arguments():
    parser = argparse.ArgumentParser(description="Add titles to a slab triplet montage.")
    parser.add_argument("tiles", nargs="+", type=str, help="Tile image paths followed by output path")
    parser.add_argument("--crop-pct", type=float, default=9.0)
    return parser.parse_args()


def main() -> None:
    args = parse_arguments()
    if len(args.tiles) != 4:
        raise SystemExit("Usage: tile1 tile2 tile3 out")
    tile_paths = args.tiles[:3]
    out_path = args.tiles[3]
    titles = [title_from_tile_path(p) for p in tile_paths]
    stack_with_titles(tile_paths, titles, out_path, crop_pct=args.crop_pct)


if __name__ == "__main__":
    main()
