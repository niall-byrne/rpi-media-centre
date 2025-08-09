#!/bin/bash

# stdlib string join library

set -eo pipefail

stdlib.string.join() {
  # $1: the string to process
  #
  # _DELIMITER:  a char sequence to replace which joins the string

  local delimiter="${_DELIMITER:-$'\n'}"

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"

  printf '%s\n' "${1//${delimiter}/}"
}

stdlib.fn.derive.pipeable "stdlib.string.join" "1"

stdlib.fn.derive.var "stdlib.string.join"
