#!/bin/bash

set -eo pipefail

# shellcheck source=lib/cli/compiler/build/build.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/build.sh"
# shellcheck source=lib/cli/compiler/build/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/cli.sh"
# shellcheck source=lib/cli/compiler/build/completion.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/completion.sh"
# shellcheck source=lib/cli/compiler/build/generate/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/__all__.sh"
