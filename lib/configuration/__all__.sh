#!/bin/bash

set -eo pipefail

# shellcheck source=lib/configuration/pictl/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration/pictl/__all__.sh"
# shellcheck source=lib/configuration/services/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration/services/__all__.sh"
