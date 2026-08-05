#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import platform
import re
from dataclasses import dataclass, field
from pathlib import Path

from config import MeshConfig
from PIL import Image, ImageDraw, ImageFont


#######################################################
## .1. ImageTiler                                !!! ##
#######################################################
@dataclass
class ImageTiler:
    """Tiles per-field mesh plots side-by-side and saves the combined images.

    For each matching timestep across two or three field image sequences,
    optionally annotates each panel with a single-character tag, concatenates
    them horizontally, and saves the result to a 'tiles' subdirectory.
    """

    plot_config: MeshConfig
    out_fig_dir: Path
    field1: str
    field2: str
    field3: str | None = None
    tags: str | None = None  # Up to 3 characters, one per panel (e.g. "abc")
    fps: int = 10
    tag_size: int = 188  # Font size in points

    tiles_dir: Path = field(init=False)
    prefix: str = field(init=False)
    images_field1: list[Path] = field(init=False)
    images_field2: list[Path] = field(init=False)
    images_field3: list[Path] = field(init=False)
    fields_list: list[str] = field(init=False)
    field_file_maps: list[str | None] = field(init=False)
    tiled_images: list[Path] = field(default_factory=list, init=False)

    verbosity: int = 1

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def __post_init__(self) -> None:
        """Resolve output directories, image lists, and field ID maps."""
        self.tiles_dir = self.out_fig_dir / "tiles"
        self.prefix = str(self.out_fig_dir.name).replace("_", "-")

        self.fields_list = [self.field1, self.field2]
        if self.field3:
            self.fields_list.append(self.field3)

        self.images_field1 = self._get_images(self.field1)
        self.images_field2 = self._get_images(self.field2)
        self.images_field3 = self._get_images(self.field3) if self.field3 else []
        self.field_file_maps = [self.plot_config.file_map.get(f) for f in self.fields_list]

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_images(self, field: str | None) -> list[Path]:
        """Return sorted PNG paths for field in out_fig_dir, or [] if unmapped."""
        if not field:
            return []
        file_id = self.plot_config.file_map.get(field)
        if not file_id:
            return []
        return sorted(self.out_fig_dir.glob(f"{self.prefix}-{file_id}-*.png"))

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _extract_timestep(self, path: Path) -> str | None:
        """Return the zero-padded 4-digit timestep string from a filename, or None."""
        match = re.search(r"-(\d{4})\.png$", path.name)
        return match.group(1) if match else None

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _parse_tags(self) -> list[str | None]:
        """Return a list of three per-panel tag characters (or None) from self.tags.

        Pads with None if self.tags has fewer than three characters. Whitespace
        padding characters are normalised to None so they do not appear in
        annotations or filenames.
        """
        if self.tags is None:
            return [None, None, None]
        padded = self.tags.ljust(3)[:3]
        return [c.lower() if c.strip() else None for c in padded]

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_default_font(self) -> ImageFont.ImageFont | ImageFont.FreeTypeFont:
        """Return a bold TrueType font at tag_size points, falling back to the
        PIL default if no system font is found.
        """
        font_paths = {
            "Darwin": "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
            "Windows": "C:/Windows/Fonts/arialbd.ttf",
            "Linux": "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        }
        font_path = font_paths.get(platform.system())
        if font_path and Path(font_path).exists():
            try:
                return ImageFont.truetype(font_path, self.tag_size)
            except IOError:
                if self.verbosity >= 1:
                    print(f" !! Warning: failed to load truetype font at {font_path}.")

        if self.verbosity >= 1:
            print(" !! Warning: falling back to default font (tiny and non-scalable).")
        return ImageFont.load_default()

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _annotate_image(self, img_path: Path, tag: str | None) -> Image.Image:
        """Open an image, optionally draw a tag character in the top-left, and
        return it as an RGB image.

        Args:
            img_path: Path to the source PNG.
            tag:      Single character to draw, or None to skip annotation.

        Returns:
            RGB PIL Image with the tag drawn if provided.
        """
        image = Image.open(img_path).convert("RGB")
        if tag is None:
            return image
        draw = ImageDraw.Draw(image)
        draw.text((25, 10), tag, font=self._get_default_font(), fill="black")
        return image

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _concatenate_images_horizontally(self, images: list[Image.Image]) -> Image.Image:
        """Return a new RGB image with all images pasted side-by-side.

        The output height matches the tallest panel; narrower panels are
        top-aligned against a white background.

        Args:
            images: List of RGB PIL Images to concatenate.

        Returns:
            Combined RGB Image.
        """
        widths, heights = zip(*(img.size for img in images))
        combined = Image.new("RGB", (sum(widths), max(heights)), color=(255, 255, 255))
        x_offset = 0
        for img in images:
            combined.paste(img, (x_offset, 0))
            x_offset += img.size[0]
        return combined

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _build_tile_path(self, timestep: str, tags: list[str | None]) -> Path:
        """Construct the output path for a tiled image.

        Args:
            timestep: Zero-padded 4-digit timestep string.
            tags:     Per-panel tag list from _parse_tags.

        Returns:
            Destination Path inside self.tiles_dir.
        """
        field_ids = "-".join(fid for fid in self.field_file_maps if fid is not None)
        tag_chars = "".join(t for t in tags if t is not None)
        tag_suffix = f"-tagged-{tag_chars}" if tag_chars else ""
        return self.tiles_dir / f"{self.prefix}-{field_ids}-{timestep}{tag_suffix}.png"

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _tile_single(self, img1: Path, img2: Path, img3: Path | None, tags: list[str | None]) -> None:
        """Tile one matched set of per-field images and save the result.

        Validates timestep alignment, skips already-existing tiles, annotates
        each panel, concatenates, and writes to disk.

        Args:
            img1:  Path to the field1 image.
            img2:  Path to the field2 image.
            img3:  Path to the field3 image, or None.
            tags:  Per-panel tag characters from _parse_tags.
        """
        ts1 = self._extract_timestep(img1)
        ts2 = self._extract_timestep(img2)
        ts3 = self._extract_timestep(img3) if img3 else ts1

        if ts1 is None or ts2 is None or ts3 is None:
            if self.verbosity >= 1:
                print(f" !! Warning: failed to extract timestep ({ts1}, {ts2}, {ts3})")
            return

        if ts1 != ts2 or ts1 != ts3:
            if self.verbosity >= 1:
                print(f" !! Warning: timestep mismatch ({ts1}, {ts2}, {ts3})")
            return

        out_tile = self._build_tile_path(ts1, tags)

        if out_tile.exists():
            return

        panel_paths = [img1, img2] + ([img3] if img3 else [])
        annotated = [self._annotate_image(p, t) for p, t in zip(panel_paths, tags)]

        self.tiles_dir.mkdir(parents=True, exist_ok=True)
        combined = self._concatenate_images_horizontally(annotated)
        combined.save(out_tile)

        self.tiled_images.append(out_tile)
        print(f" -> {out_tile.name}")

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def tile_images(self) -> None:
        """Tile all matched timestep images across the configured fields.

        Iterates over paired image sequences, validates timestep alignment,
        and delegates each matched set to _tile_single. Results accumulate
        in self.tiled_images.
        """
        tags = self._parse_tags()

        for i, (img1, img2) in enumerate(zip(self.images_field1, self.images_field2)):
            img3 = self.images_field3[i] if self.field3 and i < len(self.images_field3) else None
            self._tile_single(img1, img2, img3, tags)
