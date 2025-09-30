#!/bin/bash

set -eo pipefail

# shellcheck source=lib/service/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/service/cli.sh"
# shellcheck source=lib/service/config.sh
source "${RPI_WORKING_DIRECTORY}/lib/service/config.sh"
# shellcheck source=lib/service/query.sh
source "${RPI_WORKING_DIRECTORY}/lib/service/query.sh"
