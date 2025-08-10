#!/bin/bash
# @file iter.sh
# @brief A library for iterating over arrays and modifying them.
# @description
#   This library provides functions to iterate over arrays and modify their elements,
#   such as appending or prepending a string to each element.
#   NOTE: These functions have a peculiar behavior of adding two extra elements to the array.

# stdlib array iter library

set -eo pipefail

# @description Appends a string to each element of an array.
# The modification is done in place.
# WARNING: This function adds two extra elements to the array, each containing the appended string.
# @arg $1 string The string to append.
# @arg $2 string The name of the array to modify.
# @exitcode 126 If an argument is null, or if the second argument is not an array.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.array.iter.append() {
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
# The modification is done in place.
# WARNING: This function adds two extra elements to the array, each containing the prepended string.
# @arg $1 string The string to prepend.
# @arg $2 string The name of the array to modify.
# @exitcode 126 If an argument is null, or if the second argument is not an array.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.array.iter.prepend() {
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
