#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get args
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ $# -ne 6 ]; then
  echo "    Usage: $0 <DEALII_VERSION> <TRILINOS_VERSION> <GCC> <OPENMPI> <OPENBLAS> <CMAKE>"
  exit 1
fi

DEALII_VERSION=$1
TRILINOS_VERSION=$2
GCC=$3
OPENMPI=$4
OPENBLAS=$5
CMAKE=$6

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Environment setup
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ============================================="
echo "    Setting environment variables ..."

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NPROC=$SLURM_NTASKS
DEALII_DIR=$PROJECT_ROOT/dealii

echo "    PROJCT_ROOT:    $PROJECT_ROOT"
echo "    NPROC:          $NPROC"
echo "    DEALII_VERSION: $DEALII_VERSION"
echo "    DEALII_DIR:     $DEALII_DIR"
echo "    GCC:            $GCC"
echo "    OPENMPI:        $OPENMPI"
echo "    OPENBLAS:       $OPENBLAS"
echo "    CMAKE:          $CMAKE"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Skip if already built
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -d "$DEALII_DIR/deal.II-$DEALII_VERSION" ]; then
    echo "    ==========================================="
    echo "    deal.II-$DEALII_VERSION found at: $DEALII_DIR/deal.II-$DEALII_VERSION"
    exit 0
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load modules
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ==========================================="
echo "    Loading openmpi and openblas modules ..."

module purge
module load "$GCC" "$OPENMPI" "$OPENBLAS" "$CMAKE"

export CC=mpicc
export CXX=mpicxx
export FC=mpif90
export FF=mpif77

# Ensure GCC runtime libs are first in search path
export LD_LIBRARY_PATH=$GCCDIR/lib64:$LD_LIBRARY_PATH

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Clone candi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ==========================================="
if [ -d "candi" ]; then
    echo "    Found candi directory! Pulling latest changes ..."
    cd candi && git pull
else
    git clone https://github.com/dealii/candi.git && cd candi
fi
if [ -f "local.cfg" ]; then
    echo "    local.cfg found! Removing old config and reconfiguring ..."
    rm local.cfg
fi
echo "    Downloading and configuring new local.cfg ..."
curl -O https://raw.githubusercontent.com/geodynamics/aspect/main/contrib/install/local.cfg
cat << EOF >> local.cfg
GIVEN_PLATFORM=deal.II-toolchain/platforms/supported/linux_cluster.platform
DEAL_II_VERSION=$DEALII_VERSION
TRILINOS_MAJOR_VERSION=$TRILINOS_VERSION
BLAS_DIR=$OPENBLAS_DIR
TRILINOS_CONFOPTS="-D TPL_BLAS_LIBRARIES=$OPENBLAS_LIBDIR/libopenblas.so -D TPL_LAPACK_LIBRARIES=$OPENBLAS_LIBDIR/libopenblas.so"
EOF

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Install dependencies
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ==========================================="
echo "    Installing deal.II and its dependencies ..."
./candi.sh --prefix="$DEALII_DIR" -j "$NPROC" -y

echo "    ==========================================="
echo "    deal.II $DEALII_VERSION build successful!"
echo "    Installed to: $DEALII_DIR/deal.II-$DEALII_VERSION"
