#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/job/validation/dependency/dependency.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/dependency/dependency.sh"
# shellcheck source=lib/backup/job/validation/dependency/remote_target.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/dependency/remote_target.sh"
# shellcheck source=lib/backup/job/validation/dependency/rsync.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/dependency/rsync.sh"
# shellcheck source=lib/backup/job/validation/dependency/tarball.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/dependency/tarball.sh"
