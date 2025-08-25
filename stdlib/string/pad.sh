#!/bin/bash

# stdlib string pad library

builtin set -eo pipefail

stdlib.string.pad.left() {
  # $1: the width to pad with
  # $2: the string to pad

  local _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  builtin printf "%*s%s"$'\n' "${1}" " " "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"

stdlib.fn.derive.var "stdlib.string.pad.left"

stdlib.string.pad.right() {
  # $1: the width to pad with
  # $2: the string to pad

  local _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  builtin printf "%s%*s"$'\n' "${2}" "${1}" " "
}

stdlib.fn.derive.pipeable "stdlib.string.pad.right" "2"

stdlib.fn.derive.var "stdlib.string.pad.right"
