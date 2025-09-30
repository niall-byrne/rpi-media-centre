#!/bin/bash

set -eo pipefail

# shellcheck source=lib/configuration/services/pihole.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration/services/pihole.sh"
# shellcheck source=lib/configuration/services/samba.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration/services/samba.sh"
# shellcheck source=lib/configuration/services/syncthing.sh
source "${RPI_WORKING_DIRECTORY}/lib/configuration/services/syncthing.sh"
