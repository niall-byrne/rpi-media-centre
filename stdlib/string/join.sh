#!/bin/bash
# @file join.sh
# @brief A library for joining strings.
# @description
#   This library provides a function to join a string by removing a delimiter.

# stdlib string join library

set -eo pipefail

# @description Joins a string by removing a delimiter.
# The delimiter is specified by the `_DELIMITER` environment variable, and defaults to a newline character.
# @arg $1 string The string to process.
# @env _DELIMITER The delimiter to remove. Defaults to newline.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The joined string.
stdlib.string.join() {
  local delimiter="${_DELIMITER:-$'\n'}"

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  printf '%s\n' "${1//${delimiter}/}"
}

stdlib.fn.derive.pipeable "stdlib.string.join" "1"

stdlib.fn.derive.var "stdlib.string.join"
