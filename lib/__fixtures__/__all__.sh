#!/bin/bash

set -eo pipefail

# shellcheck source=lib/__fixtures__/capture.sh
source "${RPI_WORKING_DIRECTORY}/lib/__fixtures__/capture.sh"
# shellcheck source=lib/__fixtures__/cli_pretty.sh
source "${RPI_WORKING_DIRECTORY}/lib/__fixtures__/cli_pretty.sh"
# shellcheck source=lib/__fixtures__/variable.sh
source "${RPI_WORKING_DIRECTORY}/lib/__fixtures__/variable.sh"
