#!/bin/bash

set -Eeo pipefail

# shellcheck source=lib/io.sh
source "${RPI_WORKING_DIRECTORY}/lib/io.sh"

# shellcheck source=lib/defaults.sh
source "${RPI_WORKING_DIRECTORY}/lib/defaults.sh"
# shellcheck source=lib/settings.sh
source "${RPI_WORKING_DIRECTORY}/lib/settings.sh"

# shellcheck source=lib/backup/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/__all__.sh"
# shellcheck source=lib/bootstrap.sh
source "${RPI_WORKING_DIRECTORY}/lib/bootstrap.sh"
# shellcheck source=lib/cli/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/__all__.sh"
# shellcheck source=lib/config/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/__all__.sh"
# shellcheck source=lib/control.sh
source "${RPI_WORKING_DIRECTORY}/lib/control.sh"
# shellcheck source=lib/debug.sh
source "${RPI_WORKING_DIRECTORY}/lib/debug.sh"
# shellcheck source=lib/dependencies/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/dependencies/__all__.sh"
# shellcheck source=lib/disk/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/__all__.sh"
# shellcheck source=lib/docker.sh
source "${RPI_WORKING_DIRECTORY}/lib/docker.sh"
# shellcheck source=lib/event.sh
source "${RPI_WORKING_DIRECTORY}/lib/event.sh"
# shellcheck source=lib/filesystem.sh
source "${RPI_WORKING_DIRECTORY}/lib/filesystem.sh"
# shellcheck source=lib/installer/cli.sh
source "${RPI_WORKING_DIRECTORY}/lib/installer/cli.sh"
# shellcheck source=lib/security/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/security/__all__.sh"
# shellcheck source=lib/service/__all__.sh
source "${RPI_WORKING_DIRECTORY}/lib/service/__all__.sh"
# shellcheck source=lib/trap.sh
source "${RPI_WORKING_DIRECTORY}/lib/trap.sh"
