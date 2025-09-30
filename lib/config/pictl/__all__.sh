#!/bin/bash

set -eo pipefail

# shellcheck source=lib/config/pictl/pictl.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/pictl/pictl.sh"
# shellcheck source=lib/config/pictl/validation.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/pictl/validation.sh"
