#!/bin/bash
# @file pad.sh
# @brief A library for padding strings.
# @description
#   This library provides functions to pad strings to the left or right with spaces.

# stdlib string pad library

set -eo pipefail

# @description Pads a string to the left with spaces.
# @arg $1 integer The width to pad with.
# @arg $2 string The string to pad.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The padded string.
stdlib.string.pad.left() {
  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  printf "%*s%s"$'\n' "${1}" " " "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"

stdlib.fn.derive.var "stdlib.string.pad.left"

# @description Pads a string to the right with spaces.
# @arg $1 integer The width to pad with.
# @arg $2 string The string to pad.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The padded string.
stdlib.string.pad.right() {
  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  printf "%s%*s"$'\n' "${2}" "${1}" " "
}

stdlib.fn.derive.pipeable "stdlib.string.pad.right" "2"

stdlib.fn.derive.var "stdlib.string.pad.right"
