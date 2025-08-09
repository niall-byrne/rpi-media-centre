#!/bin/bash

# stdlib string library

set -eo pipefail

# shellcheck source=stdlib/string/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/string/assert/__lib__.sh"
# shellcheck source=stdlib/string/colour/__lib__.sh
source "${STDLIB_DIRECTORY}/string/colour/__lib__.sh"
# shellcheck source=stdlib/string/join.sh
source "${STDLIB_DIRECTORY}/string/join.sh"
# shellcheck source=stdlib/string/justify.sh
source "${STDLIB_DIRECTORY}/string/justify.sh"
# shellcheck source=stdlib/string/map.sh
source "${STDLIB_DIRECTORY}/string/map.sh"
# shellcheck source=stdlib/string/pad.sh
source "${STDLIB_DIRECTORY}/string/pad.sh"
# shellcheck source=stdlib/string/query/__lib__.sh
source "${STDLIB_DIRECTORY}/string/query/__lib__.sh"
# shellcheck source=stdlib/string/trim.sh
source "${STDLIB_DIRECTORY}/string/trim.sh"
# shellcheck source=stdlib/string/wrap.sh
source "${STDLIB_DIRECTORY}/string/wrap.sh"
