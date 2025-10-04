#!/bin/bash

set -eo pipefail

# shellcheck source=lib/disk/manifest/command/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/command/__all__.sh"
# shellcheck source=lib/disk/manifest/help.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/help.sh"
# shellcheck source=lib/disk/manifest/line.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/line.sh"
# shellcheck source=lib/disk/manifest/load.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/load.sh"
