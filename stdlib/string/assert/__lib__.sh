#!/bin/bash

# stdlib string assert library

builtin set -eo pipefail

# shellcheck source=stdlib/string/assert/is.sh
source "${STDLIB_DIRECTORY}/string/assert/is.sh"
# shellcheck source=stdlib/string/assert/not.sh
source "${STDLIB_DIRECTORY}/string/assert/not.sh"
