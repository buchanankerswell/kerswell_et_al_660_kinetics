#######################################################
## .0. Load Libraries                            !!! ##
#######################################################
import argparse
import re
import sys
from dataclasses import dataclass


#######################################################
## .1. PrmGenerator                                 !!! ##
#######################################################
@dataclass(frozen=True)
class PrmGenerator:
    """
    Container for ASPECT parameter file template mapping.

    Attributes:
        template_path (str): Path to the input .prm template.
        output_path (str): Path where the rendered file will be saved.
        mapping (dict[str, str]): Key-value pairs for placeholder substitution.
    """

    template_path: str
    output_path: str
    mapping: dict[str, str]


def parse_arguments() -> argparse.Namespace:
    """
    Handles command-line argument parsing for PRM generation.

    Returns:
        argparse.Namespace: The parsed command-line arguments.
    """
    parser = argparse.ArgumentParser(description="Generate ASPECT .prm files from templates by replacing {key} placeholders.")
    parser.add_argument("template", help="Path to the .prm template file")
    parser.add_argument("output", help="Path to save the generated .prm file")
    parser.add_argument("params", nargs="+", help="Key-value pairs in 'key=value' format")

    return parser.parse_args()


def generate_prm(config: PrmGenerator) -> None:
    """
    Performs placeholder substitution and cleans up formatting for ASPECT .prm files.

    Args:
        config: A PrmGenerator instance containing paths and parameter mappings.

    Raises:
        IOError: If files cannot be read or written.
    """
    try:
        with open(config.template_path, "r") as f:
            content: str = f.read()

        # Perform the substitutions for placeholders defined as {key}
        for key, value in config.mapping.items():
            placeholder: str = f"{{{key}}}"
            content = content.replace(placeholder, str(value))

        # Formatting cleanup: Remove spaces before commas and ensure one space after
        content = re.sub(r"[ \t]*,", ",", content)
        content = re.sub(r",[ \t]*", ", ", content)

        with open(config.output_path, "w") as f:
            f.write(content)

    except Exception as e:
        print(f" !! ERROR: Failed to generate {config.output_path}: {e}")
        sys.exit(1)


#######################################################
## .2. Main                                      !!! ##
#######################################################
def main() -> None:
    """
    Main execution logic: parses CLI pairs into a mapping and triggers generation.
    """
    args: argparse.Namespace = parse_arguments()

    # Convert list of 'key=value' into a dictionary with error checking
    param_map: dict[str, str] = {}
    for p in args.params:
        if "=" in p:
            k, v = p.split("=", 1)
            param_map[k.strip()] = v.strip()
        else:
            print(f" !! WARNING: Skipping malformed parameter argument: '{p}'")

    config = PrmGenerator(template_path=args.template, output_path=args.output, mapping=param_map)

    generate_prm(config)


if __name__ == "__main__":
    main()
