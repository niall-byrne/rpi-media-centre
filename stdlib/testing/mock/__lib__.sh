#!/bin/bash

# stdlib testing mock object library

set -eo pipefail

# shellcheck source=stdlib/testing/mock/mock.sh
source "${STDLIB_DIRECTORY}/testing/mock/mock.sh"
# shellcheck source=stdlib/testing/mock/persistence.sh
source "${STDLIB_DIRECTORY}/testing/mock/persistence.sh"
# shellcheck source=stdlib/testing/mock/sequence.sh
source "${STDLIB_DIRECTORY}/testing/mock/sequence.sh"
