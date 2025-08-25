#!/bin/bash

# stdlib testing capture library

builtin set -eo pipefail

# shellcheck source=stdlib/testing/capture/output.sh
source "${STDLIB_DIRECTORY}/testing/capture/output.sh"
# shellcheck source=stdlib/testing/capture/rc.sh
source "${STDLIB_DIRECTORY}/testing/capture/rc.sh"
# shellcheck source=stdlib/testing/capture/stderr.sh
source "${STDLIB_DIRECTORY}/testing/capture/stderr.sh"
# shellcheck source=stdlib/testing/capture/stdout.sh
source "${STDLIB_DIRECTORY}/testing/capture/stdout.sh"
