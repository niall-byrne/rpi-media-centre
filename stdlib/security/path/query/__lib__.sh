#!/bin/bash

# stdlib security path query library

builtin set -eo pipefail

# shellcheck source=stdlib/security/path/query/is.sh
source "${STDLIB_DIRECTORY}/security/path/query/is.sh"
# shellcheck source=stdlib/security/path/query/has.sh
source "${STDLIB_DIRECTORY}/security/path/query/has.sh"
