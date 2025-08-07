#!/bin/bash

# stdlib testing library

set -eo pipefail

# shellcheck source=stdlib/testing/assertion/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/assertion/__lib__.sh"
# shellcheck source=stdlib/testing/capture/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/capture/__lib__.sh"
# shellcheck source=stdlib/testing/error.sh
source "${STDLIB_DIRECTORY}/testing/error.sh"
# shellcheck source=stdlib/testing/fixtures/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/fixtures/__lib__.sh"
# shellcheck source=stdlib/testing/load.sh
source "${STDLIB_DIRECTORY}/testing/load.sh"
# shellcheck source=stdlib/testing/mock/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/mock/__lib__.sh"
# shellcheck source=stdlib/testing/parametrize/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/parametrize/__lib__.sh"

# compile the stdlib testing mock
_testing._mock.compile
