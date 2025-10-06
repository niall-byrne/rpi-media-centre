#!/bin/bash

set -eo pipefail

# shellcheck source=lib/cli/compiler/build/generate/target/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/cli.sh"
# shellcheck source=lib/cli/compiler/build/generate/target/completion.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/completion.sh"
