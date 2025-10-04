#!/bin/bash

set -eo pipefail

# shellcheck source=lib/disk/manifest/command/all.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/command/all.sh"
# shellcheck source=lib/disk/manifest/command/mount.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/command/mount.sh"
# shellcheck source=lib/disk/manifest/command/unmount.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest/command/unmount.sh"
