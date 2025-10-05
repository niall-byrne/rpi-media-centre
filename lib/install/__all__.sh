#!/bin/bash

set -eo pipefail

# shellcheck source=lib/install/account.sh
source "${RPI_WORKING_DIRECTORY}/lib/install/account.sh"
# shellcheck source=lib/install/cli/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/install/cli/__all__.sh"
# shellcheck source=lib/install/pictl.sh
source "${RPI_WORKING_DIRECTORY}/lib/install/pictl.sh"
