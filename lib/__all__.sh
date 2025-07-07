#!/bin/bash

set -eo pipefail

# shellcheck source=lib/defaults.sh
source "${RPI_WORKING_DIRECTORY}/lib/defaults.sh"
# shellcheck source=lib/backup/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/__all__.sh"
# shellcheck source=lib/configuration.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration.sh"
# shellcheck source=lib/control.sh
source "${RPI_WORKING_DIRECTORY}/lib/control.sh"
# shellcheck source=lib/debug.sh
source "${RPI_WORKING_DIRECTORY}/lib/debug.sh"
# shellcheck source=lib/disk/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/__all__.sh"
# shellcheck source=lib/docker.sh
source "${RPI_WORKING_DIRECTORY}/lib/docker.sh"
# shellcheck source=lib/event.sh
source "${RPI_WORKING_DIRECTORY}/lib/event.sh"
# shellcheck source=lib/filesystem.sh
source "${RPI_WORKING_DIRECTORY}/lib/filesystem.sh"
# shellcheck source=lib/installer.sh
source "${RPI_WORKING_DIRECTORY}/lib/installer.sh"
# shellcheck source=lib/io.sh
source "${RPI_WORKING_DIRECTORY}/lib/io.sh"
# shellcheck source=lib/manifest.sh
source "${RPI_WORKING_DIRECTORY}/lib/manifest.sh"
# shellcheck source=lib/trap.sh
source "${RPI_WORKING_DIRECTORY}/lib/trap.sh"
