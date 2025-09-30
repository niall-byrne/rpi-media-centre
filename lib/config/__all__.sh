#!/bin/bash

set -eo pipefail

# shellcheck source=lib/config/pictl/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/pictl/__all__.sh"
# shellcheck source=lib/config/services/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/services/__all__.sh"
