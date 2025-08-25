#!/bin/bash

# stdlib array library

builtin set -eo pipefail

# shellcheck source=stdlib/array/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/array/assert/__lib__.sh"
# shellcheck source=stdlib/array/getter.sh
source "${STDLIB_DIRECTORY}/array/getter.sh"
# shellcheck source=stdlib/array/make.sh
source "${STDLIB_DIRECTORY}/array/make.sh"
# shellcheck source=stdlib/array/map.sh
source "${STDLIB_DIRECTORY}/array/map.sh"
# shellcheck source=stdlib/array/mutate.sh
source "${STDLIB_DIRECTORY}/array/mutate.sh"
# shellcheck source=stdlib/array/query/__lib__.sh
source "${STDLIB_DIRECTORY}/array/query/__lib__.sh"
