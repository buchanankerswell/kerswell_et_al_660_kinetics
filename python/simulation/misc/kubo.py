#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
from argparse import ArgumentParser, Namespace
from dataclasses import dataclass
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from scipy import stats


#######################################################
## .1. Dataclasses                               !!! ##
#######################################################
@dataclass(frozen=True)
class RegressionResults:
    """
    Container for Monte Carlo Arrhenius regression statistics.

    Attributes:
        ea_samples (np.ndarray): Array of sampled Activation Energies [J/mol].
        ea_mean (float): Mean Activation Energy [J/mol].
        kp_geo_mean (float): Geometric mean of the pre-exponential factor.
        inv_t_mean (np.ndarray): Mean of 1/T samples [K^-1].
        inv_t_std (np.ndarray): Standard deviation of 1/T samples.
        lny_mean (np.ndarray): Mean of natural log growth rate samples.
        lny_std (np.ndarray): Standard deviation of log growth rate samples.
    """

    ea_samples: np.ndarray
    ea_mean: float
    kp_geo_mean: float
    lnk_std: float
    inv_t_mean: np.ndarray
    inv_t_std: np.ndarray
    lny_mean: np.ndarray
    lny_std: np.ndarray
    slope_samples: np.ndarray
    intercept_samples: np.ndarray


@dataclass(frozen=True)
class KuboConstants:
    """Thermodynamic constants for the Ringwoodite-Postspinel transition."""

    R: float = 8.314  # J/mol/K
    sigma_T: float = 30.0  # K uncertainty
    v_ringwoodite: float = 36.506e-6  # m^3/mol
    v_postspinel: float = 33.806e-6  # m^3/mol

    @property
    def dv(self) -> float:
        """Molar volume change [m^3/mol]."""
        return abs(self.v_postspinel - self.v_ringwoodite)


#######################################################
## .2. Logic                                     !!! ##
#######################################################
def parse_arguments() -> Namespace:
    """
    Handles command-line argument parsing for Kubo regression.

    Returns:
        argparse.Namespace: The parsed command-line arguments.
    """
    parser = ArgumentParser(description="Regress and visualize Kubo dataset.")
    parser.add_argument("--out-fig-dir", type=str, help="Output figure directory")

    return parser.parse_args()


def regress_kubo2002_dataset(n_monte_carlo: int = 10000) -> RegressionResults:
    """
    Performs Monte Carlo linear regression on the Kubo et al. (2002) dataset.

    Args:
        n_monte_carlo: Number of iterations for uncertainty propagation.

    Returns:
        RegressionResults: Dataclass containing mean values and distributions.
    """
    c = KuboConstants()

    # Experimental data (Kubo et al. 2002)
    t_c = np.array([1085, 1010, 1010, 960, 910])
    p_gpa = np.array([5.0, 5.4, 4.1, 5.1, 3.5])
    xdot_min = np.array([0.8e-8, 0.8e-8, 0.8e-8, 4.8e-11, 1.9e-10])
    xdot_max = np.array([2.6e-8, 2.6e-8, 2.6e-8, 1.5e-10, 6.2e-10])

    t_kelvin = t_c + 273.15
    p_pascal = p_gpa * 1e9

    ea_samples = np.zeros(n_monte_carlo)
    kp_samples = np.zeros(n_monte_carlo)
    invt_samples = np.zeros((n_monte_carlo, len(t_kelvin)))
    lny_samples = np.zeros((n_monte_carlo, len(t_kelvin)))
    slopes = np.zeros(n_monte_carlo)
    intercepts = np.zeros(n_monte_carlo)

    rng = np.random.default_rng(42)

    for i in range(n_monte_carlo):
        t_sample = rng.normal(t_kelvin, c.sigma_T)
        inv_t = 1.0 / t_sample

        log_xdot = rng.uniform(np.log(xdot_min), np.log(xdot_max))
        xdot = np.exp(log_xdot)

        gv = (p_pascal * c.dv) / c.v_postspinel
        lny = np.log(xdot / (gv**2))

        invt_samples[i, :] = inv_t
        lny_samples[i, :] = lny

        res_lin = stats.linregress(inv_t, lny)

        slopes[i] = float(res_lin.slope)  # type: ignore
        intercepts[i] = float(res_lin.intercept)  # type: ignore

        ea_samples[i] = -slopes[i] * c.R
        kp_samples[i] = np.exp(intercepts[i])

    lnk_mean = np.mean(intercepts)
    lnk_std = np.std(intercepts)

    res = RegressionResults(
        ea_samples=ea_samples,
        ea_mean=float(np.mean(ea_samples)),
        kp_geo_mean=float(np.exp(lnk_mean)),
        lnk_std=float(lnk_std),
        inv_t_mean=np.mean(invt_samples, axis=0),
        inv_t_std=np.std(invt_samples, axis=0),
        lny_mean=np.mean(lny_samples, axis=0),
        lny_std=np.std(lny_samples, axis=0),
        slope_samples=slopes,
        intercept_samples=intercepts,
    )

    print(f"    Mean E_a          = {res.ea_mean/1e3:.0f} ± {np.std(res.ea_samples)/1e3:.0f} kJ/mol")
    print(f"    Mean ln(K')       = {lnk_mean:.1f} ± {lnk_std:.1f}")
    print(f"    Geometric mean K' = {res.kp_geo_mean:.3e}")

    return res


def visualize(results: RegressionResults, out_path: Path) -> None:
    """
    Plots the Arrhenius fit and Activation Energy distribution.
    """
    r_const = 8.314
    ea_paper = 355e3

    plt.rcParams.update(
        {
            "figure.dpi": 300,
            "savefig.bbox": "tight",
            "axes.facecolor": "0.9",
            "axes.edgecolor": "#4D4D4D",
            "legend.frameon": False,
            "legend.facecolor": "0.9",
            "legend.loc": "upper left",
            "legend.fontsize": "small",
            "figure.autolayout": True,
            "axes.labelsize": 16,
            "xtick.labelsize": 13,
            "ytick.labelsize": 13,
            "xtick.color": "#4D4D4D",
            "ytick.color": "#4D4D4D",
        }
    )

    x_fit = np.linspace(0.00068, 0.00105, 200)
    y_fit = np.log(results.kp_geo_mean) - (results.ea_mean / r_const) * x_fit
    y_paper = np.mean(results.lny_mean) - (ea_paper / r_const) * (x_fit - np.mean(results.inv_t_mean))

    ea_std = np.std(results.ea_samples) / 1e3
    mean_ea_kj = results.ea_mean / 1e3

    lnk_label_val = np.log(results.kp_geo_mean)

    all_preds = results.intercept_samples[:, np.newaxis] + results.slope_samples[:, np.newaxis] * x_fit
    y_low = np.percentile(all_preds, 2.5, axis=0)
    y_high = np.percentile(all_preds, 97.5, axis=0)

    _, (ax1, ax2) = plt.subplots(1, 2, figsize=(6.5, 3.3))

    ax1.fill_between(1e3 * x_fit, y_low, y_high, color="black", alpha=0.1, label="95% CI", zorder=1)
    ax1.plot(1e3 * x_fit, y_fit, color="black", linewidth=1, label="Monte Carlo", zorder=2)
    ax1.plot(1e3 * x_fit, y_paper, color="black", linewidth=1, alpha=0.2, label="Kubo02", zorder=2)
    ax1.errorbar(
        1e3 * results.inv_t_mean,
        results.lny_mean,
        xerr=2 * 1e3 * results.inv_t_std,
        yerr=2 * results.lny_std,
        fmt="o",
        color="black",
        capsize=2,
        markeredgewidth=0.6,
        markersize=5,
        linewidth=0.6,
        zorder=3,
    )

    ax1.text(0.96, 0.96, f"ln($K'$): {lnk_label_val:.1f} $\\pm$ {2*results.lnk_std:.1f}", transform=ax1.transAxes, ha="right", va="top", fontsize=13)
    ax1.set_xlim(0.68, 1.05)
    ax1.set_xticks([0.7, 0.8, 0.9, 1.0])
    ax1.set_yticks([-55, -65, -75])
    ax1.set_xlabel("1000 / T (K$^{-1}$)")
    ax1.set_ylabel("ln($\\dot{\\mathrm{x}}$ / $\\Delta\\mathrm{G}_\\mathrm{v}^2$)")
    ax1.legend(fontsize=13, loc="lower left")
    ax1.tick_params(axis="both", which="both", length=0)

    ax2.hist(results.ea_samples / 1e3, bins=50, color="gray", edgecolor="black")
    ax2.axvspan(mean_ea_kj - 2 * ea_std, mean_ea_kj + 2 * ea_std, color="black", alpha=0.1)
    ax2.text(0.03, 0.96, f"$E_a$: {mean_ea_kj:.0f} $\\pm$ {2*ea_std:.0f}", transform=ax2.transAxes, ha="left", va="top", fontsize=13)
    ax2.set_xlim(-200, 800)
    ax2.set_ylim(0, 1300)
    ax2.set_xticks([-100, 300, 700])
    ax2.set_yticks([])
    ax2.set_xlabel("Ea (kJ/mol)")
    ax2.tick_params(axis="both", which="both", length=0)

    plt.savefig(out_path)


#######################################################
## .3. Main                                      !!! ##
#######################################################
def main() -> None:
    """Main execution path."""
    args = parse_arguments()
    out_dir = Path(args.out_fig_dir) if args.out_fig_dir else Path("./figures")
    out_path = out_dir / "regression.png"

    if out_path.exists():
        return

    out_path.parent.mkdir(parents=True, exist_ok=True)

    print(" .. Processing Kubo et al. (2002) Dataset")
    results = regress_kubo2002_dataset()
    visualize(results, out_path)
    print(f" -> {out_path}")


if __name__ == "__main__":
    main()
