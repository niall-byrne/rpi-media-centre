#!/bin/bash

# stdlib security path assert library

builtin set -eo pipefail

# shellcheck source=stdlib/security/path/assert/is.sh
source "${STDLIB_DIRECTORY}/security/path/assert/is.sh"
# shellcheck source=stdlib/security/path/assert/has.sh
source "${STDLIB_DIRECTORY}/security/path/assert/has.sh"
