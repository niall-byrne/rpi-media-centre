#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/job/validation/argument/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/argument/__all__.sh"
# shellcheck source=lib/backup/job/validation/dependency/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/dependency/__all__.sh"
# shellcheck source=lib/backup/job/validation/error.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/error.sh"
# shellcheck source=lib/backup/job/validation/filesystem/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/filesystem/__all__.sh"
# shellcheck source=lib/backup/job/validation/validation.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/validation.sh"
