#!/bin/bash

set -eo pipefail

# shellcheck source=lib/config/services/pihole.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/services/pihole.sh"
# shellcheck source=lib/config/services/samba.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/services/samba.sh"
# shellcheck source=lib/config/services/syncthing.sh
source "${RPI_WORKING_DIRECTORY}/lib/config/services/syncthing.sh"
