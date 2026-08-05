/*
  Copyright (C) 2011 - 2025 by the authors of the ASPECT code.

  This file is part of ASPECT.

  ASPECT is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2, or (at your option)
  any later version.

  ASPECT is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with ASPECT; see the file LICENSE.  If not see
  <http://www.gnu.org/licenses/>.
*/

#ifndef _aspect_cookbooks_mtz_kinetics_mtz_kinetics_h
#define _aspect_cookbooks_mtz_kinetics_mtz_kinetics_h

#include <deal.II/base/patterns.h>
#include <deal.II/base/types.h>

#include <aspect/adiabatic_conditions/interface.h>
#include <aspect/geometry_model/interface.h>
#include <aspect/material_model/equation_of_state/interface.h>
#include <aspect/material_model/interface.h>
#include <aspect/simulator_access.h>
#include <aspect/utilities.h>

#include <vector>

namespace aspect
{
  namespace MaterialModel
  {
    /**
     * A material model that implements phase transformation kinetics for three reactions:
     * (1) olivine <-> wadsleyite following Hosoya et al. (2005)
     * (2) wadsleyite <-> ringwoodite following Hosoya et al. (2005)
     * (3) ringwoodite <-> bridgmanite + periclase following Kubo et al. (2002)
     *
     * Each transformation reads thermodynamic data from separate ascii .tsv files.
     * The thermodynamic data are evaluated along an adiabatic reference profile and
     * used to compute reaction rates using the operator splitting technique. Average
     * material properties are computed from the mass fractions of the reacting phases.
     * The model is considered compressible.
     *
     * The olivine <-> wadsleyite transformation uses interface-controlled kinetics:
     * dX/dt = Z * T * exp(-Ha + PVa/RT) * (1 - exp(dG/RT)) * (1 - X)
     *
     * The wadsleyite <-> ringwoodite transformation uses interface-controlled kinetics:
     * dX/dt = Z * T * exp(-Ha + PVa/RT) * (1 - exp(dG/RT)) * (1 - X)
     *
     * The ringwoodite <-> bridgmanite + periclase transformation uses diffusion-controlled kinetics:
     * dX/dt = Z * -dG * |dG| * exp(-Ea/RT) * (1 - X)
     *
     * Viscosity is computed as:
     * eta(P,T) = eta_0 * eta_phase(P_ref) * exp(-A * (T - T_ref) / T_ref)
     *
     * where eta_phase(P_ref) is a Gibbs-free-energy-based smooth phase prefactor computed
     * from tanh transitions centred on the equilibrium phase boundaries (dG = 0). This
     * decouples the viscosity structure from the kinetic phase fields, preventing spurious
     * viscosity patches caused by metastable nuclei.
     *
     * @ingroup MaterialModels
     */
    template <int dim>
    class MTZKinetics : public MaterialModel::Interface<dim>, public ::aspect::SimulatorAccess<dim>
    {
    public:
      /**
       * Constructor. Initialize variables.
       */
      MTZKinetics();

      /**
       * Initialization function. This function is called once at the
       * beginning of the program after parse_parameters is run and after
       * the SimulatorAccess (if applicable) is initialized.
       */
      void
      initialize() override;

      /**
       * @name Qualitative properties one can ask a material model
       * @{
       */

      /**
       * Return whether the model is compressible or not.
       */
      bool
      is_compressible() const override;

      /**
       * @}
       */

      /**
       * Evaluate material properties.
       */
      void
      evaluate(const MaterialModel::MaterialModelInputs<dim> &in, MaterialModel::MaterialModelOutputs<dim> &out) const override;

      /**
       * @name Functions used in dealing with run-time parameters
       * @{
       */

      /**
       * Declare the parameters this class takes through input files.
       */
      static void
      declare_parameters(ParameterHandler &prm);

      /**
       * Read the parameters this class declares from the parameter file.
       */
      void
      parse_parameters(ParameterHandler &prm) override;

      /**
       * @}
       */

      /**
       * Add the named outputs for reaction rates.
       */
      void
      create_additional_named_outputs(MaterialModel::MaterialModelOutputs<dim> &out) const override;

    private:
      /**
       * Object that stores the thermodynamic data for the olivine <-> wadsleyite transformation.
       */
      Utilities::AsciiDataProfile<dim> profile_ol_wd;

      /**
       * Object that stores the thermodynamic data for the wadsleyite <-> ringwoodite transformation.
       */
      Utilities::AsciiDataProfile<dim> profile_wd_ri;

      /**
       * Object that stores the thermodynamic data for the ringwoodite <-> bridgmanite + periclase transformation.
       */
      Utilities::AsciiDataProfile<dim> profile_ri_ps;

      std::string data_directory_ol_wd;
      std::string data_filename_ol_wd;
      std::string data_directory_wd_ri;
      std::string data_filename_wd_ri;
      std::string data_directory_ri_ps;
      std::string data_filename_ri_ps;

      /**
       * Column indices for all four phases.
       */
      unsigned int rho_ol_idx, rho_wd_idx, rho_ri_idx, rho_ps_idx;
      unsigned int alpha_ol_idx, alpha_wd_idx, alpha_ri_idx, alpha_ps_idx;
      unsigned int beta_ol_idx, beta_wd_idx, beta_ri_idx, beta_ps_idx;
      unsigned int cp_ol_idx, cp_wd_idx, cp_ri_idx, cp_ps_idx;
      unsigned int dG_ol_wd_idx, dG_wd_ri_idx, dG_ri_ps_idx;
      unsigned int dS_ol_wd_idx, dS_wd_ri_idx, dS_ri_ps_idx;
      unsigned int dV_ol_wd_idx, dV_wd_ri_idx, dV_ri_ps_idx;
      unsigned int Vp_ol_idx, Vp_wd_idx, Vp_ri_idx, Vp_ps_idx;
      unsigned int Vs_ol_idx, Vs_wd_idx, Vs_ri_idx, Vs_ps_idx;
      unsigned int dVp_dT_ol_idx, dVp_dT_wd_idx, dVp_dT_ri_idx, dVp_dT_ps_idx;
      unsigned int dVs_dT_ol_idx, dVs_dT_wd_idx, dVs_dT_ri_idx, dVs_dT_ps_idx;

      /**
       * Reference viscosity. Units: Pa s
       */
      double viscosity;

      /**
       * Minimum and maximum viscosity cutoffs. Units: Pa s
       */
      double minimum_viscosity;
      double maximum_viscosity;

      /**
       * Exponent A in the temperature dependence exp(-A * (T - T_ref) / T_ref).
       * Dimensionless
       */
      double thermal_viscosity_exponent;

      /**
       * Per-phase viscosity prefactors applied via a Gibbs-based tanh transition.
       * These are completely decoupled from the kinetic Xi fields to prevent
       * spurious viscosity patches from metastable nuclei.
       * Dimensionless
       */
      double visc_prefactor_ol;
      double visc_prefactor_wd;
      double visc_prefactor_ri;
      double visc_prefactor_ps;

      /**
       * Width of the tanh viscosity transition in Gibbs free energy space.
       * Smaller values give sharper transitions; larger values smooth them out.
       * A value of ~1000 J/mol corresponds to a transition width of a few km.
       * Units: J/mol
       */
      double gibbs_viscosity_width;

      /**
       * Reference thermal conductivity. Units: W/m/K
       */
      double k;

      /**
       * Kinetic parameters for olivine <-> wadsleyite (Hosoya 2005).
       */
      double kinetic_factor_ol_wd;
      double Ha_ol_wd;
      double Va_ol_wd;

      /**
       * Kinetic parameters for wadsleyite <-> ringwoodite (interface-controlled).
       */
      double kinetic_factor_wd_ri;
      double Ha_wd_ri;
      double Va_wd_ri;

      /**
       * Kinetic parameters for ringwoodite <-> bridgmanite + periclase (Kubo 2002).
       */
      double kinetic_factor_ri_ps;
      double Ea_ri_ps;

      bool use_dynamic_pressure_correction_for_density;
      bool use_dynamic_pressure_correction_for_gibbs;
      bool enable_ol_wd_transformation;
      bool enable_wd_ri_transformation;
      bool enable_ri_ps_transformation;
    };



    /**
     * Additional output fields for the MTZKinetics material model.
     */
    template <int dim>
    class MTZKineticsOutputs : public NamedAdditionalMaterialOutputs<dim>
    {
    public:
      MTZKineticsOutputs(const unsigned int n_points);

      std::vector<double>
      get_nth_output(const unsigned int idx) const override;

      /**
       * Arrhenius term for olivine-wadsleyite: exp(-Ha + PVa/RT). Dimensionless
       */
      std::vector<double> arrhenius_ol_wd;

      /**
       * Arrhenius term for wadsleyite-ringwoodite: exp(-Ha + PVa/RT). Dimensionless
       */
      std::vector<double> arrhenius_wd_ri;

      /**
       * Arrhenius term for ringwoodite-postspinel: exp(-Ea/RT). Dimensionless
       */
      std::vector<double> arrhenius_ri_ps;

      /**
       * Thermodynamic driving force for olivine-wadsleyite: (1 - exp(dG/RT)). Dimensionless
       */
      std::vector<double> thermodynamic_ol_wd;

      /**
       * Thermodynamic driving force for wadsleyite-ringwoodite: (1 - exp(dG/RT)). Dimensionless
       */
      std::vector<double> thermodynamic_wd_ri;

      /**
       * Thermodynamic driving force for ringwoodite-postspinel: -dG * |dG|. Units: J^2/mol^2
       */
      std::vector<double> thermodynamic_ri_ps;

      /**
       * Viscosity temperature dependence term exp(-A * (T - T_ref) / T_ref). Dimensionless
       */
      std::vector<double> visc_temperature_dependence;

      /**
       * Mass fractions for all four phases. Dimensionless
       */
      std::vector<double> X_ol;
      std::vector<double> X_wd;
      std::vector<double> X_ri;
      std::vector<double> X_ps;
    };
  } // namespace MaterialModel
} // namespace aspect

#endif
