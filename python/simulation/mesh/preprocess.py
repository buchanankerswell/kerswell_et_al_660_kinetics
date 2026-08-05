#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
from dataclasses import dataclass
from typing import Callable, ClassVar

import pyvista as pv


#######################################################
## .1. MeshPreProcessor                          !!! ##
#######################################################
@dataclass
class MeshPreProcessor:

    verbosity: int = 0

    # Derived field recipes: field_name -> (required_source_fields, compute_fn)
    _DERIVED_FIELDS: ClassVar[dict[str, tuple[tuple[str, ...], Callable]]] = {
        "nonadiabatic_density": (
            ("density", "adiabatic_density"),
            lambda m: m["density"] - m["adiabatic_density"],
        ),
        "nonadiabatic_temperature": (
            ("T", "adiabatic_temperature"),
            lambda m: m["T"] - m["adiabatic_temperature"],
        ),
        "nonadiabatic_pressure": (
            ("p", "adiabatic_pressure"),
            lambda m: m["p"] - m["adiabatic_pressure"],
        ),
        "velocity_vertical": (
            ("velocity",),
            lambda m: m["velocity"][:, 1],
        ),
    }

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def prepare_mesh(self, mesh: pv.UnstructuredGrid, field: str) -> None:
        """Derive computed fields from raw mesh data where required source fields are present."""
        if field not in self._DERIVED_FIELDS:
            return

        required, compute = self._DERIVED_FIELDS[field]
        if all(r in mesh.point_data for r in required):
            mesh[field] = compute(mesh)
        elif self.verbosity >= 1:
            missing = [r for r in required if r not in mesh.point_data]
            print(f" !! Warning: cannot derive '{field}', missing source fields: {missing}")

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def check_mesh(self, mesh: pv.UnstructuredGrid, field: str) -> bool:
        """Return True if field is present in mesh point data after preparation."""
        return field in mesh.point_data

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    def get_mesh_time_myr(self, mesh: pv.UnstructuredGrid, model_id: str, tstep: int) -> float:
        """Extract simulation time in Myr from mesh field data."""
        if "TIME" in mesh.field_data:
            return float(mesh.field_data["TIME"][0]) / 1e6  # seconds → Myr
        if self.verbosity >= 1:
            print(f" !! Warning: 'TIME' not found in field_data for model {model_id}, timestep {tstep}.")
        return 0.0
