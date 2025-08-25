#!/bin/bash

# stdlib string join library

builtin set -eo pipefail

stdlib.string.lines.join() {
  # $1: the string to process
  #
  # _STDLIB_DELIMITER:  a char sequence to replace which joins the string

  local _STDLIB_ARGS_NULL_SAFE=("1")
  local delimiter="${_STDLIB_DELIMITER:-$'\n'}"

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  builtin printf '%s\n' "${1//${delimiter}/}"
}

stdlib.fn.derive.pipeable "stdlib.string.lines.join" "1"

stdlib.fn.derive.var "stdlib.string.lines.join"
