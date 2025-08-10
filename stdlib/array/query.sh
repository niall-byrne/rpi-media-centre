#!/bin/bash
# @file query.sh
# @brief A library for querying information about arrays.
# @description
#   This library provides functions to query information about arrays,
#   such as checking for equality, if a variable is an array, or if an array is empty.
#   These functions return a status code and do not produce any output on stdout or stderr.

# stdlib array query library

set -eo pipefail

# @description Checks if two arrays are equal.
# @arg $1 string The name of the first array to compare.
# @arg $2 string The name of the second array to compare.
# @exitcode 0 If the arrays are equal.
# @exitcode 1 If the arrays are not equal.
# @exitcode 126 If one of the arguments is not an array.
# @exitcode 127 If the number of arguments is not 2.
stdlib.array.query.equals() {
  local indirect_reference_1
  local indirect_array_1=()
  local indirect_reference_2
  local indirect_array_2=()

  [[ "${#@}" == "2" ]] || return 127
  stdlib.array.query.is_array "${1}" || return 126
  stdlib.array.query.is_array "${2}" || return 126

  local array_name_1="${1}"
  local array_name_2="${2}"

  local array_index

  indirect_reference_1="${array_name_1}[@]"
  indirect_array_1=("${!indirect_reference_1}")
  indirect_reference_2="${array_name_2}[@]"
  indirect_array_2=("${!indirect_reference_2}")

  test "${#indirect_array_1[*]}" == "${#indirect_array_2[*]}" || return 1

  for ((array_index = 0; array_index < "${#indirect_array_1[*]}"; array_index++)); do
    test "${indirect_array_1[array_index]}" == "${indirect_array_2[array_index]}" || return 1
  done

  return 0
}

# @description Checks if a variable is an array.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the variable is an array.
# @exitcode 1 If the variable is not an array.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If the number of arguments is not 1.
stdlib.array.query.is_array() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  if declare -p "${1}" 2> /dev/null | grep -q 'declare -a'; then
    return 0
  fi
  return 1
}

# @description Checks if an array is empty.
# @arg $1 string The name of the array to check.
# @exitcode 0 If the array is empty.
# @exitcode 1 If the array is not empty.
# @exitcode 126 If the argument is not an array.
# @exitcode 127 If the number of arguments is not 1.
stdlib.array.query.is_empty() {
  local indirect_reference
  local indirect_array=()

  [[ "${#@}" == "1" ]] || return 127
  stdlib.array.query.is_array "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  if [[ "${#indirect_array[@]}" == "0" ]]; then
    return 0
  fi
  return 1
}
