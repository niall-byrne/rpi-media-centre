#!/bin/bash

set -eo pipefail

# shellcheck source=lib/cli/compiler/build/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/__all__.sh"
# shellcheck source=lib/cli/compiler/query.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/query.sh"
