#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import argparse
import math
from dataclasses import dataclass


#######################################################
## .1. Geometry                              !!! ##
#######################################################
@dataclass(frozen=True)
class Geometry:
    """Container for calculated ASPECT geometry parameters (Slab or Plume)."""

    x0: float
    y0: float
    x1: float
    y1: float
    dx: float
    dy: float
    sigma_w: float


def parse_args() -> argparse.Namespace:
    """Handles command-line argument parsing."""
    parser = argparse.ArgumentParser(description="Derive ASPECT geometry constants.")

    parser.add_argument("mode", choices=["slab", "plume"], help="Type of geometry to calculate")
    parser.add_argument("x0", type=float, help="x coordinate [m]")
    parser.add_argument("y0", type=float, help="y coordinate [m]")
    parser.add_argument("L", type=float, help="Total length [m]")
    parser.add_argument("fw", type=float, help="Full Gaussian width (FWHM) [m]")

    parser.add_argument("--dip", type=float, default=0.0, help="Dip angle [deg] (required for slab)")

    return parser.parse_args()


def calculate_slab(x0: float, y0: float, length: float, fwhm: float, dip_deg: float) -> Geometry:
    """Calculates endpoints and sigma for a dipping slab."""
    rad_dip = math.radians(dip_deg)
    dx = length * math.cos(rad_dip)
    dy = -length * math.sin(rad_dip)  # dy is negative for downward subduction

    return Geometry(x0=x0, y0=y0, x1=x0 + dx, y1=y0 + dy, dx=dx, dy=dy, sigma_w=fwhm / 2.355)


def calculate_plume(x0: float, y0: float, length: float, fwhm: float) -> Geometry:
    """Calculates endpoints and sigma for a vertical plume."""
    return Geometry(x0=x0, y0=y0, x1=x0, y1=y0 + length, dx=0.0, dy=length, sigma_w=fwhm / 2.355)


#######################################################
## .2. Main                                      !!! ##
#######################################################
def main():
    """ """
    args = parse_args()

    if args.mode == "slab":
        geo = calculate_slab(args.x0, args.y0, args.L, args.fw, args.dip)
    else:
        geo = calculate_plume(args.x0, args.y0, args.L, args.fw)

    # Print formatted output as space-separated integers
    print(f"{geo.x0:.0f} {geo.y0:.0f} {geo.x1:.0f} {geo.y1:.0f} " f"{geo.dx:.0f} {geo.dy:.0f} {geo.sigma_w:.0f}")


if __name__ == "__main__":
    main()
