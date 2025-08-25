#!/bin/bash

# stdlib testing mock object library

builtin set -eo pipefail

# shellcheck source=stdlib/testing/mock/arg_string.sh
source "${STDLIB_DIRECTORY}/testing/mock/arg_string.sh"
# shellcheck source=stdlib/testing/mock/attributes.sh
source "${STDLIB_DIRECTORY}/testing/mock/attributes.sh"
# shellcheck source=stdlib/testing/mock/internal/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/__lib__.sh"
# shellcheck source=stdlib/testing/mock/message.sh
source "${STDLIB_DIRECTORY}/testing/mock/message.sh"
# shellcheck source=stdlib/testing/mock/mock.sh
source "${STDLIB_DIRECTORY}/testing/mock/mock.sh"
# shellcheck source=stdlib/testing/mock/sequence.sh
source "${STDLIB_DIRECTORY}/testing/mock/sequence.sh"
