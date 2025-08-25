#!/bin/bash

# stdlib testing library

builtin set -eo pipefail

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
# shellcheck source=stdlib/testing/protect.sh
source "${STDLIB_DIRECTORY}/testing/protect.sh"
# shellcheck source=stdlib/testing/message.sh
source "${STDLIB_DIRECTORY}/testing/message.sh"
# shellcheck source=stdlib/testing/theme.sh
source "${STDLIB_DIRECTORY}/testing/theme.sh"

# create a protected duplicate of the stdlib library for testing functions to use
__testing.protect_stdlib

# compile the stdlib testing mock
_testing._mock.compile
