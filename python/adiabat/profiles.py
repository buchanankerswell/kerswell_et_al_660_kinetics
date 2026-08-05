#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import sys
import warnings
from contextlib import redirect_stdout
from dataclasses import dataclass, field
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from burnman import Material, PerplexMaterial, constants
from burnman.classes.perplex import create_perplex_table
from scipy.integrate import odeint
from scipy.interpolate import interp1d
from scipy.optimize import newton

warnings.filterwarnings("ignore", category=RuntimeWarning)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Constants
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EARTH_RADIUS: float = 6370e3  # m
SURFACE_GRAVITY: float = 9.81  # m/s/s


#######################################################
## .1. Helpers                                   !!! ##
#######################################################
class LiveIndenter:
    def __init__(self, original_stdout, indent="    "):
        self.terminal = original_stdout
        self.indent = indent
        self.at_start_of_line = True

    def write(self, message):
        if message:
            # If we are at the start of a new line, add the indentation
            if self.at_start_of_line and message != "\n":
                self.terminal.write(self.indent)

            # Handle multi-line strings within a single write call
            indented_msg = message.replace("\n", "\n" + self.indent)

            # If the message ends with a newline, the next write starts a new line
            if indented_msg.endswith(self.indent):
                # Remove the trailing indent so we don't have trailing spaces
                indented_msg = indented_msg[: -len(self.indent)]
                self.at_start_of_line = True
            else:
                self.at_start_of_line = False

            self.terminal.write(indented_msg)

    def flush(self):
        # Keeps the output synchronized
        self.terminal.flush()


#######################################################
## .2. AdiabaticProfile                        !!! ##
#######################################################
@dataclass
class AdiabaticProfile:
    """
    Generates (isentropic) adiabatic profile from a Perple_X model.

    This class uses BurnMan's PerplexMaterial to evaluate material properties
    along an isentrope starting from a potential temperature.
    """

    model_id: str
    out_table: Path
    out_profile: Path
    potential_temperature: float = 1573
    out_table_resolution: int = 128
    out_profile_resolution: int = 501
    planet_radius: float = EARTH_RADIUS
    surface_gravity: float = SURFACE_GRAVITY

    _material: PerplexMaterial | None = field(default=None, init=False)
    _pressures: np.ndarray | None = field(default=None, init=False)
    _temperatures: np.ndarray | None = field(default=None, init=False)
    _properties: dict[str, np.ndarray] | None = field(default=None, init=False)
    _depths: np.ndarray | None = field(default=None, init=False)
    _gravity: np.ndarray | None = field(default=None, init=False)
    _velocities: dict[str, np.ndarray] | None = field(default=None, init=False)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def __post_init__(self) -> None:
        """"""
        if not self.out_table.exists():
            if not self.out_table.parent.exists():
                self.out_table.parent.mkdir(parents=True, exist_ok=True)

            with redirect_stdout(LiveIndenter(sys.stdout, "    ")):  # type: ignore
                create_perplex_table(
                    werami_path="./werami",
                    project_name=self.model_id,
                    outfile=self.out_table.as_posix(),
                    n_pressures=self.out_table_resolution,
                    n_temperatures=self.out_table_resolution,
                )

        # Initialize arrays
        _ = self.material
        _ = self.pressures
        _ = self.temperatures

        if self.out_profile.exists():
            return

        self._write_profile()

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def material(self) -> PerplexMaterial:
        """"""
        if self._material is None:
            self._material = PerplexMaterial(self.out_table)

        return self._material

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def pressures(self) -> np.ndarray:
        """"""
        if self._pressures is None:
            bounds = self.material.bounds[0]
            self._pressures = np.linspace(bounds[0], bounds[1], self.out_profile_resolution)

        return self._pressures

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def temperatures(self) -> np.ndarray:
        """"""
        if self._temperatures is None:
            self._temperatures = self._evaluate_isentrope_temperatures()

        return self._temperatures

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def properties(self) -> dict[str, np.ndarray]:
        """"""
        if self._properties is None:
            self._properties = self._evaluate_material_properties()

        return self._properties

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def velocities(self) -> dict[str, np.ndarray]:
        """"""
        if self._velocities is None:
            self._velocities = self._evaluate_velocity_derivatives()

        return self._velocities

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def depths(self) -> np.ndarray:
        """"""
        if self._depths is None:
            self._depths, self._gravity = self._evaluate_depth_gravity_profiles()

        return self._depths

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def gravity(self) -> np.ndarray:
        """"""
        if self._gravity is None:
            self._depths, self._gravity = self._evaluate_depth_gravity_profiles()

        return self._gravity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_isentrope_temperatures(self) -> np.ndarray:
        """Evaluate temperatures along the isentrope at the specified pressures."""
        if self._material is None or self._pressures is None:
            raise ValueError("Material or entropy not initialized.")

        def entropy_difference(T: float, S: float, P: float) -> float:
            """Evaluate difference between current entropy and target entropy."""
            if self._material is None or self._pressures is None:
                raise ValueError("Material or entropy not initialized.")

            self._material.set_state(P, T)

            return self._material.S - S

        self._material.set_state(self._material.bounds[0][0], self.potential_temperature)
        entropy = self._material.molar_entropy

        T_guess: float = self.potential_temperature
        temperatures: np.ndarray = np.empty_like(self._pressures)

        for i, P in enumerate(self._pressures):
            T_guess = newton(entropy_difference, T_guess, args=(entropy, P))
            temperatures[i] = T_guess

        return temperatures

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_material_properties(self) -> dict[str, np.ndarray]:
        """Evaluate material properties along the isentrope."""
        if self._material is None or self._pressures is None or self._temperatures is None:
            raise ValueError("Pressure and temperature arrays are not generated!")

        properties = [
            "density",
            "molar_heat_capacity_p",
            "thermal_expansivity",
            "isentropic_compressibility_reuss",
            "molar_volume",
            "molar_entropy",
            "molar_gibbs",
        ]

        (
            density,
            molar_heat_capacity_p,
            thermal_expansivity,
            isentropic_compressibility_reuss,
            molar_volume,
            molar_entropy,
            molar_gibbs,
        ) = self._material.evaluate(properties, self._pressures, self._temperatures)

        specific_heat = molar_heat_capacity_p / self._material.params["molar_mass"]

        return {
            "density": density,
            "specific_heat": specific_heat,
            "thermal_expansivity": thermal_expansivity,
            "compressibility": isentropic_compressibility_reuss,
            "molar_volume": molar_volume,
            "molar_entropy": molar_entropy,
            "molar_gibbs": molar_gibbs,
        }

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_velocity_derivatives(self) -> dict[str, np.ndarray]:
        """Evaluate seismic velocity derivatives with respect to temperature."""
        if self._material is None or self._pressures is None or self._temperatures is None:
            raise ValueError("Pressure and temperature arrays are not generated.")

        dT = 0.1

        Vp_low, Vs_low = self._material.evaluate(
            ["p_wave_velocity", "shear_wave_velocity"],
            self._pressures,
            self._temperatures - dT / 2,
        )

        Vp_high, Vs_high = self._material.evaluate(
            ["p_wave_velocity", "shear_wave_velocity"],
            self._pressures,
            self._temperatures + dT / 2,
        )

        vp = (Vp_high + Vp_low) / 2
        vs = (Vs_high + Vs_low) / 2
        dvp_dt = (Vp_high - Vp_low) / dT
        dvs_dt = (Vs_high - Vs_low) / dT

        return {"vp": vp, "vs": vs, "dvp_dt": dvp_dt, "dvs_dt": dvs_dt}

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_depth_gravity_profiles(self) -> tuple[np.ndarray, np.ndarray]:
        """Evaluate depth and gravity profiles using iterative spline integration."""
        pressures = np.ravel(self.pressures).astype(float)
        densities = np.ravel(self.properties["density"]).astype(float)
        gravity = np.full_like(pressures, self.surface_gravity, dtype=float)
        depths = np.zeros_like(pressures, dtype=float)

        for _ in range(5):
            rho_interp = interp1d(
                pressures,
                densities,
                kind="cubic",
                bounds_error=False,
                fill_value="extrapolate",  # type: ignore
            )

            g_interp = interp1d(
                pressures,
                gravity,
                kind="cubic",
                bounds_error=False,
                fill_value="extrapolate",  # type: ignore
            )

            def rho_at_pressure(x):
                return float(rho_interp(float(x)))

            def gravity_at_pressure(x):
                return float(g_interp(float(x)))

            def depth_integrand(_, x):
                x_val = float(x) if isinstance(x, np.ndarray) else x
                return 1.0 / (gravity_at_pressure(x_val) * rho_at_pressure(x_val))

            depths = np.ravel(odeint(depth_integrand, 0.0, pressures))
            radii = self.planet_radius - depths

            rho_r_interp = interp1d(
                radii[::-1],
                densities[::-1],
                kind="cubic",
                bounds_error=False,
                fill_value="extrapolate",  # type: ignore
            )

            def rho_at_radius(x):
                return float(rho_r_interp(float(x)))

            def poisson_equation(_, x):
                x_val = float(x) if isinstance(x, np.ndarray) else x
                return 4.0 * np.pi * constants.G * rho_at_radius(x_val) * x_val * x_val

            gravity = np.ravel(odeint(poisson_equation, self.surface_gravity * radii[0] ** 2, radii))
            gravity = gravity / radii**2

        return depths, gravity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _write_profile(self) -> None:
        """Write adiabatic profile."""

        header = (
            "# This ASPECT-compatible file contains material properties evaluated along an isentrope by the BurnMan software.\n"
            f"# POINTS: {self.out_profile_resolution}\n"
            "#\n"
            "# depth (m) pressure (Pa) temperature (K) density (kg/m^3) gravity (m/s^2) thermal expansivity (1/K) specific heat (J/K/kg) compressibility (1/Pa) molar volume (m^3/mol) molar entropy (J/K/mol) molar Gibbs (J/mol) Vp (m/s) Vs (m/s) dVp/dT (m/s/K) dVs/dT (m/s/K)\n"
            "#\n"
            "depth\tpressure\ttemperature\tdensity\tgravity\tthermal_expansivity\tspecific_heat\tcompressibility\tmolar_volume\tmolar_entropy\tmolar_gibbs\tseismic_vp\tseismic_vs\tseismic_dvp_dt\tseismic_dvs_dt"
        )

        table = np.column_stack(
            [
                self.depths,
                self.pressures,
                self.temperatures,
                self.properties["density"],
                self.gravity,
                self.properties["thermal_expansivity"],
                self.properties["specific_heat"],
                self.properties["compressibility"],
                self.properties["molar_volume"],
                self.properties["molar_entropy"],
                self.properties["molar_gibbs"],
                self.velocities["vp"],
                self.velocities["vs"],
                self.velocities["dvp_dt"],
                self.velocities["dvs_dt"],
            ]
        )

        if not self.out_profile.parent.exists():
            self.out_profile.parent.mkdir(parents=True, exist_ok=True)

        np.savetxt(
            self.out_profile,
            table,
            header=header,
            fmt="%.5e",
            delimiter="\t",
            comments="",
        )

        print(f" -> {self.out_profile}")


#######################################################
## .3. DrivingForceProfile                       !!! ##
#######################################################
@dataclass
class DrivingForceProfile:
    """"""

    material_a: Material
    n_total_a: float
    material_b: Material
    n_total_b: float
    in_profile: AdiabaticProfile
    out_profile: Path
    out_fig_dir: Path
    _depths: np.ndarray | None = field(default=None, init=False)
    _pressures: np.ndarray | None = field(default=None, init=False)
    _temperatures: np.ndarray | None = field(default=None, init=False)
    _density: np.ndarray | None = field(default=None, init=False)
    _thermal_expansivity: np.ndarray | None = field(default=None, init=False)
    _specific_heat: np.ndarray | None = field(default=None, init=False)
    _compressibility: np.ndarray | None = field(default=None, init=False)
    _pressure_wave_velocity: np.ndarray | None = field(default=None, init=False)
    _pressure_wave_velocity_T_derivative: np.ndarray | None = field(default=None, init=False)
    _shear_wave_velocity: np.ndarray | None = field(default=None, init=False)
    _shear_wave_velocity_T_derivative: np.ndarray | None = field(default=None, init=False)
    _internal_energy: np.ndarray | None = field(default=None, init=False)
    _gibbs: np.ndarray | None = field(default=None, init=False)
    _entropy: np.ndarray | None = field(default=None, init=False)
    _volume: np.ndarray | None = field(default=None, init=False)
    _delta_density: np.ndarray | None = field(default=None, init=False)
    _delta_thermal_expansivity: np.ndarray | None = field(default=None, init=False)
    _delta_specific_heat: np.ndarray | None = field(default=None, init=False)
    _delta_compressibility: np.ndarray | None = field(default=None, init=False)
    _delta_pressure_wave_velocity: np.ndarray | None = field(default=None, init=False)
    _delta_pressure_wave_velocity_T_derivative: np.ndarray | None = field(default=None, init=False)
    _delta_shear_wave_velocity: np.ndarray | None = field(default=None, init=False)
    _delta_shear_wave_velocity_T_derivative: np.ndarray | None = field(default=None, init=False)
    _delta_internal_energy: np.ndarray | None = field(default=None, init=False)
    _delta_gibbs: np.ndarray | None = field(default=None, init=False)
    _delta_entropy: np.ndarray | None = field(default=None, init=False)
    _delta_volume: np.ndarray | None = field(default=None, init=False)
    _equilibrium_depth: np.ndarray | None = field(default=None, init=False)
    _driving_force: np.ndarray | None = field(default=None, init=False)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def __post_init__(self) -> None:
        """"""
        # Initialize arrays
        _ = self.depths
        _ = self.pressures
        _ = self.temperatures
        _ = self.delta_density
        _ = self.delta_thermal_expansivity
        _ = self.delta_specific_heat
        _ = self.delta_compressibility
        _ = self.delta_pressure_wave_velocity
        _ = self.delta_shear_wave_velocity
        _ = self.delta_internal_energy
        _ = self.delta_gibbs
        _ = self.delta_entropy
        _ = self.delta_volume

        if self.out_profile.exists():
            return

        self._write_profile()

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def depths(self) -> np.ndarray:
        """"""
        if self._depths is None:
            self._depths = self.in_profile.depths

        return self._depths

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def pressures(self) -> np.ndarray:
        """"""
        if self._pressures is None:
            self._pressures = self.in_profile.pressures

        return self._pressures

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def temperatures(self) -> np.ndarray:
        """"""
        if self._temperatures is None:
            self._temperatures = self.in_profile.temperatures

        return self._temperatures

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def density(self) -> np.ndarray:
        """"""
        if self._density is None:
            self._density = self._evaluate_density()

        return self._density

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def thermal_expansivity(self) -> np.ndarray:
        """"""
        if self._thermal_expansivity is None:
            self._thermal_expansivity = self._evaluate_thermal_expansivity()

        return self._thermal_expansivity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def specific_heat(self) -> np.ndarray:
        """"""
        if self._specific_heat is None:
            self._specific_heat = self._evaluate_specific_heat()

        return self._specific_heat

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def compressibility(self) -> np.ndarray:
        """"""
        if self._compressibility is None:
            self._compressibility = self._evaluate_compressibility()

        return self._compressibility

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def pressure_wave_velocity(self) -> np.ndarray:
        """"""
        if self._pressure_wave_velocity is None:
            self._pressure_wave_velocity = self._evaluate_pressure_wave_velocity()

        return self._pressure_wave_velocity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def pressure_wave_velocity_T_derivative(self) -> np.ndarray:
        """"""
        if self._pressure_wave_velocity_T_derivative is None:
            self._pressure_wave_velocity_T_derivative = self._evaluate_pressure_wave_velocity_T_derivative()

        return self._pressure_wave_velocity_T_derivative

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def shear_wave_velocity(self) -> np.ndarray:
        """"""
        if self._shear_wave_velocity is None:
            self._shear_wave_velocity = self._evaluate_shear_wave_velocity()

        return self._shear_wave_velocity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def shear_wave_velocity_T_derivative(self) -> np.ndarray:
        """"""
        if self._shear_wave_velocity_T_derivative is None:
            self._shear_wave_velocity_T_derivative = self._evaluate_shear_wave_velocity_T_derivative()

        return self._shear_wave_velocity_T_derivative

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def internal_energy(self) -> np.ndarray:
        """"""
        if self._internal_energy is None:
            self._internal_energy = self._evaluate_internal_energy()

        return self._internal_energy

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def gibbs(self) -> np.ndarray:
        """"""
        if self._gibbs is None:
            self._gibbs = self._evaluate_gibbs()

        return self._gibbs

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def entropy(self) -> np.ndarray:
        """"""
        if self._entropy is None:
            self._entropy = self._evaluate_entropy()

        return self._entropy

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def volume(self) -> np.ndarray:
        """"""
        if self._volume is None:
            self._volume = self._evaluate_volume()

        return self._volume

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_density(self) -> np.ndarray:
        """"""
        if self._delta_density is None:
            self._delta_density = self._evaluate_delta_density()

        return self._delta_density

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_thermal_expansivity(self) -> np.ndarray:
        """"""
        if self._delta_thermal_expansivity is None:
            self._delta_thermal_expansivity = self._evaluate_delta_thermal_expansivity()

        return self._delta_thermal_expansivity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_specific_heat(self) -> np.ndarray:
        """"""
        if self._delta_specific_heat is None:
            self._delta_specific_heat = self._evaluate_delta_specific_heat()

        return self._delta_specific_heat

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_compressibility(self) -> np.ndarray:
        """"""
        if self._delta_compressibility is None:
            self._delta_compressibility = self._evaluate_delta_compressibility()

        return self._delta_compressibility

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_pressure_wave_velocity(self) -> np.ndarray:
        """"""
        if self._delta_pressure_wave_velocity is None:
            self._delta_pressure_wave_velocity = self._evaluate_delta_pressure_wave_velocity()

        return self._delta_pressure_wave_velocity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_pressure_wave_velocity_T_derivative(self) -> np.ndarray:
        """"""
        if self._delta_pressure_wave_velocity_T_derivative is None:
            self._delta_pressure_wave_velocity_T_derivative = self._evaluate_delta_pressure_wave_velocity_T_derivative()

        return self._delta_pressure_wave_velocity_T_derivative

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_shear_wave_velocity(self) -> np.ndarray:
        """"""
        if self._delta_shear_wave_velocity is None:
            self._delta_shear_wave_velocity = self._evaluate_delta_shear_wave_velocity()

        return self._delta_shear_wave_velocity

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_shear_wave_velocity_T_derivative(self) -> np.ndarray:
        """"""
        if self._delta_shear_wave_velocity_T_derivative is None:
            self._delta_shear_wave_velocity_T_derivative = self._evaluate_delta_shear_wave_velocity_T_derivative()

        return self._delta_shear_wave_velocity_T_derivative

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_internal_energy(self) -> np.ndarray:
        """"""
        if self._delta_internal_energy is None:
            self._delta_internal_energy = self._evaluate_delta_internal_energy()

        return self._delta_internal_energy

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_gibbs(self) -> np.ndarray:
        """"""
        if self._delta_gibbs is None:
            self._delta_gibbs = self._evaluate_delta_gibbs()

        return self._delta_gibbs

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_entropy(self) -> np.ndarray:
        """"""
        if self._delta_entropy is None:
            self._delta_entropy = self._evaluate_delta_entropy()

        return self._delta_entropy

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def delta_volume(self) -> np.ndarray:
        """"""
        if self._delta_volume is None:
            self._delta_volume = self._evaluate_delta_volume()

        return self._delta_volume

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @property
    def equilibrium_depth(self) -> np.ndarray:
        """"""
        if self._equilibrium_depth is None:
            self._equilibrium_depth = self._evaluate_equilibrium_depth()

        return self._equilibrium_depth

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_density(self) -> np.ndarray:
        """"""
        density_a = self.material_a.evaluate(["density"], self.pressures, self.temperatures)
        density_b = self.material_b.evaluate(["density"], self.pressures, self.temperatures)

        return np.stack([density_a, density_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_thermal_expansivity(self) -> np.ndarray:
        """"""
        thermal_expansivity_a = self.material_a.evaluate(["thermal_expansivity"], self.pressures, self.temperatures)
        thermal_expansivity_b = self.material_b.evaluate(["thermal_expansivity"], self.pressures, self.temperatures)

        return np.stack([thermal_expansivity_a, thermal_expansivity_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_specific_heat(self) -> np.ndarray:
        """"""
        molar_mass_a = self.material_a.evaluate(["molar_mass"], self.pressures, self.temperatures)
        molar_mass_b = self.material_b.evaluate(["molar_mass"], self.pressures, self.temperatures)
        molar_heat_capacity_a = np.array(self.material_a.evaluate(["molar_heat_capacity_p"], self.pressures, self.temperatures))
        molar_heat_capacity_b = np.array(self.material_b.evaluate(["molar_heat_capacity_p"], self.pressures, self.temperatures))
        specific_heat_a = molar_heat_capacity_a / molar_mass_a
        specific_heat_b = molar_heat_capacity_b / molar_mass_b

        return np.stack([specific_heat_a, specific_heat_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_compressibility(self) -> np.ndarray:
        """"""
        compressibility_a = self.material_a.evaluate(["isentropic_compressibility_reuss"], self.pressures, self.temperatures)
        compressibility_b = self.material_b.evaluate(["isentropic_compressibility_reuss"], self.pressures, self.temperatures)

        return np.stack([compressibility_a, compressibility_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_pressure_wave_velocity(self) -> np.ndarray:
        """"""
        pressure_wave_velocity_a = self.material_a.evaluate(["p_wave_velocity"], self.pressures, self.temperatures)
        pressure_wave_velocity_b = self.material_b.evaluate(["p_wave_velocity"], self.pressures, self.temperatures)

        return np.stack([pressure_wave_velocity_a, pressure_wave_velocity_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_pressure_wave_velocity_T_derivative(self) -> np.ndarray:
        """Evaluate seismic pressure wave velocity derivatives with respect to temperature."""
        dT = 0.1

        Vp_low_a = np.array(self.material_a.evaluate(["p_wave_velocity"], self.pressures, self.temperatures - dT / 2))
        Vp_low_b = np.array(self.material_b.evaluate(["p_wave_velocity"], self.pressures, self.temperatures - dT / 2))
        Vp_high_a = np.array(self.material_a.evaluate(["p_wave_velocity"], self.pressures, self.temperatures + dT / 2))
        Vp_high_b = np.array(self.material_b.evaluate(["p_wave_velocity"], self.pressures, self.temperatures + dT / 2))

        dVp_dT_a = (Vp_high_a - Vp_low_a) / dT
        dVp_dT_b = (Vp_high_b - Vp_low_b) / dT

        return np.stack([dVp_dT_a, dVp_dT_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_shear_wave_velocity(self) -> np.ndarray:
        """"""
        shear_wave_velocity_a = self.material_a.evaluate(["shear_wave_velocity"], self.pressures, self.temperatures)
        shear_wave_velocity_b = self.material_b.evaluate(["shear_wave_velocity"], self.pressures, self.temperatures)

        return np.stack([shear_wave_velocity_a, shear_wave_velocity_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_shear_wave_velocity_T_derivative(self) -> np.ndarray:
        """Evaluate seismic shear wave velocity derivatives with respect to temperature."""
        dT = 0.1

        Vs_low_a = np.array(self.material_a.evaluate(["shear_wave_velocity"], self.pressures, self.temperatures - dT / 2))
        Vs_low_b = np.array(self.material_b.evaluate(["shear_wave_velocity"], self.pressures, self.temperatures - dT / 2))
        Vs_high_a = np.array(self.material_a.evaluate(["shear_wave_velocity"], self.pressures, self.temperatures + dT / 2))
        Vs_high_b = np.array(self.material_b.evaluate(["shear_wave_velocity"], self.pressures, self.temperatures + dT / 2))

        dVs_dT_a = (Vs_high_a - Vs_low_a) / dT
        dVs_dT_b = (Vs_high_b - Vs_low_b) / dT

        return np.stack([dVs_dT_a, dVs_dT_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_internal_energy(self) -> np.ndarray:
        """"""
        internal_energy_a = np.array(self.material_a.evaluate(["molar_internal_energy"], self.pressures, self.temperatures))
        internal_energy_b = np.array(self.material_b.evaluate(["molar_internal_energy"], self.pressures, self.temperatures))

        return np.stack([internal_energy_a * self.n_total_a, internal_energy_b * self.n_total_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_gibbs(self) -> np.ndarray:
        """"""
        gibbs_a = np.array(self.material_a.evaluate(["molar_gibbs"], self.pressures, self.temperatures))
        gibbs_b = np.array(self.material_b.evaluate(["molar_gibbs"], self.pressures, self.temperatures))

        return np.stack([gibbs_a * self.n_total_a, gibbs_b * self.n_total_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_entropy(self) -> np.ndarray:
        """"""
        entropy_a = np.array(self.material_a.evaluate(["molar_entropy"], self.pressures, self.temperatures))
        entropy_b = np.array(self.material_b.evaluate(["molar_entropy"], self.pressures, self.temperatures))

        return np.stack([entropy_a * self.n_total_a, entropy_b * self.n_total_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_volume(self) -> np.ndarray:
        """"""
        volume_a = np.array(self.material_a.evaluate(["molar_volume"], self.pressures, self.temperatures))
        volume_b = np.array(self.material_b.evaluate(["molar_volume"], self.pressures, self.temperatures))

        return np.stack([volume_a * self.n_total_a, volume_b * self.n_total_b])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_density(self) -> np.ndarray:
        """"""
        return np.ravel(self.density[1] - self.density[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_thermal_expansivity(self) -> np.ndarray:
        """"""
        return np.ravel(self.thermal_expansivity[1] - self.thermal_expansivity[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_specific_heat(self) -> np.ndarray:
        """"""
        return np.ravel(self.specific_heat[1] - self.specific_heat[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_compressibility(self) -> np.ndarray:
        """"""
        return np.ravel(self.compressibility[1] - self.compressibility[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_pressure_wave_velocity(self) -> np.ndarray:
        """"""
        return np.ravel(self.pressure_wave_velocity[1] - self.pressure_wave_velocity[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_pressure_wave_velocity_T_derivative(self) -> np.ndarray:
        """"""
        return np.ravel(self.pressure_wave_velocity_T_derivative[1] - self.pressure_wave_velocity_T_derivative[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_shear_wave_velocity(self) -> np.ndarray:
        """"""
        return np.ravel(self.shear_wave_velocity[1] - self.shear_wave_velocity[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_shear_wave_velocity_T_derivative(self) -> np.ndarray:
        """"""
        return np.ravel(self.shear_wave_velocity_T_derivative[1] - self.shear_wave_velocity_T_derivative[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_internal_energy(self) -> np.ndarray:
        """"""
        return np.ravel(self.internal_energy[1] - self.internal_energy[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_gibbs(self) -> np.ndarray:
        """"""
        return np.ravel(self.gibbs[1] - self.gibbs[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_entropy(self) -> np.ndarray:
        """"""
        return np.ravel(self.entropy[1] - self.entropy[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_delta_volume(self) -> np.ndarray:
        """"""
        return np.ravel(self.volume[1] - self.volume[0])

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _evaluate_equilibrium_depth(self):
        """"""
        # Find index where delta_gibbs crosses zero (sign change)
        signs = np.sign(self.delta_gibbs)
        sign_changes = np.where(np.diff(signs) != 0)[0]

        if len(sign_changes) == 0:
            raise ValueError("No sign change found in delta_gibbs array!")

        i = sign_changes[0]

        # Linear interpolation
        dg0, dg1 = self.delta_gibbs[i], self.delta_gibbs[i + 1]
        z0, z1 = self.depths[i], self.depths[i + 1]

        depth_at_zero = z0 + (0 - dg0) * (z1 - z0) / (dg1 - dg0)

        return depth_at_zero

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _write_profile(self) -> None:
        """Write profile."""

        header = (
            f"# This ASPECT-compatible file contains data to calculate the thermodynamic driving force in the ReactionKinetics material model. This table is for {self.material_a.name} -> {self.material_b.name} evaluated along an isentrope produced by the BurnMan software.\n"
            f"# POINTS: {len(self.depths)}\n"
            "#\n"
            "# pressure (Pa) temperature (K) depth (m) density a (kg/m3) density b (kg/m3) thermal expansivity a (1/K) thermal expansivity b (1/K) specific heat a (J/K/kg) specific heat b (J/K/kg) compressibility a (1/Pa) compressibility b (1/Pa) seismic Vp a (m/s) seismic Vp b (m/s) seismic dVp/dT a (m/s/K) seismic dVp/dT b (m/s/K) seismic Vs a (m/s) seismic Vs b (m/s) seismic dVs/dT a (m/s/K) seismic dVs/dT b (m/s/K) molar internal energy a (J/mol) molar internal energy b (J/mol) molar Gibbs a (J/mol) molar Gibbs b (J/mol) molar entropy a (J/mol) molar entropy b (J/mol) molar volume a (m^3/mol) molar volume b (m^3/mol) delta density (kg/m3) delta thermal expansivity (1/K) delta specific heat (J/K/kg) delta compressibility (1/Pa) delta internal energy (J/mol) delta molar Gibbs (J/mol) delta molar entropy (J/K/mol) delta molar volume (m^3/mol)\n"
            "#\n"
            "pressure\ttemperature\tdepth\tdensity_a\tdensity_b\tthermal_expansivity_a\tthermal_expansivity_b\tspecific_heat_a\tspecific_heat_b\tcompressibility_a\tcompressibility_b\tpressure_wave_velocity_a\tpressure_wave_velocity_b\tpressure_wave_velocity_T_derivative_a\tpressure_wave_velocity_T_derivative_b\tshear_wave_velocity_a\tshear_wave_velocity_b\tshear_wave_velocity_T_derivative_a\tshear_wave_velocity_T_derivative_b\tmolar_internal_energy_a\tmolar_internal_energy_b\tmolar_gibbs_a\tmolar_gibbs_b\tmolar_entropy_a\tmolar_entropy_b\tmolar_volume_a\tmolar_volume_b\tdelta_density\tdelta_thermal_expansivity\tdelta_specific_heat\tdelta_compressibility\tdelta_molar_internal_energy\tdelta_molar_gibbs\tdelta_molar_entropy\tdelta_molar_volume"
        )

        table = np.column_stack(
            [
                self.pressures,
                self.temperatures,
                self.depths,
                self.density[0].ravel(),
                self.density[1].ravel(),
                self.thermal_expansivity[0].ravel(),
                self.thermal_expansivity[1].ravel(),
                self.specific_heat[0].ravel(),
                self.specific_heat[1].ravel(),
                self.compressibility[0].ravel(),
                self.compressibility[1].ravel(),
                self.pressure_wave_velocity[0].ravel(),
                self.pressure_wave_velocity[1].ravel(),
                self.pressure_wave_velocity_T_derivative[0].ravel(),
                self.pressure_wave_velocity_T_derivative[1].ravel(),
                self.shear_wave_velocity[0].ravel(),
                self.shear_wave_velocity[1].ravel(),
                self.shear_wave_velocity_T_derivative[0].ravel(),
                self.shear_wave_velocity_T_derivative[1].ravel(),
                self.internal_energy[0].ravel(),
                self.internal_energy[1].ravel(),
                self.gibbs[0].ravel(),
                self.gibbs[1].ravel(),
                self.entropy[0].ravel(),
                self.entropy[1].ravel(),
                self.volume[0].ravel(),
                self.volume[1].ravel(),
                self.delta_density,
                self.delta_thermal_expansivity,
                self.delta_specific_heat,
                self.delta_compressibility,
                self.delta_internal_energy,
                self.delta_gibbs,
                self.delta_entropy,
                self.delta_volume,
            ]
        )

        if not self.out_profile.parent.exists():
            self.out_profile.parent.mkdir(parents=True, exist_ok=True)

        np.savetxt(
            self.out_profile,
            table,
            header=header,
            fmt="%.5e",
            delimiter="\t",
            comments="",
        )

        print(f" -> {self.out_profile}")

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def visualize(
        self,
        contour_lims_P: tuple[float, float] = (-1.2e9, 1.2e9),
        contour_lims_T: tuple[float, float] = (-600, 600),
        n_contours: int = 100,
    ) -> None:
        """"""
        if not self.out_fig_dir.exists():
            self.out_fig_dir.mkdir(parents=True, exist_ok=True)

        target_depth = self.equilibrium_depth
        depth_lims = (float(target_depth - 100e3), float(target_depth + 100e3))

        self._visualize_delta_PT_contours_fill(
            depth_lims=depth_lims,
            contour_lims_P=contour_lims_P,
            contour_lims_T=contour_lims_T,
            n_contours=n_contours,
        )

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _mask_arrays(
        self,
        depth_lims: tuple[float, float] = (300e3, 600e3),
    ) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        """"""
        depths = self.depths.copy()
        delta_internal_energy = self.delta_internal_energy.copy()
        delta_gibbs = self.delta_gibbs.copy()
        delta_entropy = self.delta_entropy.copy()
        delta_volume = self.delta_volume.copy()

        mask = (depths >= depth_lims[0]) & (depths <= depth_lims[1])

        depths = depths[mask]
        delta_internal_energy = delta_internal_energy[mask]
        delta_gibbs = delta_gibbs[mask]
        delta_entropy = delta_entropy[mask]
        delta_volume = delta_volume[mask]

        return depths, delta_internal_energy, delta_gibbs, delta_entropy, delta_volume

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_driving_force_grid_fixed_dT(
        self,
        depth_lims: tuple[float, float] = (300e3, 600e3),
        contour_lims: tuple[float, float] = (-1.2e9, 1.2e9),
        n_contours: int = 100,
    ) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        """"""
        depths, _, delta_gibbs, delta_entropy, delta_volume = self._mask_arrays(depth_lims)

        dP = np.linspace(contour_lims[0], contour_lims[1], n_contours)
        dT = 0

        depths_grid, dP_grid = np.meshgrid(depths, dP)

        delta_gibbs = delta_gibbs[np.newaxis, :]
        delta_volume = delta_volume[np.newaxis, :]
        delta_entropy = delta_entropy[np.newaxis, :]

        driving_force_grid = delta_gibbs + dP_grid * delta_volume - dT * delta_entropy

        vmax = max(np.abs(np.nanmin(driving_force_grid)), np.nanmax(driving_force_grid))
        levels = np.linspace(-vmax, vmax, 31)

        return depths_grid, dP_grid, driving_force_grid, levels

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_driving_force_grid_fixed_dP(
        self,
        depth_lims: tuple[float, float] = (300e3, 600e3),
        contour_lims: tuple[float, float] = (-600, 600),
        n_contours: int = 100,
    ) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        """"""
        depths, _, delta_gibbs, delta_entropy, delta_volume = self._mask_arrays(depth_lims)

        dT = np.linspace(contour_lims[0], contour_lims[1], n_contours)
        dP = 0

        depths_grid, dT_grid = np.meshgrid(depths, dT)

        delta_gibbs = delta_gibbs[np.newaxis, :]
        delta_volume = delta_volume[np.newaxis, :]
        delta_entropy = delta_entropy[np.newaxis, :]

        driving_force_grid = delta_gibbs + dP * delta_volume - dT_grid * delta_entropy

        vmax = max(np.abs(np.nanmin(driving_force_grid)), np.nanmax(driving_force_grid))
        levels = np.linspace(-vmax, vmax, 31)

        return depths_grid, dT_grid, driving_force_grid, levels

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _get_driving_force_grid_at_target_depth(
        self,
        target_depth: float = 410e3,
        contour_lims_P: tuple[float, float] = (-1.2e9, 1.2e9),
        contour_lims_T: tuple[float, float] = (-600, 600),
        n_contours: int = 100,
    ) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        """"""
        depths = self.depths.copy()
        delta_gibbs = self.delta_gibbs.copy()
        delta_entropy = self.delta_entropy.copy()
        delta_volume = self.delta_volume.copy()

        dP = np.linspace(contour_lims_P[0], contour_lims_P[1], n_contours)
        dT = np.linspace(contour_lims_T[0], contour_lims_T[1], n_contours)

        depth_idx = np.argmin(np.abs(depths - target_depth))

        delta_gibbs_target = delta_gibbs[depth_idx]
        delta_volume_target = delta_volume[depth_idx]
        delta_entropy_target = delta_entropy[depth_idx]

        dP_grid, dT_grid = np.meshgrid(dP, dT)

        driving_force_grid = delta_gibbs_target + dP_grid * delta_volume_target - dT_grid * delta_entropy_target

        vmax = max(np.abs(np.nanmin(driving_force_grid)), np.nanmax(driving_force_grid))
        levels = np.linspace(-vmax, vmax, 31)

        return dP_grid, dT_grid, driving_force_grid, levels

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @staticmethod
    def _set_rc_params() -> None:
        """"""
        plt.rcParams.update(
            {
                "figure.dpi": 300,
                "savefig.bbox": "tight",
                "axes.facecolor": "0.9",
                "legend.frameon": False,
                "legend.facecolor": "0.9",
                "legend.loc": "upper left",
                "legend.fontsize": "small",
                "figure.autolayout": True,
                "font.size": 14,
            }
        )

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @staticmethod
    def _plot_exists(out_path: Path) -> bool:
        """"""
        if out_path.exists():
            return True

        if not out_path.parent.exists():
            out_path.parent.mkdir(parents=True, exist_ok=True)

        print(f" -> {out_path}")

        return False

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def _visualize_delta_PT_contours_fill(
        self,
        depth_lims: tuple[float, float] = (300e3, 600e3),
        contour_lims_P: tuple[float, float] = (-1.2e9, 1.2e9),
        contour_lims_T: tuple[float, float] = (-600, 600),
        n_contours: int = 100,
    ) -> None:
        """"""
        out_path = self.out_fig_dir / f"driving-force-contours-fill-{self.material_a.name}-{self.material_b.name}.png"

        self._plot_exists(out_path)

        depths_grid_P, dP_grid, driving_force_grid_P, levels_P = self._get_driving_force_grid_fixed_dT(
            depth_lims=depth_lims,
            contour_lims=contour_lims_P,
            n_contours=n_contours,
        )

        depths_grid_T, dT_grid, driving_force_grid_T, levels_T = self._get_driving_force_grid_fixed_dP(
            depth_lims=depth_lims,
            contour_lims=contour_lims_T,
            n_contours=n_contours,
        )

        ymin = depths_grid_P.min() / 1e3
        ymax = depths_grid_P.max() / 1e3

        self._set_rc_params()

        fig, axes = plt.subplots(1, 2, figsize=(6.5, 3.5), sharey=True)

        _ = axes[0].contourf(dP_grid / 1e9, depths_grid_P / 1e3, driving_force_grid_P / 1e3, levels=np.round(levels_P / 1e3, 1), cmap="PuOr_r")
        filtered_levels_P = levels_P[::3]
        filtered_levels_P = filtered_levels_P[filtered_levels_P != 0]
        contour_P = axes[0].contour(
            dP_grid / 1e9, depths_grid_P / 1e3, driving_force_grid_P / 1e3, levels=np.round(filtered_levels_P / 1e3, 1), colors="k", linewidths=0.5
        )
        contour_0_P = axes[0].contour(dP_grid / 1e9, depths_grid_P / 1e3, driving_force_grid_P / 1e3, levels=[0], colors="k", linewidths=1)
        axes[0].set_ylim(ymax, ymin)
        axes[0].clabel(contour_P, fmt="%.1f", fontsize=10)
        axes[0].clabel(contour_0_P, fmt={0: "$\\Delta{G}$ = 0"}, fontsize=10)
        axes[0].set_xlabel("$\\hat{P}$ (GPa)")
        axes[0].set_ylabel("Depth (km)")
        axes[0].set_title("$\\hat{T}$ = 0 K")
        axes[0].tick_params(axis="both", which="both", length=0)

        _ = axes[1].contourf(dT_grid, depths_grid_T / 1e3, driving_force_grid_T / 1e3, levels=np.round(levels_T / 1e3, 1), cmap="PuOr_r")
        filtered_levels_T = levels_T[::3]
        filtered_levels_T = filtered_levels_T[filtered_levels_T != 0]
        contour_T = axes[1].contour(
            dT_grid, depths_grid_T / 1e3, driving_force_grid_T / 1e3, levels=np.round(filtered_levels_T / 1e3, 1), colors="k", linewidths=0.5
        )
        contour_0_T = axes[1].contour(dT_grid, depths_grid_T / 1e3, driving_force_grid_T / 1e3, levels=[0], colors="k", linewidths=1)
        axes[1].set_ylim(ymax, ymin)
        axes[1].clabel(contour_T, fmt="%.1f", fontsize=10)
        axes[1].clabel(contour_0_T, fmt={0: "$\\Delta{G}$ = 0"}, fontsize=10)
        axes[1].set_xlabel("$\\hat{T}$ (K)")
        axes[1].set_title("$\\hat{P}$ = 0 GPa")
        axes[1].tick_params(axis="both", which="both", length=0)

        plt.tight_layout()
        fig.savefig(out_path)
