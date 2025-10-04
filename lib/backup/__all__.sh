#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/cli/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/cli/__all__.sh"
# shellcheck source=lib/backup/job/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/__all__.sh"
# shellcheck source=lib/backup/manifest/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/manifest/__all__.sh"
# shellcheck source=lib/backup/scheduler/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/__all__.sh"
