#!/bin/bash
# @file getter.sh
# @brief A library for getting information about arrays.
# @description
#   This library provides functions to get information about arrays,
#   such as the last element, the length, the longest element, and the shortest element.
#   The results are stored in the global variable `ARRAY_BUFFER` and also printed to stdout.

# stdlib array getter library

set -eo pipefail

ARRAY_BUFFER=""

# @description Gets the last element of an array.
# @arg $1 string The name of the array.
# @set ARRAY_BUFFER string The last element of the array.
# @stdout The last element of the array.
# @exitcode 126 If the argument is null, not an array, or the array is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.array.get.last() {
  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.is_not_empty "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")
  indirect_array_last_element_index="$(("${#indirect_array[@]}" - 1))"

  ARRAY_BUFFER="${indirect_array[indirect_array_last_element_index]}"
  echo "${ARRAY_BUFFER}"
}

# @description Gets the length of an array.
# @arg $1 string The name of the array.
# @set ARRAY_BUFFER integer The length of the array.
# @stdout The length of the array.
# @exitcode 126 If the argument is null or not an array.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.array.get.length() {
  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  ARRAY_BUFFER="${#indirect_array[@]}"
  echo "${ARRAY_BUFFER}"
}

# @description Gets the length of the longest element in an array.
# @arg $1 string The name of the array.
# @set ARRAY_BUFFER integer The length of the longest element.
# @stdout The length of the longest element.
# @exitcode 126 If the argument is null, not an array, or the array is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.array.get.longest() {
  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index
  local current_array_element
  local longest_array_element_length=-1

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.is_not_empty "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for current_array_element in "${indirect_array[@]}"; do
    if [[ "${#current_array_element}" -gt "${longest_array_element_length}" ]]; then
      longest_array_element_length="${#current_array_element}"
    fi
  done

  ARRAY_BUFFER="${longest_array_element_length}"
  echo "${ARRAY_BUFFER}"
}

# @description Gets the length of the shortest element in an array.
# @arg $1 string The name of the array.
# @set ARRAY_BUFFER integer The length of the shortest element.
# @stdout The length of the shortest element.
# @exitcode 126 If the argument is null, not an array, or the array is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.array.get.shortest() {
  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index
  local current_array_element
  local shortest_array_element_length=-1

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.is_not_empty "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for current_array_element in "${indirect_array[@]}"; do
    if [[ "${#current_array_element}" -lt "${shortest_array_element_length}" ]] ||
      [[ "${shortest_array_element_length}" == "-1" ]]; then
      shortest_array_element_length="${#current_array_element}"
    fi
  done

  ARRAY_BUFFER="${shortest_array_element_length}"
  echo "${ARRAY_BUFFER}"
}
