#!/bin/bash

set -eo pipefail

# shellcheck source=lib/testing/assertion.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/assertion.sh"
# shellcheck source=lib/testing/capture.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/capture.sh"
# shellcheck source=lib/testing/error.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/error.sh"
# shellcheck source=lib/testing/fixtures/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/fixtures/__all__.sh"
# shellcheck source=lib/testing/mock/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/mock/__all__.sh"
# shellcheck source=lib/testing/module.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/module.sh"
# shellcheck source=lib/testing/parametrize.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/parametrize.sh"
