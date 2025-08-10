#!/bin/bash
# @file justify.sh
# @brief A library for justifying strings.
# @description
#   This library provides functions to justify strings to the left or right within a given width.

# stdlib string justify library

set -eo pipefail

# @description Justifies a string to the left.
# @arg $1 integer The column width to justify to.
# @arg $2 string The string to justify.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The justified string.
stdlib.string.justify.left() {
  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  printf "%-${1}b"$'\n' "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.justify.left" "2"

stdlib.fn.derive.var "stdlib.string.justify.left"

# @description Justifies a string to the right.
# @arg $1 integer The column width to justify to.
# @arg $2 string The string to justify.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The justified string.
stdlib.string.justify.right() {
  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  printf "%${1}s"$'\n' "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.justify.right" "2"

stdlib.fn.derive.var "stdlib.string.justify.right"
