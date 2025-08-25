#!/bin/bash

# stdlib string library

builtin set -eo pipefail

# shellcheck source=stdlib/string/assert/__lib__.sh
source "${STDLIB_DIRECTORY}/string/assert/__lib__.sh"
# shellcheck source=stdlib/string/colour/__lib__.sh
source "${STDLIB_DIRECTORY}/string/colour/__lib__.sh"
# shellcheck source=stdlib/string/justify.sh
source "${STDLIB_DIRECTORY}/string/justify.sh"
# shellcheck source=stdlib/string/lines/__lib__.sh
source "${STDLIB_DIRECTORY}/string/lines/__lib__.sh"
# shellcheck source=stdlib/string/pad.sh
source "${STDLIB_DIRECTORY}/string/pad.sh"
# shellcheck source=stdlib/string/query/__lib__.sh
source "${STDLIB_DIRECTORY}/string/query/__lib__.sh"
# shellcheck source=stdlib/string/trim.sh
source "${STDLIB_DIRECTORY}/string/trim.sh"
# shellcheck source=stdlib/string/wrap.sh
source "${STDLIB_DIRECTORY}/string/wrap.sh"
