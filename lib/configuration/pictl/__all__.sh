#!/bin/bash

set -eo pipefail

# shellcheck source=lib/configuration/pictl/pictl.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration/pictl/pictl.sh"
# shellcheck source=lib/configuration/pictl/validation.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration/pictl/validation.sh"
