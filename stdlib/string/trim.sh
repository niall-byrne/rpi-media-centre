#!/bin/bash

# stdlib string trim library

builtin set -eo pipefail

stdlib.string.trim.left() {
  # $1: the string to process

  local _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  builtin shopt -s extglob
  builtin printf '%s\n' "${1##+([[:space:]])}"
  builtin shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.left" "1"

stdlib.fn.derive.var "stdlib.string.trim.left"

stdlib.string.trim.right() {
  # $1: the string to process

  local _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  builtin shopt -s extglob
  builtin printf '%s\n' "${1%%+([[:space:]])}"
  builtin shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.right" "1"

stdlib.fn.derive.var "stdlib.string.trim.right"
