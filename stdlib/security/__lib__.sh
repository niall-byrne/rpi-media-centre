#!/bin/bash

# stdlib security library

builtin set -eo pipefail

# shellcheck source=stdlib/security/getter.sh
source "${STDLIB_DIRECTORY}/security/getter.sh"
# shellcheck source=stdlib/security/path/__lib__.sh
source "${STDLIB_DIRECTORY}/security/path/__lib__.sh"
# shellcheck source=stdlib/security/user/__lib__.sh
source "${STDLIB_DIRECTORY}/security/user/__lib__.sh"
