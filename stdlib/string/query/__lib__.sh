#!/bin/bash

# stdlib string query library

builtin set -eo pipefail

# shellcheck source=stdlib/string/query/has.sh
source "${STDLIB_DIRECTORY}/string/query/has.sh"
# shellcheck source=stdlib/string/query/is.sh
source "${STDLIB_DIRECTORY}/string/query/is.sh"
# shellcheck source=stdlib/string/query/sugar.sh
source "${STDLIB_DIRECTORY}/string/query/sugar.sh"
