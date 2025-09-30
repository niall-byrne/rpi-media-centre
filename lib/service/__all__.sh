#!/bin/bash

set -eo pipefail

# shellcheck source=lib/service/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/service/cli.sh"
# shellcheck source=lib/service/configuration.sh
source "${RPI_WORKING_DIRECTORY}/lib/service/configuration.sh"
# shellcheck source=lib/service/query.sh
source "${RPI_WORKING_DIRECTORY}/lib/service/query.sh"
