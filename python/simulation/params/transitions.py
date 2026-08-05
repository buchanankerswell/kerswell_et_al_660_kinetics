#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import argparse
import os
from dataclasses import dataclass

import numpy as np


#######################################################
## .1. PhaseTransition                           !!! ##
#######################################################
@dataclass
class PhaseTransition:
    """
    Container for extracted ASPECT phase transition parameters.

    Attributes:
        y (float):            Vertical coordinate in the model domain [m].
        depth (float):        Depth relative to the model surface     [m].
        temperature (float):  Temperature at the transition           [K].
        clapeyron (float):    Clapeyron slope (dP/dT)                 [Pa/K].
        density_jump (float): Change in density across the transition [kg/m^3].
    """

    y: float
    depth: float
    temperature: float
    clapeyron: float
    density_jump: float


def parse_arguments() -> argparse.Namespace:
    """
    Handles command-line argument parsing for phase transition extraction.

    Returns:
        argparse.Namespace: The parsed command-line arguments.
    """
    parser = argparse.ArgumentParser(description="Extract phase transition parameters from thermodynamic profile TSV files for ASPECT.")

    parser.add_argument("ol_wd", type=str, help="Path to the olivine -> wadsleyite TSV profile")
    parser.add_argument("wd_ri", type=str, help="Path to the wadsleyite -> ringwoodite TSV profile")
    parser.add_argument("ri_ps", type=str, help="Path to the ringwoodite -> bridgmanite TSV profile")
    parser.add_argument("model_height", type=float, help="Total height of the ASPECT model domain [m]")
    parser.add_argument("surface_pressure", type=float, help="Pressure at the model top boundary [Pa]")

    args = parser.parse_args()

    for f in [args.ol_wd, args.wd_ri, args.ri_ps]:
        if not os.path.isfile(f):
            parser.error(f"Profile file not found: {f}")

    return args


def read_dG_profile(filepath: str) -> tuple[list[str], np.ndarray]:
    """
    Read a TSV profile file, skipping comment lines.

    Args:
        filepath: Path to the TSV file.

    Returns:
        tuple containing a list of headers and a numpy array of data.
    """
    # Initialize as None to identify the first non-comment line
    headers: list[str] | None = None
    data: list[list[float]] = []

    with open(filepath) as f:
        for line in f:
            stripped = line.strip()
            if not stripped or stripped.startswith("#"):
                continue

            cols = stripped.split("\t")
            if headers is None:
                headers = cols
            else:
                try:
                    data.append([float(v) for v in cols])
                except ValueError:
                    continue

    # Logic check to satisfy the type checker and ensure file integrity
    if headers is None or not data:
        raise ValueError(f" !! ERROR: No valid header or data rows found in {filepath}")

    return headers, np.array(data)


def find_surface_depth_offset(headers: list[str], data: np.ndarray, surface_pressure: float) -> float:
    """
    Finds the depth at which the profile matches the model's surface pressure.
    """
    col = {h: i for i, h in enumerate(headers)}
    pressures = data[:, col["pressure"]]
    depths = data[:, col["depth"]]

    if surface_pressure <= pressures[0]:
        return float(depths[0])

    idx = int(np.searchsorted(pressures, surface_pressure)) - 1
    idx = max(0, min(idx, len(pressures) - 2))

    # Linear interpolation
    t = (surface_pressure - pressures[idx]) / (pressures[idx + 1] - pressures[idx])
    return float(depths[idx] + t * (depths[idx + 1] - depths[idx]))


def find_transition(headers: list[str], data: np.ndarray, model_height: float, surface_depth_offset: float) -> PhaseTransition:
    """
    Locates the zero crossing of delta_molar_gibbs to define the phase boundary.

    Returns:
        PhaseTransition: Dataclass containing calculated parameters.
    """
    col = {h: i for i, h in enumerate(headers)}

    profile_depth = data[:, col["depth"]]
    temperature = data[:, col["temperature"]]
    delta_gibbs = data[:, col["delta_molar_gibbs"]]
    delta_entropy = data[:, col["delta_molar_entropy"]]
    delta_volume = data[:, col["delta_molar_volume"]]
    delta_density = data[:, col["delta_density"]]

    for i in range(len(delta_gibbs) - 1):
        # Look for zero crossing where Gibbs energy switches sign
        if delta_gibbs[i] > 0 and delta_gibbs[i + 1] <= 0:
            t = delta_gibbs[i] / (delta_gibbs[i] - delta_gibbs[i + 1])

            def interp(arr):
                return arr[i] + t * (arr[i + 1] - arr[i])

            trans_depth_profile = interp(profile_depth)
            trans_T = interp(temperature)
            trans_dS = interp(delta_entropy)
            trans_dV = interp(delta_volume)
            trans_drho = interp(delta_density)

            if abs(trans_dV) < 1e-20:
                raise ValueError(" !! ERROR: delta_molar_volume is zero at transition.")

            clapeyron = trans_dS / trans_dV
            model_depth = trans_depth_profile - surface_depth_offset
            model_y = model_height - model_depth

            return PhaseTransition(y=model_y, depth=model_depth, temperature=trans_T, clapeyron=clapeyron, density_jump=trans_drho)

    raise ValueError(" !! ERROR: no zero crossing found in delta_molar_gibbs")


#######################################################
## .2. Main                                      !!! ##
#######################################################
def main() -> None:
    """
    Main execution logic: extracts transition data for all three mantle phases.
    """
    args: argparse.Namespace = parse_arguments()

    # Determine depth offset using the first profile (olivine -> wadsleyite)
    ref_headers, ref_data = read_dG_profile(args.ol_wd)
    surface_depth_offset: float = find_surface_depth_offset(ref_headers, ref_data, args.surface_pressure)

    transitions: list[PhaseTransition] = []
    files: list[str] = [args.ol_wd, args.wd_ri, args.ri_ps]

    for filepath in files:
        headers, data = read_dG_profile(filepath)
        pt = find_transition(headers, data, args.model_height, surface_depth_offset)
        transitions.append(pt)

    # Flatten the dataclass values for the space-separated output
    output_values: list[float] = []
    for pt in transitions:
        output_values.extend([pt.y, pt.depth, pt.temperature, pt.clapeyron, pt.density_jump])

    def fmt(v: float, i: int) -> str:
        field_idx = i % 5  # y, depth, T, clap, drho
        # y, depth, and clapeyron use scientific notation; T and drho use fixed float
        if field_idx in (0, 1, 3):
            return f"{v:.4e}"
        return f"{v:.1f}"

    print(" ".join(fmt(v, i) for i, v in enumerate(output_values)))


if __name__ == "__main__":
    main()
