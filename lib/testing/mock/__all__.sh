#!/bin/bash

set -eo pipefail

# shellcheck source=lib/testing/mock/mock.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/mock/mock.sh"
# shellcheck source=lib/testing/mock/persistence.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/mock/persistence.sh"
# shellcheck source=lib/testing/mock/sequence.sh
source "${RPI_WORKING_DIRECTORY}/lib/testing/mock/sequence.sh"
