#!/bin/bash

# stdlib string lines library

builtin set -eo pipefail

# shellcheck source=stdlib/string/lines/join.sh
source "${STDLIB_DIRECTORY}/string/lines/join.sh"
# shellcheck source=stdlib/string/lines/map.sh
source "${STDLIB_DIRECTORY}/string/lines/map.sh"

_STDLIB_DELIMITER=""
