#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/job/task/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/__all__.sh"
# shellcheck source=lib/backup/job/job.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/job.sh"
# shellcheck source=lib/backup/job/log.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/log.sh"
# shellcheck source=lib/backup/job/message.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/message.sh"
# shellcheck source=lib/backup/job/parse.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/parse.sh"
# shellcheck source=lib/backup/job/validation/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/__all__.sh"
