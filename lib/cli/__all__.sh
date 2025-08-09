#!/bin/bash

set -eo pipefail

# shellcheck source=lib/cli/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/cli.sh"
# shellcheck source=lib/cli/compiler/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/__all__.sh"
# shellcheck source=lib/cli/logger.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/logger.sh"
# shellcheck source=lib/cli/pretty/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/__all__.sh"
