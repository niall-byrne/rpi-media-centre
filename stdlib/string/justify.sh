#!/bin/bash

# stdlib string justify library

set -eo pipefail

stdlib.string.justify.left() {
  # $1: the column width to justify to
  # $2: the string to justify

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  printf "%-${1}b"$'\n' "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.justify.left" "2"

stdlib.fn.derive.var "stdlib.string.justify.left"

stdlib.string.justify.right() {
  # $1: the column width to justify to
  # $2: the string to justify

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  printf "%${1}s"$'\n' "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.justify.right" "2"

stdlib.fn.derive.var "stdlib.string.justify.right"
