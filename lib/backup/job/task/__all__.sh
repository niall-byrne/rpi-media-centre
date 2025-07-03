#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/job/task/recover.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/recover.sh"
# shellcheck source=lib/backup/job/task/rsync.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/rsync.sh"
# shellcheck source=lib/backup/job/task/tarball.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/tarball.sh"
# shellcheck source=lib/backup/job/task/task.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/task.sh"
# shellcheck source=lib/backup/job/task/upload.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/task/upload.sh"
