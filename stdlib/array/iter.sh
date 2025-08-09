#!/bin/bash

# stdlib array iter library

set -eo pipefail

# @description Appends a string to each element of an array.
# The array is modified in place.
# @arg $1 string The string to append.
# @arg $2 string The name of the array to modify.
# @exitcode 0 On success.
# @exitcode 126 If the second argument is not an array.
# @exitcode 127 If the number of arguments is not 2.
stdlib.array.iter.append() {
  # $1: the string to append
  # $2: the array name

  local array_index
  local indirect_reference
  local indirect_array=()
  local updated_array=()

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((array_index = 0; array_index <= "${#indirect_array}" + 1; array_index++)); do
    updated_array+=("${indirect_array[array_index]}${1}")
  done

  eval "${2}=($(printf '%q ' "${updated_array[@]}"))"
}

# @description Prepends a string to each element of an array.
# The array is modified in place.
# @arg $1 string The string to prepend.
# @arg $2 string The name of the array to modify.
# @exitcode 0 On success.
# @exitcode 126 If the second argument is not an array.
# @exitcode 127 If the number of arguments is not 2.
stdlib.array.iter.prepend() {
  # $1: the string to prepend
  # $2: the array name

  local array_index
  local indirect_reference
  local indirect_array=()
  local updated_array=()

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((array_index = 0; array_index <= "${#indirect_array}" + 1; array_index++)); do
    updated_array+=("${1}${indirect_array[array_index]}")
  done

  eval "${2}=($(printf '%q ' "${updated_array[@]}"))"
}
