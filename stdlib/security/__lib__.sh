#!/bin/bash

# stdlib security library

set -eo pipefail

# shellcheck source=stdlib/security/assert.sh
source "${STDLIB_DIRECTORY}/security/assert.sh"
# shellcheck source=stdlib/security/getter.sh
source "${STDLIB_DIRECTORY}/security/getter.sh"
# shellcheck source=stdlib/security/path/__lib__.sh
source "${STDLIB_DIRECTORY}/security/path/__lib__.sh"
# shellcheck source=stdlib/security/query.sh
source "${STDLIB_DIRECTORY}/security/query.sh"
