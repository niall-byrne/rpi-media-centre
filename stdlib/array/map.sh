#!/bin/bash

# stdlib array map library

builtin set -eo pipefail

stdlib.array.map.format() {
  # $1: a valid print format string to apply to each element
  # $2: the array to process

  local element
  local indirect_reference
  local indirect_array=()

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for element in "${indirect_array[@]}"; do
    # shellcheck disable=SC2059
    builtin printf "${1}" "${element}"
  done
}

stdlib.array.map.fn() {
  # $1: a valid function to apply to each element
  # $2: the array to process

  local element
  local indirect_reference
  local indirect_array=()

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for element in "${indirect_array[@]}"; do
    "${1}" "${element}"
  done
}
