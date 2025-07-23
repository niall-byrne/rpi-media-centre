#!/bin/bash

# stdlib array library

set -eo pipefail

# shellcheck source=stdlib/array/assert.sh
source "${STDLIB_DIRECTORY}/array/assert.sh"
# shellcheck source=stdlib/array/getter.sh
source "${STDLIB_DIRECTORY}/array/getter.sh"
# shellcheck source=stdlib/array/iter.sh
source "${STDLIB_DIRECTORY}/array/iter.sh"
# shellcheck source=stdlib/array/make.sh
source "${STDLIB_DIRECTORY}/array/make.sh"
# shellcheck source=stdlib/array/map.sh
source "${STDLIB_DIRECTORY}/array/map.sh"
# shellcheck source=stdlib/array/query.sh
source "${STDLIB_DIRECTORY}/array/query.sh"
