#!/bin/bash

set -eo pipefail

# shellcheck source=lib/security/account.sh
source "${RPI_WORKING_DIRECTORY}/lib/security/account.sh"
# shellcheck source=lib/security/defaults.sh
source "${RPI_WORKING_DIRECTORY}/lib/security/defaults.sh"
# shellcheck source=lib/security/root.sh
source "${RPI_WORKING_DIRECTORY}/lib/security/root.sh"
# shellcheck source=lib/security/sanitize.sh
source "${RPI_WORKING_DIRECTORY}/lib/security/sanitize.sh"
# shellcheck source=lib/security/validation.sh
source "${RPI_WORKING_DIRECTORY}/lib/security/validation.sh"
# shellcheck source=lib/security/warning.sh
source "${RPI_WORKING_DIRECTORY}/lib/security/warning.sh"
