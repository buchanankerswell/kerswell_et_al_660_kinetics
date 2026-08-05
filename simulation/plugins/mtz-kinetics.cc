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

#include "mtz-kinetics.h"

#include <deal.II/base/numbers.h>
#include <deal.II/base/parameter_handler.h>
#include <deal.II/base/patterns.h>
#include <deal.II/base/point.h>

#include <aspect/global.h>

#include <string>
#include <vector>

namespace aspect
{
  namespace MaterialModel
  {
    template <int dim>
    MTZKinetics<dim>::MTZKinetics()
      : rho_ol_idx(numbers::invalid_unsigned_int)
      , rho_wd_idx(numbers::invalid_unsigned_int)
      , rho_ri_idx(numbers::invalid_unsigned_int)
      , rho_ps_idx(numbers::invalid_unsigned_int)
      , alpha_ol_idx(numbers::invalid_unsigned_int)
      , alpha_wd_idx(numbers::invalid_unsigned_int)
      , alpha_ri_idx(numbers::invalid_unsigned_int)
      , alpha_ps_idx(numbers::invalid_unsigned_int)
      , beta_ol_idx(numbers::invalid_unsigned_int)
      , beta_wd_idx(numbers::invalid_unsigned_int)
      , beta_ri_idx(numbers::invalid_unsigned_int)
      , beta_ps_idx(numbers::invalid_unsigned_int)
      , cp_ol_idx(numbers::invalid_unsigned_int)
      , cp_wd_idx(numbers::invalid_unsigned_int)
      , cp_ri_idx(numbers::invalid_unsigned_int)
      , cp_ps_idx(numbers::invalid_unsigned_int)
      , dG_ol_wd_idx(numbers::invalid_unsigned_int)
      , dG_wd_ri_idx(numbers::invalid_unsigned_int)
      , dG_ri_ps_idx(numbers::invalid_unsigned_int)
      , dS_ol_wd_idx(numbers::invalid_unsigned_int)
      , dS_wd_ri_idx(numbers::invalid_unsigned_int)
      , dS_ri_ps_idx(numbers::invalid_unsigned_int)
      , dV_ol_wd_idx(numbers::invalid_unsigned_int)
      , dV_wd_ri_idx(numbers::invalid_unsigned_int)
      , dV_ri_ps_idx(numbers::invalid_unsigned_int)
      , Vp_ol_idx(numbers::invalid_unsigned_int)
      , Vp_wd_idx(numbers::invalid_unsigned_int)
      , Vp_ri_idx(numbers::invalid_unsigned_int)
      , Vp_ps_idx(numbers::invalid_unsigned_int)
      , Vs_ol_idx(numbers::invalid_unsigned_int)
      , Vs_wd_idx(numbers::invalid_unsigned_int)
      , Vs_ri_idx(numbers::invalid_unsigned_int)
      , Vs_ps_idx(numbers::invalid_unsigned_int)
      , dVp_dT_ol_idx(numbers::invalid_unsigned_int)
      , dVp_dT_wd_idx(numbers::invalid_unsigned_int)
      , dVp_dT_ri_idx(numbers::invalid_unsigned_int)
      , dVp_dT_ps_idx(numbers::invalid_unsigned_int)
      , dVs_dT_ol_idx(numbers::invalid_unsigned_int)
      , dVs_dT_wd_idx(numbers::invalid_unsigned_int)
      , dVs_dT_ri_idx(numbers::invalid_unsigned_int)
      , dVs_dT_ps_idx(numbers::invalid_unsigned_int)
    {}



    template <int dim>
    void
    MTZKinetics<dim>::initialize()
    {
      // Initialize the olivine-wadsleyite data reader
      if (enable_ol_wd_transformation)
        {
          profile_ol_wd.initialize(this->get_mpi_communicator());

          rho_ol_idx   = profile_ol_wd.get_column_index_from_name("density_a");
          rho_wd_idx   = profile_ol_wd.get_column_index_from_name("density_b");
          alpha_ol_idx = profile_ol_wd.get_column_index_from_name("thermal_expansivity_a");
          alpha_wd_idx = profile_ol_wd.get_column_index_from_name("thermal_expansivity_b");
          beta_ol_idx  = profile_ol_wd.get_column_index_from_name("compressibility_a");
          beta_wd_idx  = profile_ol_wd.get_column_index_from_name("compressibility_b");
          cp_ol_idx    = profile_ol_wd.get_column_index_from_name("specific_heat_a");
          cp_wd_idx    = profile_ol_wd.get_column_index_from_name("specific_heat_b");
          dG_ol_wd_idx = profile_ol_wd.get_column_index_from_name("delta_molar_gibbs");
          dS_ol_wd_idx = profile_ol_wd.get_column_index_from_name("delta_molar_entropy");
          dV_ol_wd_idx = profile_ol_wd.get_column_index_from_name("delta_molar_volume");

          Vp_ol_idx     = profile_ol_wd.maybe_get_column_index_from_name("pressure_wave_velocity_a");
          Vp_wd_idx     = profile_ol_wd.maybe_get_column_index_from_name("pressure_wave_velocity_b");
          dVp_dT_ol_idx = profile_ol_wd.maybe_get_column_index_from_name("pressure_wave_velocity_T_derivative_a");
          dVp_dT_wd_idx = profile_ol_wd.maybe_get_column_index_from_name("pressure_wave_velocity_T_derivative_b");
          Vs_ol_idx     = profile_ol_wd.maybe_get_column_index_from_name("shear_wave_velocity_a");
          Vs_wd_idx     = profile_ol_wd.maybe_get_column_index_from_name("shear_wave_velocity_b");
          dVs_dT_ol_idx = profile_ol_wd.maybe_get_column_index_from_name("shear_wave_velocity_T_derivative_a");
          dVs_dT_wd_idx = profile_ol_wd.maybe_get_column_index_from_name("shear_wave_velocity_T_derivative_b");
        }

      // Initialize the wadsleyite-ringwoodite data reader
      if (enable_wd_ri_transformation)
        {
          profile_wd_ri.initialize(this->get_mpi_communicator());

          rho_ri_idx   = profile_wd_ri.get_column_index_from_name("density_b");
          alpha_ri_idx = profile_wd_ri.get_column_index_from_name("thermal_expansivity_b");
          beta_ri_idx  = profile_wd_ri.get_column_index_from_name("compressibility_b");
          cp_ri_idx    = profile_wd_ri.get_column_index_from_name("specific_heat_b");
          dG_wd_ri_idx = profile_wd_ri.get_column_index_from_name("delta_molar_gibbs");
          dS_wd_ri_idx = profile_wd_ri.get_column_index_from_name("delta_molar_entropy");
          dV_wd_ri_idx = profile_wd_ri.get_column_index_from_name("delta_molar_volume");

          Vp_ri_idx     = profile_wd_ri.maybe_get_column_index_from_name("pressure_wave_velocity_b");
          dVp_dT_ri_idx = profile_wd_ri.maybe_get_column_index_from_name("pressure_wave_velocity_T_derivative_b");
          Vs_ri_idx     = profile_wd_ri.maybe_get_column_index_from_name("shear_wave_velocity_b");
          dVs_dT_ri_idx = profile_wd_ri.maybe_get_column_index_from_name("shear_wave_velocity_T_derivative_b");
        }

      // Initialize the ringwoodite-postspinel data reader
      if (enable_ri_ps_transformation)
        {
          profile_ri_ps.initialize(this->get_mpi_communicator());

          rho_ps_idx   = profile_ri_ps.get_column_index_from_name("density_b");
          alpha_ps_idx = profile_ri_ps.get_column_index_from_name("thermal_expansivity_b");
          beta_ps_idx  = profile_ri_ps.get_column_index_from_name("compressibility_b");
          cp_ps_idx    = profile_ri_ps.get_column_index_from_name("specific_heat_b");
          dG_ri_ps_idx = profile_ri_ps.get_column_index_from_name("delta_molar_gibbs");
          dS_ri_ps_idx = profile_ri_ps.get_column_index_from_name("delta_molar_entropy");
          dV_ri_ps_idx = profile_ri_ps.get_column_index_from_name("delta_molar_volume");

          Vp_ps_idx     = profile_ri_ps.maybe_get_column_index_from_name("pressure_wave_velocity_b");
          dVp_dT_ps_idx = profile_ri_ps.maybe_get_column_index_from_name("pressure_wave_velocity_T_derivative_b");
          Vs_ps_idx     = profile_ri_ps.maybe_get_column_index_from_name("shear_wave_velocity_b");
          dVs_dT_ps_idx = profile_ri_ps.maybe_get_column_index_from_name("shear_wave_velocity_T_derivative_b");
        }
    }



    template <int dim>
    bool
    MTZKinetics<dim>::is_compressible() const
    {
      return true;
    }



    template <int dim>
    void
    MTZKinetics<dim>::evaluate(const MaterialModel::MaterialModelInputs<dim> &in, MaterialModel::MaterialModelOutputs<dim> &out) const
    {
      // Set up additional output objects
      std::shared_ptr<PrescribedFieldOutputs<dim>>   prescribed_field_out = out.template get_additional_output_object<PrescribedFieldOutputs<dim>>();
      std::shared_ptr<ReactionRateOutputs<dim>>      reaction_rate_out    = out.template get_additional_output_object<ReactionRateOutputs<dim>>();
      std::shared_ptr<MTZKineticsOutputs<dim>>       mtz_kinetics_out     = out.template get_additional_output_object<MTZKineticsOutputs<dim>>();
      std::shared_ptr<SeismicAdditionalOutputs<dim>> seismic_out = out.template get_additional_output_object<SeismicAdditionalOutputs<dim>>();

      // Get compositional field indices
      auto idx_or_invalid = [&](bool enabled, const std::string &name) {
        if (!enabled)
          return numbers::invalid_unsigned_int;
        if (!this->introspection().compositional_name_exists(name))
          return numbers::invalid_unsigned_int;
        return this->introspection().compositional_index_for_name(name);
      };

      const unsigned int projected_density_idx = idx_or_invalid(true, "density_field");
      const unsigned int xi_ol_wd_idx          = idx_or_invalid(enable_ol_wd_transformation, "xi_ol_wd");
      const unsigned int xi_wd_ri_idx          = idx_or_invalid(enable_wd_ri_transformation, "xi_wd_ri");
      const unsigned int xi_ri_ps_idx          = idx_or_invalid(enable_ri_ps_transformation, "xi_ri_ps");

      for (unsigned int q = 0; q < in.n_evaluation_points(); ++q)
        {
          const Point<dim> position = in.position[q];

          const double P = in.pressure[q];
          const double T = in.temperature[q];

          const double   P_ref = this->get_adiabatic_conditions().pressure(position);
          const double   T_ref = this->get_adiabatic_conditions().temperature(position);
          const Point<1> profile_pos(P_ref);

          const double R = 8.314; // J/mol/K

          // Get cumulative reaction progress from compositional fields
          double xi_ol_wd_cumulative = enable_ol_wd_transformation ? in.composition[q][xi_ol_wd_idx] : 0.0;
          double xi_wd_ri_cumulative = enable_wd_ri_transformation ? in.composition[q][xi_wd_ri_idx] : 0.0;
          double xi_ri_ps_cumulative = enable_ri_ps_transformation ? in.composition[q][xi_ri_ps_idx] : 0.0;

          // Enforce bounds and ordering: 1 >= xi_ol_wd >= xi_wd_ri >= xi_ri_ps >= 0
          xi_ol_wd_cumulative = std::clamp(xi_ol_wd_cumulative, 0.0, 1.0);
          xi_wd_ri_cumulative = std::clamp(xi_wd_ri_cumulative, 0.0, xi_ol_wd_cumulative);
          xi_ri_ps_cumulative = std::clamp(xi_ri_ps_cumulative, 0.0, xi_wd_ri_cumulative);

          // Compute actual phase mass fractions from cumulative variables
          const double X_ol = std::max(0.0, 1.0 - xi_ol_wd_cumulative);
          const double X_wd = std::max(0.0, xi_ol_wd_cumulative - xi_wd_ri_cumulative);
          const double X_ri = std::max(0.0, xi_wd_ri_cumulative - xi_ri_ps_cumulative);
          const double X_ps = std::max(0.0, xi_ri_ps_cumulative);

          if (mtz_kinetics_out != nullptr)
            {
              mtz_kinetics_out->X_ol[q] = X_ol;
              mtz_kinetics_out->X_wd[q] = X_wd;
              mtz_kinetics_out->X_ri[q] = X_ri;
              mtz_kinetics_out->X_ps[q] = X_ps;
            }

          const double total_mass = X_ol + X_wd + X_ri + X_ps;
          AssertThrow(std::abs(total_mass - 1.0) < 1e-8, ExcMessage("Phase mass fractions do not sum to 1.0: " + std::to_string(total_mass)));

          // Storage for all four phases
          std::vector<double> densities(4, 0.0);
          std::vector<double> alphas(4, 0.0);
          std::vector<double> betas(4, 0.0);
          std::vector<double> cps(4, 0.0);
          std::vector<double> Vps(4, 0.0);
          std::vector<double> Vss(4, 0.0);
          std::vector<double> mass_fractions = {X_ol, X_wd, X_ri, X_ps};

          // Get properties from profiles (olivine and wadsleyite)
          if (enable_ol_wd_transformation)
            {
              densities[0] = profile_ol_wd.get_data_component(profile_pos, rho_ol_idx);
              densities[1] = profile_ol_wd.get_data_component(profile_pos, rho_wd_idx);
              alphas[0]    = profile_ol_wd.get_data_component(profile_pos, alpha_ol_idx);
              alphas[1]    = profile_ol_wd.get_data_component(profile_pos, alpha_wd_idx);
              betas[0]     = profile_ol_wd.get_data_component(profile_pos, beta_ol_idx);
              betas[1]     = profile_ol_wd.get_data_component(profile_pos, beta_wd_idx);
              cps[0]       = profile_ol_wd.get_data_component(profile_pos, cp_ol_idx);
              cps[1]       = profile_ol_wd.get_data_component(profile_pos, cp_wd_idx);

              if (seismic_out != nullptr && Vp_ol_idx != numbers::invalid_unsigned_int)
                {
                  Vps[0] = profile_ol_wd.get_data_component(profile_pos, Vp_ol_idx);
                  Vps[1] = profile_ol_wd.get_data_component(profile_pos, Vp_wd_idx);
                  if (dVp_dT_ol_idx != numbers::invalid_unsigned_int)
                    {
                      Vps[0] += profile_ol_wd.get_data_component(profile_pos, dVp_dT_ol_idx) * (T - T_ref);
                      Vps[1] += profile_ol_wd.get_data_component(profile_pos, dVp_dT_wd_idx) * (T - T_ref);
                    }
                }
              if (seismic_out != nullptr && Vs_ol_idx != numbers::invalid_unsigned_int)
                {
                  Vss[0] = profile_ol_wd.get_data_component(profile_pos, Vs_ol_idx);
                  Vss[1] = profile_ol_wd.get_data_component(profile_pos, Vs_wd_idx);
                  if (dVs_dT_ol_idx != numbers::invalid_unsigned_int)
                    {
                      Vss[0] += profile_ol_wd.get_data_component(profile_pos, dVs_dT_ol_idx) * (T - T_ref);
                      Vss[1] += profile_ol_wd.get_data_component(profile_pos, dVs_dT_wd_idx) * (T - T_ref);
                    }
                }
            }

          // Get properties from profiles (ringwoodite)
          if (enable_wd_ri_transformation)
            {
              densities[2] = profile_wd_ri.get_data_component(profile_pos, rho_ri_idx);
              alphas[2]    = profile_wd_ri.get_data_component(profile_pos, alpha_ri_idx);
              betas[2]     = profile_wd_ri.get_data_component(profile_pos, beta_ri_idx);
              cps[2]       = profile_wd_ri.get_data_component(profile_pos, cp_ri_idx);

              if (seismic_out != nullptr && Vp_ri_idx != numbers::invalid_unsigned_int)
                {
                  Vps[2] = profile_wd_ri.get_data_component(profile_pos, Vp_ri_idx);
                  if (dVp_dT_ri_idx != numbers::invalid_unsigned_int)
                    Vps[2] += profile_wd_ri.get_data_component(profile_pos, dVp_dT_ri_idx) * (T - T_ref);
                }
              if (seismic_out != nullptr && Vs_ri_idx != numbers::invalid_unsigned_int)
                {
                  Vss[2] = profile_wd_ri.get_data_component(profile_pos, Vs_ri_idx);
                  if (dVs_dT_ri_idx != numbers::invalid_unsigned_int)
                    Vss[2] += profile_wd_ri.get_data_component(profile_pos, dVs_dT_ri_idx) * (T - T_ref);
                }
            }

          // Get properties from profiles (post-spinel)
          if (enable_ri_ps_transformation)
            {
              densities[3] = profile_ri_ps.get_data_component(profile_pos, rho_ps_idx);
              alphas[3]    = profile_ri_ps.get_data_component(profile_pos, alpha_ps_idx);
              betas[3]     = profile_ri_ps.get_data_component(profile_pos, beta_ps_idx);
              cps[3]       = profile_ri_ps.get_data_component(profile_pos, cp_ps_idx);

              if (seismic_out != nullptr && Vp_ps_idx != numbers::invalid_unsigned_int)
                {
                  Vps[3] = profile_ri_ps.get_data_component(profile_pos, Vp_ps_idx);
                  if (dVp_dT_ps_idx != numbers::invalid_unsigned_int)
                    Vps[3] += profile_ri_ps.get_data_component(profile_pos, dVp_dT_ps_idx) * (T - T_ref);
                }
              if (seismic_out != nullptr && Vs_ps_idx != numbers::invalid_unsigned_int)
                {
                  Vss[3] = profile_ri_ps.get_data_component(profile_pos, Vs_ps_idx);
                  if (dVs_dT_ps_idx != numbers::invalid_unsigned_int)
                    Vss[3] += profile_ri_ps.get_data_component(profile_pos, dVs_dT_ps_idx) * (T - T_ref);
                }
            }

          // Compute volume fractions from mass fractions
          const std::vector<double> volume_fractions = MaterialUtilities::compute_volumes_from_masses(mass_fractions, densities, true);

          // Average density, thermal expansivity, compressibility (volume-weighted)
          const double rho_avg   = MaterialUtilities::average_value(volume_fractions, densities, MaterialUtilities::arithmetic);
          const double alpha_avg = MaterialUtilities::average_value(volume_fractions, alphas, MaterialUtilities::arithmetic);
          const double beta_avg  = MaterialUtilities::average_value(volume_fractions, betas, MaterialUtilities::arithmetic);

          // Average specific heat (mass-weighted)
          const double cp_avg = MaterialUtilities::average_value(mass_fractions, cps, MaterialUtilities::arithmetic);

          // Average seismic velocities (volume-weighted)
          if (seismic_out != nullptr && in.requests_property(MaterialProperties::additional_outputs))
            {
              if (Vps[0] > 0.0)
                seismic_out->vp[q] = MaterialUtilities::average_value(volume_fractions, Vps, MaterialUtilities::arithmetic);
              if (Vss[0] > 0.0)
                seismic_out->vs[q] = MaterialUtilities::average_value(volume_fractions, Vss, MaterialUtilities::arithmetic);
            }

          // Apply temperature and pressure corrections to density
          const double temperature_correction_density = (T - T_ref) * alpha_avg;
          const double pressure_correction_density    = use_dynamic_pressure_correction_for_density ? (P - P_ref) * beta_avg : 0.0;
          const double density_factor                 = (1.0 - temperature_correction_density) * (1.0 + pressure_correction_density);
          const double final_rho                      = rho_avg * density_factor;

          // Compute viscosity
          if (in.requests_property(MaterialProperties::viscosity))
            {
              // Temperature dependence: exp(-A * (T - T_ref) / T_ref)
              double visc_temperature_dependence = std::max(std::min(std::exp(-thermal_viscosity_exponent * (T - T_ref) / T_ref), 1e3), 1e-3);
              if (std::isnan(visc_temperature_dependence))
                visc_temperature_dependence = 1.0;

              // ---------------------------------------------------------------
              // Gibbs-based phase viscosity prefactor
              //
              // Viscosity jumps are anchored to the equilibrium phase boundaries (where dG = 0 along the reference adiabat) using tanh transitions
              // of width gibbs_viscosity_width (J/mol). This is fully decoupled from the kinetic Xi fields, so metastable nuclei in the slab do
              // not produce spurious viscosity patches.
              //
              // The chained construction ensures the stability fields are mutually exclusive and partition of unity:
              //   phi_ol  = above 410
              //   phi_wd  = between 410 and 520
              //   phi_ri  = between 520 and 660
              //   phi_ps  = below 660
              // ---------------------------------------------------------------
              const double w = gibbs_viscosity_width;

              // Transition fractions: f -> 1 when the high-pressure phase is stable (dG < 0)
              const double f_wd =
                enable_ol_wd_transformation ? 0.5 * (1.0 - std::tanh(profile_ol_wd.get_data_component(profile_pos, dG_ol_wd_idx) / w)) : 0.0;
              const double f_ri =
                enable_wd_ri_transformation ? 0.5 * (1.0 - std::tanh(profile_wd_ri.get_data_component(profile_pos, dG_wd_ri_idx) / w)) : 0.0;
              const double f_ps =
                enable_ri_ps_transformation ? 0.5 * (1.0 - std::tanh(profile_ri_ps.get_data_component(profile_pos, dG_ri_ps_idx) / w)) : 0.0;

              // Chained stability fractions (partition of unity)
              const double phi_ol = 1.0 - f_wd;
              const double phi_wd = f_wd * (1.0 - f_ri);
              const double phi_ri = f_wd * f_ri * (1.0 - f_ps);
              const double phi_ps = f_wd * f_ri * f_ps;

              // Log-linear (geometric) average of per-phase prefactors
              const double log_prefactor = phi_ol * std::log(visc_prefactor_ol) + phi_wd * std::log(visc_prefactor_wd) +
                                           phi_ri * std::log(visc_prefactor_ri) + phi_ps * std::log(visc_prefactor_ps);
              const double visc_depth_dependence = std::exp(log_prefactor);

              const double eta           = viscosity * visc_temperature_dependence * visc_depth_dependence;
              const double eta_effective = std::min(std::max(eta, minimum_viscosity), maximum_viscosity);

              out.viscosities[q] = eta_effective;

              if (mtz_kinetics_out != nullptr)
                mtz_kinetics_out->visc_temperature_dependence[q] = visc_temperature_dependence;
            }

          // Compute reaction rates with phase-topology constraints
          if (reaction_rate_out != nullptr)
            {
              const double time_scale = this->convert_output_to_years() ? year_in_seconds : 1.0;
              auto         clamp_exp  = [](double x) { return std::exp(std::clamp(x, -700.0, 700.0)); };

              // Olivine-wadsleyite reaction rate (interface-controlled)
              if (enable_ol_wd_transformation)
                {
                  const double dG_ol_wd = profile_ol_wd.get_data_component(profile_pos, dG_ol_wd_idx);
                  const double dS_ol_wd = profile_ol_wd.get_data_component(profile_pos, dS_ol_wd_idx);
                  const double dV_ol_wd = profile_ol_wd.get_data_component(profile_pos, dV_ol_wd_idx);

                  const double arrhenius_ol_wd         = clamp_exp(-(Ha_ol_wd + P * Va_ol_wd) / (R * T));
                  mtz_kinetics_out->arrhenius_ol_wd[q] = arrhenius_ol_wd;

                  const double temperature_correction_gibbs_ol_wd = (T - T_ref) * dS_ol_wd;
                  const double pressure_correction_gibbs_ol_wd    = use_dynamic_pressure_correction_for_gibbs ? (P - P_ref) * dV_ol_wd : 0.0;
                  const double gibbs_ol_wd                        = dG_ol_wd + pressure_correction_gibbs_ol_wd - temperature_correction_gibbs_ol_wd;

                  double thermodynamic_ol_wd = 0.0;
                  double reaction_rate_ol_wd = 0.0;

                  if (gibbs_ol_wd < 0.0) // Forward: olivine -> wadsleyite
                    {
                      thermodynamic_ol_wd = 1.0 - clamp_exp(gibbs_ol_wd / (R * T));
                      reaction_rate_ol_wd = kinetic_factor_ol_wd * T * arrhenius_ol_wd * thermodynamic_ol_wd * X_ol;
                    }
                  else // Reverse: wadsleyite -> olivine
                    {
                      thermodynamic_ol_wd = 1.0 - clamp_exp(-gibbs_ol_wd / (R * T));
                      reaction_rate_ol_wd = -kinetic_factor_ol_wd * T * arrhenius_ol_wd * thermodynamic_ol_wd * X_wd;
                    }

                  mtz_kinetics_out->thermodynamic_ol_wd[q]           = gibbs_ol_wd < 0.0 ? thermodynamic_ol_wd : -thermodynamic_ol_wd;
                  reaction_rate_out->reaction_rates[q][xi_ol_wd_idx] = reaction_rate_ol_wd / time_scale;
                }

              // Wadsleyite-ringwoodite reaction rate (interface-controlled)
              if (enable_wd_ri_transformation)
                {
                  const double dG_wd_ri = profile_wd_ri.get_data_component(profile_pos, dG_wd_ri_idx);
                  const double dS_wd_ri = profile_wd_ri.get_data_component(profile_pos, dS_wd_ri_idx);
                  const double dV_wd_ri = profile_wd_ri.get_data_component(profile_pos, dV_wd_ri_idx);

                  const double arrhenius_wd_ri         = clamp_exp(-(Ha_wd_ri + P * Va_wd_ri) / (R * T));
                  mtz_kinetics_out->arrhenius_wd_ri[q] = arrhenius_wd_ri;

                  const double temperature_correction_gibbs_wd_ri = (T - T_ref) * dS_wd_ri;
                  const double pressure_correction_gibbs_wd_ri    = use_dynamic_pressure_correction_for_gibbs ? (P - P_ref) * dV_wd_ri : 0.0;
                  const double gibbs_wd_ri                        = dG_wd_ri + pressure_correction_gibbs_wd_ri - temperature_correction_gibbs_wd_ri;

                  double thermodynamic_wd_ri = 0.0;
                  double reaction_rate_wd_ri = 0.0;

                  if (gibbs_wd_ri < 0.0) // Forward: wadsleyite -> ringwoodite
                    {
                      thermodynamic_wd_ri = 1.0 - clamp_exp(gibbs_wd_ri / (R * T));
                      reaction_rate_wd_ri = kinetic_factor_wd_ri * T * arrhenius_wd_ri * thermodynamic_wd_ri * X_wd;
                    }
                  else // Reverse: ringwoodite -> wadsleyite
                    {
                      thermodynamic_wd_ri = 1.0 - clamp_exp(-gibbs_wd_ri / (R * T));
                      reaction_rate_wd_ri = -kinetic_factor_wd_ri * T * arrhenius_wd_ri * thermodynamic_wd_ri * X_ri;
                    }

                  mtz_kinetics_out->thermodynamic_wd_ri[q]           = gibbs_wd_ri < 0.0 ? thermodynamic_wd_ri : -thermodynamic_wd_ri;
                  reaction_rate_out->reaction_rates[q][xi_wd_ri_idx] = reaction_rate_wd_ri / time_scale;
                }

              // Ringwoodite-postspinel reaction rate (diffusion-controlled)
              if (enable_ri_ps_transformation)
                {
                  const double dG_ri_ps = profile_ri_ps.get_data_component(profile_pos, dG_ri_ps_idx);
                  const double dS_ri_ps = profile_ri_ps.get_data_component(profile_pos, dS_ri_ps_idx);
                  const double dV_ri_ps = profile_ri_ps.get_data_component(profile_pos, dV_ri_ps_idx);

                  const double arrhenius_ri_ps         = clamp_exp(-Ea_ri_ps / (R * T));
                  mtz_kinetics_out->arrhenius_ri_ps[q] = arrhenius_ri_ps;

                  const double temperature_correction_gibbs_ri_ps = (T - T_ref) * dS_ri_ps;
                  const double pressure_correction_gibbs_ri_ps    = use_dynamic_pressure_correction_for_gibbs ? (P - P_ref) * dV_ri_ps : 0.0;
                  const double gibbs_ri_ps                        = dG_ri_ps + pressure_correction_gibbs_ri_ps - temperature_correction_gibbs_ri_ps;

                  const double thermodynamic_ri_ps         = -gibbs_ri_ps * std::abs(gibbs_ri_ps);
                  mtz_kinetics_out->thermodynamic_ri_ps[q] = thermodynamic_ri_ps;

                  double reaction_rate_ri_ps = 0.0;

                  if (gibbs_ri_ps < 0.0) // Forward: ringwoodite -> postspinel
                    reaction_rate_ri_ps = kinetic_factor_ri_ps * thermodynamic_ri_ps * arrhenius_ri_ps * X_ri;
                  else // Reverse: postspinel -> ringwoodite
                    reaction_rate_ri_ps = kinetic_factor_ri_ps * thermodynamic_ri_ps * arrhenius_ri_ps * X_ps;

                  reaction_rate_out->reaction_rates[q][xi_ri_ps_idx] = reaction_rate_ri_ps / time_scale;
                }

              // Zero out all other reaction rates
              for (unsigned int c = 0; c < this->introspection().n_compositional_fields; ++c)
                {
                  if ((enable_ol_wd_transformation && c == xi_ol_wd_idx) || (enable_wd_ri_transformation && c == xi_wd_ri_idx) ||
                      (enable_ri_ps_transformation && c == xi_ri_ps_idx))
                    continue;
                  reaction_rate_out->reaction_rates[q][c] = 0.0;
                }
            }

          // Update material model outputs
          out.densities[q]                      = final_rho;
          out.thermal_expansion_coefficients[q] = alpha_avg;
          out.compressibilities[q]              = beta_avg;
          out.thermal_conductivities[q]         = k;
          out.specific_heat[q]                  = cp_avg;
          out.entropy_derivative_pressure[q]    = 0.0;
          out.entropy_derivative_temperature[q] = 0.0;

          for (unsigned int c = 0; c < this->introspection().n_compositional_fields; ++c)
            out.reaction_terms[q][c] = 0.0;
        }

      // Calculate projected density reaction terms
      if (projected_density_idx != numbers::invalid_unsigned_int)
        for (unsigned int q = 0; q < in.n_evaluation_points(); ++q)
          out.reaction_terms[q][projected_density_idx] = out.densities[q] - in.composition[q][projected_density_idx];

      // Update projected density field
      if (prescribed_field_out != nullptr && projected_density_idx != numbers::invalid_unsigned_int)
        for (unsigned int i = 0; i < in.position.size(); ++i)
          prescribed_field_out->prescribed_field_outputs[i][projected_density_idx] = out.densities[i];
    }



    template <int dim>
    void
    MTZKinetics<dim>::declare_parameters(ParameterHandler &prm)
    {
      prm.enter_subsection("Material model");
      {
        prm.enter_subsection("MTZ kinetics");
        {
          prm.declare_entry("Enable olivine wadsleyite transformation",
                            "true",
                            Patterns::Bool(),
                            "Enable the olivine <-> wadsleyite phase transformation.");
          prm.declare_entry("Enable wadsleyite ringwoodite transformation",
                            "false",
                            Patterns::Bool(),
                            "Enable the wadsleyite <-> ringwoodite phase transformation.");
          prm.declare_entry("Enable ringwoodite postspinel transformation",
                            "false",
                            Patterns::Bool(),
                            "Enable the ringwoodite <-> bridgmanite + periclase phase transformation.");

          prm.declare_entry("Use dynamic pressure correction for density", "true", Patterns::Bool(), "Apply dynamic pressure correction to density.");
          prm.declare_entry("Use dynamic pressure correction for gibbs",
                            "false",
                            Patterns::Bool(),
                            "Apply dynamic pressure correction to Gibbs free energy.");

          prm.declare_entry("Viscosity", "1e21", Patterns::Double(0.), "Reference viscosity. Units: Pa s");
          prm.declare_entry("Minimum viscosity", "1e19", Patterns::Double(0.), "Minimum viscosity cutoff. Units: Pa s");
          prm.declare_entry("Maximum viscosity", "1e24", Patterns::Double(0.), "Maximum viscosity cutoff. Units: Pa s");
          prm.declare_entry("Thermal viscosity exponent", "0.0", Patterns::Double(0.), "Exponent A in exp(-A*(T-T_ref)/T_ref). Dimensionless.");

          prm.declare_entry("Viscosity prefactor olivine",
                            "1.0",
                            Patterns::Double(0.),
                            "Viscosity prefactor for olivine stability field. Dimensionless.");
          prm.declare_entry("Viscosity prefactor wadsleyite",
                            "1.0",
                            Patterns::Double(0.),
                            "Viscosity prefactor for wadsleyite stability field. Dimensionless.");
          prm.declare_entry("Viscosity prefactor ringwoodite",
                            "1.0",
                            Patterns::Double(0.),
                            "Viscosity prefactor for ringwoodite stability field. Dimensionless.");
          prm.declare_entry("Viscosity prefactor postspinel",
                            "1.0",
                            Patterns::Double(0.),
                            "Viscosity prefactor for post-spinel stability field. Dimensionless.");
          prm.declare_entry("Gibbs viscosity width",
                            "1000.0",
                            Patterns::Double(0.),
                            "Width of the tanh viscosity transition in Gibbs free energy space. "
                            "Controls sharpness of viscosity jumps at equilibrium phase boundaries. "
                            "Smaller values give sharper transitions. ~1000 J/mol gives a transition "
                            "spread of a few km. Units: J/mol");

          prm.declare_entry("Thermal conductivity", "4.0", Patterns::Double(0.), "Reference thermal conductivity. Units: W/m/K");

          // Olivine-wadsleyite parameters
          prm.enter_subsection("Olivine wadsleyite");
          {
            Utilities::AsciiDataProfile<dim>::declare_parameters(prm, "$ASPECT_SOURCE_DIR/cookbooks/mtz_kinetics/", "olivine-wadsleyite-profile.tsv");
            prm.declare_entry("Data directory",
                              "$ASPECT_SOURCE_DIR/cookbooks/mtz_kinetics/",
                              Patterns::DirectoryName(),
                              "Directory containing the olivine-wadsleyite thermodynamic data file.");
            prm.declare_entry("Data file name",
                              "olivine-wadsleyite-profile.tsv",
                              Patterns::Anything(),
                              "Name of the olivine-wadsleyite thermodynamic data file.");
            prm.declare_entry("Kinetic factor",
                              "7.0e7",
                              Patterns::Double(0.0),
                              "Z for olivine-wadsleyite: dX/dt = Z*T*exp(-Ha+PVa/RT)*(1-exp(dG/RT))*X. Units: 1/s/K");
            prm.declare_entry("Activation enthalpy", "274e3", Patterns::Double(0.0), "Ha for olivine-wadsleyite. Units: J/mol");
            prm.declare_entry("Activation volume", "3.3e-6", Patterns::Double(0.0), "Va for olivine-wadsleyite. Units: m^3/mol");
          }
          prm.leave_subsection();

          // Wadsleyite-ringwoodite parameters
          prm.enter_subsection("Wadsleyite ringwoodite");
          {
            Utilities::AsciiDataProfile<dim>::declare_parameters(prm,
                                                                 "$ASPECT_SOURCE_DIR/cookbooks/mtz_kinetics/",
                                                                 "wadsleyite-ringwoodite-profile.tsv");
            prm.declare_entry("Data directory",
                              "$ASPECT_SOURCE_DIR/cookbooks/mtz_kinetics/",
                              Patterns::DirectoryName(),
                              "Directory containing the wadsleyite-ringwoodite thermodynamic data file.");
            prm.declare_entry("Data file name",
                              "wadsleyite-ringwoodite-profile.tsv",
                              Patterns::Anything(),
                              "Name of the wadsleyite-ringwoodite thermodynamic data file.");
            prm.declare_entry("Kinetic factor",
                              "7.0e7",
                              Patterns::Double(0.0),
                              "Z for wadsleyite-ringwoodite: dX/dt = Z*T*exp(-Ha+PVa/RT)*(1-exp(dG/RT))*X. Units: 1/s/K");
            prm.declare_entry("Activation enthalpy", "274e3", Patterns::Double(0.0), "Ha for wadsleyite-ringwoodite. Units: J/mol");
            prm.declare_entry("Activation volume", "3.3e-6", Patterns::Double(0.0), "Va for wadsleyite-ringwoodite. Units: m^3/mol");
          }
          prm.leave_subsection();

          // Ringwoodite-postspinel parameters
          prm.enter_subsection("Ringwoodite postspinel");
          {
            Utilities::AsciiDataProfile<dim>::declare_parameters(prm,
                                                                 "$ASPECT_SOURCE_DIR/cookbooks/mtz_kinetics/",
                                                                 "ringwoodite-postspinel-profile.tsv");
            prm.declare_entry("Data directory",
                              "$ASPECT_SOURCE_DIR/cookbooks/mtz_kinetics/",
                              Patterns::DirectoryName(),
                              "Directory containing the ringwoodite-postspinel thermodynamic data file.");
            prm.declare_entry("Data file name",
                              "ringwoodite-postspinel-profile.tsv",
                              Patterns::Anything(),
                              "Name of the ringwoodite-postspinel thermodynamic data file.");
            prm.declare_entry("Kinetic factor",
                              "2.7e-16",
                              Patterns::Double(0.0),
                              "Z for ringwoodite-postspinel: dX/dt = Z*-dG*|dG|*exp(-Ea/RT)*X. Units: mol^2/J^2/s");
            prm.declare_entry("Activation energy", "355e3", Patterns::Double(0.0), "Ea for ringwoodite-postspinel (Kubo et al. 2002). Units: J/mol");
          }
          prm.leave_subsection();
        }
        prm.leave_subsection();
      }
      prm.leave_subsection();
    }



    template <int dim>
    void
    MTZKinetics<dim>::parse_parameters(ParameterHandler &prm)
    {
      prm.enter_subsection("Material model");
      {
        prm.enter_subsection("MTZ kinetics");
        {
          enable_ol_wd_transformation = prm.get_bool("Enable olivine wadsleyite transformation");
          enable_wd_ri_transformation = prm.get_bool("Enable wadsleyite ringwoodite transformation");
          enable_ri_ps_transformation = prm.get_bool("Enable ringwoodite postspinel transformation");

          if (enable_ol_wd_transformation)
            {
              prm.enter_subsection("Olivine wadsleyite");
              {
                data_directory_ol_wd = Utilities::expand_ASPECT_SOURCE_DIR(prm.get("Data directory"));
                data_filename_ol_wd  = prm.get("Data file name");
                prm.enter_subsection("Ascii data model");
                {
                  prm.set("Data directory", data_directory_ol_wd);
                  prm.set("Data file name", data_filename_ol_wd);
                }
                prm.leave_subsection();
                profile_ol_wd.parse_parameters(prm);
                kinetic_factor_ol_wd = prm.get_double("Kinetic factor");
                Ha_ol_wd             = prm.get_double("Activation enthalpy");
                Va_ol_wd             = prm.get_double("Activation volume");
              }
              prm.leave_subsection();
            }

          if (enable_wd_ri_transformation)
            {
              prm.enter_subsection("Wadsleyite ringwoodite");
              {
                data_directory_wd_ri = Utilities::expand_ASPECT_SOURCE_DIR(prm.get("Data directory"));
                data_filename_wd_ri  = prm.get("Data file name");
                prm.enter_subsection("Ascii data model");
                {
                  prm.set("Data directory", data_directory_wd_ri);
                  prm.set("Data file name", data_filename_wd_ri);
                }
                prm.leave_subsection();
                profile_wd_ri.parse_parameters(prm);
                kinetic_factor_wd_ri = prm.get_double("Kinetic factor");
                Ha_wd_ri             = prm.get_double("Activation enthalpy");
                Va_wd_ri             = prm.get_double("Activation volume");
              }
              prm.leave_subsection();
            }

          if (enable_ri_ps_transformation)
            {
              prm.enter_subsection("Ringwoodite postspinel");
              {
                data_directory_ri_ps = Utilities::expand_ASPECT_SOURCE_DIR(prm.get("Data directory"));
                data_filename_ri_ps  = prm.get("Data file name");
                prm.enter_subsection("Ascii data model");
                {
                  prm.set("Data directory", data_directory_ri_ps);
                  prm.set("Data file name", data_filename_ri_ps);
                }
                prm.leave_subsection();
                profile_ri_ps.parse_parameters(prm);
                kinetic_factor_ri_ps = prm.get_double("Kinetic factor");
                Ea_ri_ps             = prm.get_double("Activation energy");
              }
              prm.leave_subsection();
            }

          viscosity                                   = prm.get_double("Viscosity");
          minimum_viscosity                           = prm.get_double("Minimum viscosity");
          maximum_viscosity                           = prm.get_double("Maximum viscosity");
          thermal_viscosity_exponent                  = prm.get_double("Thermal viscosity exponent");
          visc_prefactor_ol                           = prm.get_double("Viscosity prefactor olivine");
          visc_prefactor_wd                           = prm.get_double("Viscosity prefactor wadsleyite");
          visc_prefactor_ri                           = prm.get_double("Viscosity prefactor ringwoodite");
          visc_prefactor_ps                           = prm.get_double("Viscosity prefactor postspinel");
          gibbs_viscosity_width                       = prm.get_double("Gibbs viscosity width");
          k                                           = prm.get_double("Thermal conductivity");
          use_dynamic_pressure_correction_for_density = prm.get_bool("Use dynamic pressure correction for density");
          use_dynamic_pressure_correction_for_gibbs   = prm.get_bool("Use dynamic pressure correction for gibbs");
        }
        prm.leave_subsection();
      }
      prm.leave_subsection();

      AssertThrow(enable_ol_wd_transformation || enable_wd_ri_transformation || enable_ri_ps_transformation,
                  ExcMessage("At least one phase transformation must be enabled."));

      AssertThrow(gibbs_viscosity_width > 0.0, ExcMessage("Gibbs viscosity width must be positive."));

      this->model_dependence.viscosity            = NonlinearDependence::none;
      this->model_dependence.density              = NonlinearDependence::pressure | NonlinearDependence::temperature;
      this->model_dependence.compressibility      = NonlinearDependence::none;
      this->model_dependence.specific_heat        = NonlinearDependence::none;
      this->model_dependence.thermal_conductivity = NonlinearDependence::none;
    }



    template <int dim>
    void
    MTZKinetics<dim>::create_additional_named_outputs(MaterialModel::MaterialModelOutputs<dim> &out) const
    {
      if (out.template get_additional_output_object<ReactionRateOutputs<dim>>() == nullptr)
        {
          const unsigned int n_points = out.n_evaluation_points();
          out.additional_outputs.push_back(
            std::make_unique<MaterialModel::ReactionRateOutputs<dim>>(n_points, this->introspection().n_compositional_fields));
        }

      if (this->introspection().composition_type_exists(CompositionalFieldDescription::density) &&
          out.template get_additional_output_object<PrescribedFieldOutputs<dim>>() == nullptr)
        {
          const unsigned int n_points = out.n_evaluation_points();
          out.additional_outputs.push_back(
            std::make_unique<MaterialModel::PrescribedFieldOutputs<dim>>(n_points, this->introspection().n_compositional_fields));
        }

      if (out.template get_additional_output_object<MTZKineticsOutputs<dim>>() == nullptr)
        {
          const unsigned int n_points = out.n_evaluation_points();
          out.additional_outputs.push_back(std::make_unique<MaterialModel::MTZKineticsOutputs<dim>>(n_points));
        }

      if (out.template get_additional_output_object<SeismicAdditionalOutputs<dim>>() == nullptr)
        {
          const unsigned int n_points = out.n_evaluation_points();
          out.additional_outputs.push_back(std::make_unique<MaterialModel::SeismicAdditionalOutputs<dim>>(n_points));
        }
    }



    namespace
    {
      std::vector<std::string>
      make_additional_output_names()
      {
        std::vector<std::string> names;
        names.emplace_back("arrhenius_ol_wd");
        names.emplace_back("arrhenius_wd_ri");
        names.emplace_back("arrhenius_ri_ps");
        names.emplace_back("thermodynamic_ol_wd");
        names.emplace_back("thermodynamic_wd_ri");
        names.emplace_back("thermodynamic_ri_ps");
        names.emplace_back("visc_temperature_dependence");
        names.emplace_back("X_ol");
        names.emplace_back("X_wd");
        names.emplace_back("X_ri");
        names.emplace_back("X_ps");
        return names;
      }
    } // namespace

    template <int dim>
    MTZKineticsOutputs<dim>::MTZKineticsOutputs(const unsigned int n_points)
      : NamedAdditionalMaterialOutputs<dim>(make_additional_output_names())
      , arrhenius_ol_wd(n_points, numbers::signaling_nan<double>())
      , arrhenius_wd_ri(n_points, numbers::signaling_nan<double>())
      , arrhenius_ri_ps(n_points, numbers::signaling_nan<double>())
      , thermodynamic_ol_wd(n_points, numbers::signaling_nan<double>())
      , thermodynamic_wd_ri(n_points, numbers::signaling_nan<double>())
      , thermodynamic_ri_ps(n_points, numbers::signaling_nan<double>())
      , visc_temperature_dependence(n_points, numbers::signaling_nan<double>())
      , X_ol(n_points, numbers::signaling_nan<double>())
      , X_wd(n_points, numbers::signaling_nan<double>())
      , X_ri(n_points, numbers::signaling_nan<double>())
      , X_ps(n_points, numbers::signaling_nan<double>())
    {}



    template <int dim>
    std::vector<double>
    MTZKineticsOutputs<dim>::get_nth_output(const unsigned int idx) const
    {
      AssertIndexRange(idx, make_additional_output_names().size());
      switch (idx)
        {
          case 0:
            return arrhenius_ol_wd;
          case 1:
            return arrhenius_wd_ri;
          case 2:
            return arrhenius_ri_ps;
          case 3:
            return thermodynamic_ol_wd;
          case 4:
            return thermodynamic_wd_ri;
          case 5:
            return thermodynamic_ri_ps;
          case 6:
            return visc_temperature_dependence;
          case 7:
            return X_ol;
          case 8:
            return X_wd;
          case 9:
            return X_ri;
          case 10:
            return X_ps;
          default:
            AssertThrow(false, ExcInternalError());
        }
      return visc_temperature_dependence;
    }
  } // namespace MaterialModel
} // namespace aspect

namespace aspect
{
  namespace MaterialModel
  {
    ASPECT_REGISTER_MATERIAL_MODEL(
      MTZKinetics,
      "MTZ kinetics",
      "Models phase transformations for three reactions with stoichiometric coupling:\n"
      "(1: interface-controlled) Olivine <-> wadsleyite (Hosoya et al. 2005): dX/dt = Z * T * exp(-Ha + PVa/RT) * (1 - exp(dG/RT)) * X\n"
      "(2: interface-controlled) Wadsleyite <-> ringwoodite: dX/dt = Z * T * exp(-Ha + PVa/RT) * (1 - exp(dG/RT)) * X\n"
      "(3: diffusion-controlled) Ringwoodite <-> bridgmanite + periclase (Kubo et al. 2002): dX/dt = Z * -dG * |dG| * exp(-Ea/RT) * X\n\n"
      "Compositional fields xi_ol_wd, xi_wd_ri, xi_ri_ps are cumulative reaction progress variables.\n"
      "Actual phase fractions: X_ol = 1 - xi_ol_wd, X_wd = xi_ol_wd - xi_wd_ri, X_ri = xi_wd_ri - xi_ri_ps, X_ps = xi_ri_ps.\n\n"
      "Viscosity uses per-phase prefactors blended via tanh transitions centred on the equilibrium phase boundaries\n"
      "(where dG = 0 along the reference adiabat). This decouples the viscosity structure from the kinetic phase\n"
      "fields, preventing spurious viscosity patches from metastable nuclei in subducting slabs.\n"
      "Transition sharpness is controlled by 'Gibbs viscosity width' (J/mol).")
  } // namespace MaterialModel
} // namespace aspect
