#!/bin/bash
# @file assert.sh
# @brief A library for assertions on arrays.
# @description
#   This library provides functions to make assertions on arrays,
#   such as checking for equality, if a variable is an array, or if an array is not empty.
#   These functions are useful for testing and validation.

# stdlib array assert library

set -eo pipefail

# @description Asserts that two arrays are equal.
# It checks if both arrays have the same length and the same elements in the same order.
# @arg $1 string The name of the first array to compare.
# @arg $2 string The name of the second array to compare.
# @exitcode 0 If the arrays are equal.
# @exitcode 1 If the arrays are not equal.
# @exitcode 126 If one of the arguments is not an array.
# @exitcode 127 If the number of arguments is not 2.
# @stderr Logs an error message if the arrays are not equal or if the arguments are invalid.
stdlib.array.assert.equals() {
  local indirect_reference_1
  local indirect_array_1=()
  local indirect_reference_2
  local indirect_array_2=()

  local array_name_1="${1}"
  local array_name_2="${2}"

  [[ "${#@}" == "2" ]] || return 127
  stdlib.array.assert.is_array "${1}" || return 126
  stdlib.array.assert.is_array "${2}" || return 126

  local array_index

  indirect_reference_1="${array_name_1}[@]"
  indirect_array_1=("${!indirect_reference_1}")
  indirect_reference_2="${array_name_2}[@]"
  indirect_array_2=("${!indirect_reference_2}")

  if [[ "${#indirect_array_1[@]}" != "${#indirect_array_2[@]}" ]]; then
    stdlib.logger.error "The array '${array_name_1}' has length '${#indirect_array_1[@]}'"
    stdlib.logger.error "The array '${array_name_2}' has length '${#indirect_array_2[@]}'"
    return 1
  fi

  for ((array_index = 0; array_index < "${#indirect_array_1[@]}"; array_index++)); do
    if [[ "${indirect_array_1[array_index]}" != "${indirect_array_2[array_index]}" ]]; then
      stdlib.logger.error "At index '${array_index}':"
      stdlib.logger.error " the array '${array_name_1}' has element '${indirect_array_1[array_index]}'"
      stdlib.logger.error " the array '${array_name_2}' has element '${indirect_array_2[array_index]}'"
      return 1
    fi
  done

  return 0
}

# @description Asserts that a variable is an array.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the variable is an array.
# @exitcode 1 If the variable is not an array.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the variable is not an array or if the arguments are invalid.
stdlib.array.assert.is_array() {
  local return_code=0

  stdlib.array.query.is_array "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The value '${1}' is not an array!"
      ;;
  esac

  return "${return_code}"
}

# @description Asserts that an array is not empty.
# @arg $1 string The name of the array to check.
# @exitcode 0 If the array is not empty.
# @exitcode 1 If the array is empty.
# @exitcode 126 If the provided argument is not an array.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the array is empty, if the variable is not an array, or if the arguments are invalid.
stdlib.array.assert.is_not_empty() {
  local return_code=0

  stdlib.array.query.is_empty "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "The array '${1}' is empty!"
      return 1
      ;;
    1)
      return 0
      ;;
    126)
      stdlib.logger.error "The value '${1}' is not an array!"
      ;;
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
  esac

  return "${return_code}"
}
