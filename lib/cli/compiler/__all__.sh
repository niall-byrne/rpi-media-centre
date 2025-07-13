#!/bin/bash

set -eo pipefail

# shellcheck source=lib/cli/compiler/buffer.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/buffer.sh"
# shellcheck source=lib/cli/compiler/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/cli.sh"
# shellcheck source=lib/cli/compiler/completion.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/completion.sh"
# shellcheck source=lib/cli/compiler/configuration.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/configuration.sh"
# shellcheck source=lib/cli/compiler/query.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/query.sh"
