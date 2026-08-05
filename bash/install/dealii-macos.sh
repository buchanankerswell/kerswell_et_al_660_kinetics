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

echo "    PROJCT_ROOT: $PROJECT_ROOT"
echo "    NPROC:       $NPROC"
echo "    DEALII_DIR:  $DEALII_DIR"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Skip if already built
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -d "$DEALII_DIR/deal.II-$DEALII_VERSION" ]; then
    echo "    ==========================================="
    echo "    deal.II-$DEALII_VERSION found at: $DEALII_DIR/deal.II-$DEALII_VERSION"
    exit 0
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Clone candi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "    ==========================================="
if [ -d "candi" ]; then
    echo "    Found candi directory! Pulling latest changes ..."
    cd candi && git checkout update-macos-platform && git pull
else
    git clone https://github.com/buchanankerswell/candi.git && cd candi && git checkout update-macos-platform && git pull
fi
if [ -f "local.cfg" ]; then
    echo "    local.cfg found! Removing old config and reconfiguring ..."
    rm local.cfg
fi
echo "    Downloading and configuring new local.cfg ..."
curl -O https://raw.githubusercontent.com/geodynamics/aspect/main/contrib/install/local.cfg
cat << EOF >> local.cfg
DEAL_II_VERSION=$DEALII_VERSION
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
