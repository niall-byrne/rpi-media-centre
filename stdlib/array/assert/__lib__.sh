#!/bin/bash

# stdlib array assert library

builtin set -eo pipefail

# shellcheck source=stdlib/array/assert/is.sh
source "${STDLIB_DIRECTORY}/array/assert/is.sh"
# shellcheck source=stdlib/array/assert/not.sh
source "${STDLIB_DIRECTORY}/array/assert/not.sh"
