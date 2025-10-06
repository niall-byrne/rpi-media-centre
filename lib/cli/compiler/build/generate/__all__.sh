#!/bin/bash

set -eo pipefail

# shellcheck source=lib/cli/compiler/build/generate/buffer.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/buffer.sh"
# shellcheck source=lib/cli/compiler/build/generate/configuration.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/configuration.sh"
# shellcheck source=lib/cli/compiler/build/generate/target/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/__all__.sh"
