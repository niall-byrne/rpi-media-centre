#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/cli/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/cli/cli.sh"
# shellcheck source=lib/backup/cli/manifest/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/cli/manifest/__all__.sh"
