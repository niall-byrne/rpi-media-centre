#!/bin/bash

# stdlib - reusable components for bash scripting

builtin set -eo pipefail

# shellcheck disable=SC2034
STDLIB_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Bootstrap Procedure

bootstrap() {
  # $1: the module to import

  # shellcheck source=/dev/null
  source "${1}"
}

bootstrap "${STDLIB_DIRECTORY}/message.sh"
bootstrap "${STDLIB_DIRECTORY}/binary.sh"
bootstrap "${STDLIB_DIRECTORY}/setting/__lib__.sh"
bootstrap "${STDLIB_DIRECTORY}/builtin.sh"
bootstrap "${STDLIB_DIRECTORY}/string/colour/colour.sh"
bootstrap "${STDLIB_DIRECTORY}/logger/logger.sh"
bootstrap "${STDLIB_DIRECTORY}/string/query/__lib__.sh"
bootstrap "${STDLIB_DIRECTORY}/string/assert/__lib__.sh"
bootstrap "${STDLIB_DIRECTORY}/fn/__lib__.sh"

# source=stdlib/array/__lib__.sh
source "${STDLIB_DIRECTORY}/array/__lib__.sh"
# source=stdlib/fn/__lib__.sh
source "${STDLIB_DIRECTORY}/fn/__lib__.sh"
# source=stdlib/io/__lib__.sh
source "${STDLIB_DIRECTORY}/io/__lib__.sh"
# source=stdlib/logger/__lib__.sh
source "${STDLIB_DIRECTORY}/logger/__lib__.sh"
# source=stdlib/security/__lib__.sh
source "${STDLIB_DIRECTORY}/security/__lib__.sh"
# source=stdlib/string/__lib__.sh
source "${STDLIB_DIRECTORY}/string/__lib__.sh"
# source=stdlib/trap/__lib__.sh
source "${STDLIB_DIRECTORY}/trap/__lib__.sh"
