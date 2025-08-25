#!/bin/bash

# stdlib testing assertion library

builtin set -eo pipefail

# shellcheck source=stdlib/testing/assertion/array.sh
source "${STDLIB_DIRECTORY}/testing/assertion/array.sh"
# shellcheck source=stdlib/testing/assertion/fn.sh
source "${STDLIB_DIRECTORY}/testing/assertion/fn.sh"
# shellcheck source=stdlib/testing/assertion/message.sh
source "${STDLIB_DIRECTORY}/testing/assertion/message.sh"
# shellcheck source=stdlib/testing/assertion/null.sh
source "${STDLIB_DIRECTORY}/testing/assertion/null.sh"
# shellcheck source=stdlib/testing/assertion/output.sh
source "${STDLIB_DIRECTORY}/testing/assertion/output.sh"
# shellcheck source=stdlib/testing/assertion/rc.sh
source "${STDLIB_DIRECTORY}/testing/assertion/rc.sh"
# shellcheck source=stdlib/testing/assertion/snapshot.sh
source "${STDLIB_DIRECTORY}/testing/assertion/snapshot.sh"

_testing.__assertion.value.check() {
  # $1: the variable to check

  local value_name="${1}"
  local assertion_name="${FUNCNAME[1]}"

  if [[ -z "${value_name}" ]]; then
    fail " '${assertion_name}' $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
  fi
}
