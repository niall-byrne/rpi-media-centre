#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/job/validation/argument/argument.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/argument/argument.sh"
# shellcheck source=lib/backup/job/validation/argument/remote_target.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/argument/remote_target.sh"
# shellcheck source=lib/backup/job/validation/argument/tarball.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/job/validation/argument/tarball.sh"
