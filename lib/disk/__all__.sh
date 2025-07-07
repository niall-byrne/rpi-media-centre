#!/bin/bash

set -eo pipefail

# shellcheck source=lib/disk/disk.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/disk.sh"
# shellcheck source=lib/disk/manifest.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/manifest.sh"
# shellcheck source=lib/disk/query.sh
source "${RPI_WORKING_DIRECTORY}/lib/disk/query.sh"
