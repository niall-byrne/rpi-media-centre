#!/bin/bash

set -eo pipefail

# shellcheck source=lib/disk/cli/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/cli/__all__.sh"
# shellcheck source=lib/disk/disk.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/disk.sh"
# shellcheck source=lib/disk/manifest/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/__all__.sh"
# shellcheck source=lib/disk/pretty.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/pretty.sh"
# shellcheck source=lib/disk/query.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/query.sh"
