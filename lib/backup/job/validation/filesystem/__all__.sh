#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/job/validation/filesystem/filesystem.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/filesystem/filesystem.sh"
# shellcheck source=lib/backup/job/validation/filesystem/keyfile.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/filesystem/keyfile.sh"
# shellcheck source=lib/backup/job/validation/filesystem/rsync.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/filesystem/rsync.sh"
# shellcheck source=lib/backup/job/validation/filesystem/source.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/filesystem/source.sh"
# shellcheck source=lib/backup/job/validation/filesystem/tarball.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/filesystem/tarball.sh"
