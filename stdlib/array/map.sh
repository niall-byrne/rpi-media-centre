#!/bin/bash
# @file map.sh
# @brief A library for applying functions or formats to array elements.
# @description
#   This library provides functions to map over an array and apply a format string or a function to each element.

# stdlib array map library

set -eo pipefail

# @description Applies a printf format string to each element of an array.
# @arg $1 string A valid printf format string.
# @arg $2 string The name of the array to process.
# @stdout The formatted elements, each on a new line.
# @exitcode 126 If the second argument is not an array.
# @exitcode ? Propagated from stdlib.fn.args.require.
stdlib.array.map.format() {
  local element
  local indirect_reference
  local indirect_array=()

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for element in "${indirect_array[@]}"; do
    # shellcheck disable=SC2059
    printf "${1}"$'\n' "${element}"
  done
}

# @description Applies a function to each element of an array.
# @arg $1 string The name of the function to apply.
# @arg $2 string The name of the array to process.
# @stdout The output of the function for each element.
# @exitcode 126 If the first argument is not a function or the second is not an array.
# @exitcode ? Propagated from stdlib.fn.args.require.
stdlib.array.map.fn() {
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
