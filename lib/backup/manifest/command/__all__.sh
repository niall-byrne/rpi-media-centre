#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/manifest/command/all.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/manifest/command/all.sh"
# shellcheck source=lib/backup/manifest/command/write.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/manifest/command/write.sh"
