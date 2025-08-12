#!/bin/bash

# stdlib string trim library

set -eo pipefail

stdlib.string.trim.left() {
  # $1: the string to process

  local _ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  shopt -s extglob
  printf '%s\n' "${1##+([[:space:]])}"
  shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.left" "1"

stdlib.fn.derive.var "stdlib.string.trim.left"

stdlib.string.trim.right() {
  # $1: the string to process

  local _ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  shopt -s extglob
  printf '%s\n' "${1%%+([[:space:]])}"
  shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.right" "1"

stdlib.fn.derive.var "stdlib.string.trim.right"
