#!/bin/bash

# stdlib testing mock internal library

builtin set -eo pipefail

# shellcheck source=stdlib/testing/mock/internal/arg_array.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/arg_array.sh"
# shellcheck source=stdlib/testing/mock/internal/persistence.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/persistence.sh"
# shellcheck source=stdlib/testing/mock/internal/sanitize.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/sanitize.sh"
