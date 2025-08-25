#!/bin/bash

# stdlib security user library

builtin set -eo pipefail

# shellcheck source=stdlib/security/user/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/security/user/assert/__lib__.sh"
# shellcheck source=stdlib/security/user/query/__lib__.sh
source "${STDLIB_DIRECTORY}/security/user/query/__lib__.sh"
