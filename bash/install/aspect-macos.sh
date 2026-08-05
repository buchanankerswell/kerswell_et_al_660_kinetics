#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get args
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ $# -ne 1 ]; then
  echo "    Usage: $0 <DEALII_VERSION>"
  exit 1
fi

DEALII_VERSION=$1

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Environment setup
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ============================================="
echo "    Setting environment variables ..."

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NPROC=${NPROC:-$(sysctl -n hw.ncpu)}
DEALII_DIR=$PROJECT_ROOT/dealii
ASPECT_BUILD_DIR=$PROJECT_ROOT/aspect/build
ASPECT_DIR=$PROJECT_ROOT/aspect

echo "    NPROC:            $NPROC"
echo "    DEALII_VERSION:   $DEALII_VERSION"
echo "    DEALII_DIR:       $DEALII_DIR"
echo "    ASPECT_BUILD_DIR: $ASPECT_BUILD_DIR"
echo "    ASPECT_DIR:       $ASPECT_DIR"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Skip if already built
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -x "$ASPECT_BUILD_DIR/aspect-release" ]; then
    echo "    =========================================="
    echo "    ASPECT already built at: $ASPECT_BUILD_DIR/aspect-release"
    exit 0
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ensure deal.II is available
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -d "$DEALII_DIR/deal.II-$DEALII_VERSION" ]; then
    echo "    ==========================================="
    echo "    deal.II-$DEALII_VERSION found at: $DEALII_DIR/deal.II-$DEALII_VERSION"
else
    echo "    deal.II-$DEALII_VERSION not found!"
    echo "    Install deal.II before ASPECT"
    exit 1
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Clone ASPECT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ ! -d "$ASPECT_DIR" ]; then
    echo "    ==========================================="
    echo "    Cloning ASPECT repository ..."
    git clone https://github.com/geodynamics/aspect.git "$ASPECT_DIR"
else
    echo "    ==========================================="
    echo "    ASPECT source files found at: $ASPECT_DIR"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Enable deal.II
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ==========================================="
echo "    Enabling ASPECT dependencies ..."
chmod +x "$DEALII_DIR/configuration/enable.sh"
# shellcheck source=/dev/null
source "$DEALII_DIR/configuration/enable.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Build ASPECT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ==========================================="
echo "    Creating build directory and running CMake ..."
mkdir -p "$ASPECT_BUILD_DIR" && cd "$ASPECT_BUILD_DIR"
cmake "$ASPECT_DIR"
make -j "$NPROC"

echo "    ==========================================="
echo "    ASPECT build complete!"
echo "    Executable installed at: $ASPECT_BUILD_DIR/aspect-release"
