#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/manifest/command/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/manifest/command/__all__.sh"
# shellcheck source=lib/backup/manifest/help.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/manifest/help.sh"
# shellcheck source=lib/backup/manifest/line.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/manifest/line.sh"
# shellcheck source=lib/backup/manifest/load.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/manifest/load.sh"
