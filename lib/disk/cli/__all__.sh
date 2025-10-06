#!/bin/bash

set -eo pipefail

# shellcheck source=lib/disk/cli/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/cli/cli.sh"
# shellcheck source=lib/disk/cli/manifest/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/cli/manifest/__all__.sh"
