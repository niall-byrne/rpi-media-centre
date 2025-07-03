#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/job/job.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/job.sh"
# shellcheck source=lib/backup/job/task/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/__all__.sh"
# shellcheck source=lib/backup/job/validation.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation.sh"
