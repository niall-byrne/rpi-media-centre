#!/bin/bash

# stdlib fn assert library

builtin set -eo pipefail

# shellcheck source=stdlib/fn/assert/is.sh
source "${STDLIB_DIRECTORY}/fn/assert/is.sh"
# shellcheck source=stdlib/fn/assert/not.sh
source "${STDLIB_DIRECTORY}/fn/assert/not.sh"
