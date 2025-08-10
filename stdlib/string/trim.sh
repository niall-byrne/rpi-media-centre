#!/bin/bash
# @file trim.sh
# @brief A library for trimming strings.
# @description
#   This library provides functions to trim whitespace from the left or right of a string.

# stdlib string trim library

set -eo pipefail

# @description Trims whitespace from the left of a string.
# @arg $1 string The string to process.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The trimmed string.
stdlib.string.trim.left() {
  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  shopt -s extglob
  printf '%s\n' "${1##+([[:space:]])}"
  shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.left" "1"

stdlib.fn.derive.var "stdlib.string.trim.left"

# @description Trims whitespace from the right of a string.
# @arg $1 string The string to process.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The trimmed string.
stdlib.string.trim.right() {
  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  shopt -s extglob
  printf '%s\n' "${1%%+([[:space:]])}"
  shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.right" "1"

stdlib.fn.derive.var "stdlib.string.trim.right"
