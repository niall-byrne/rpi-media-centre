#!/bin/bash

# stdlib io path assert library

builtin set -eo pipefail

# shellcheck source=stdlib/io/path/assert/is.sh
source "${STDLIB_DIRECTORY}/io/path/assert/is.sh"
# shellcheck source=stdlib/io/path/assert/not.sh
source "${STDLIB_DIRECTORY}/io/path/assert/not.sh"
