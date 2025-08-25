#!/bin/bash

# stdlib security path library

builtin set -eo pipefail

# shellcheck source=stdlib/security/path/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/security/path/assert/__lib__.sh"
# shellcheck source=stdlib/security/path/make.sh
source "${STDLIB_DIRECTORY}/security/path/make.sh"
# shellcheck source=stdlib/security/path/query/__lib__.sh
source "${STDLIB_DIRECTORY}/security/path/query/__lib__.sh"
# shellcheck source=stdlib/security/path/secure.sh
source "${STDLIB_DIRECTORY}/security/path/secure.sh"
