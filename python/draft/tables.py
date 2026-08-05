#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
from pathlib import Path

import pandas as pd


#######################################################
## .1. Write markdown table                      !!! ##
#######################################################
def csv_to_rounded_markdown(in_path, out_path):
    """ """
    try:
        df = pd.read_csv(in_path)
        df.drop(["timestep", "time_myr", "max_velocity", "max_strain_rate"], axis=1, inplace=True)
        df["model_id"] = df["model_id"].str.replace("_", "-")
        df["group_type"] = df["model_id"].apply(lambda x: "plume" if "plume" in x else "slab")
        df = df.sort_values(by=["group_type", "max_reaction_rate"], ascending=True)
        df = df.drop(columns=["group_type"])

        two_decimal = ["displacement", "width"]
        three_decimal = ["max_reaction_rate"]

        for col in two_decimal + three_decimal:
            if col in ["displacement", "width"]:
                df[col] = df[col] / 1e3
            if col in two_decimal:
                df[col] = df[col].round(2)
            if col in three_decimal:
                df[col] = df[col].round(3)

        markdown_table = df.to_markdown(index=False)

        with open(out_path, "w") as md_file:
            md_file.write(markdown_table)

        print(f" -> Successfully created a rounded Markdown table at: {out_path.name}")

    except FileNotFoundError:
        print(f" !! Error: the file '{in_path.name}' was not found!")
    except Exception as e:
        print(f" !! Error: {e}")


if __name__ == "__main__":
    in_path = Path("../simulation/data/centerline-profile-data.csv")
    out_path = Path("../../draft/centerline-profile-results.md")

    csv_to_rounded_markdown(in_path, out_path)
