#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/scheduler/error.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/error.sh"
# shellcheck source=lib/backup/scheduler/query.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/query.sh"
# shellcheck source=lib/backup/scheduler/queue/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/queue/__all__.sh"
# shellcheck source=lib/backup/scheduler/scheduler.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/scheduler.sh"
# shellcheck source=lib/backup/scheduler/validation.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/validation.sh"
