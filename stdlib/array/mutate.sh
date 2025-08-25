#!/bin/bash

# stdlib array mutate library

builtin set -eo pipefail

stdlib.array.mutate.append() {
  # $1: the string to append
  # $2: the array name to modify in place

  local _STDLIB_ARGS_NULL_SAFE=("1")
  local indirect_array=()
  local indirect_array_index
  local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    indirect_array[indirect_array_index]="${indirect_array[indirect_array_index]}${1}"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

stdlib.array.mutate.fn() {
  # $1: a valid function to apply to each element
  # $2: the array name to modify in place

  local indirect_array=()
  local indirect_array_index=0
  local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    # shellcheck disable=SC2059
    indirect_array[indirect_array_index]="$("${1}" "${indirect_array[indirect_array_index]}")"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

stdlib.array.mutate.filter() {
  # $1: the filter function (a match is based on status code 0)
  # $2: the array name to modify in place

  local array_element
  local new_array=()
  local indirect_array
  local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for array_element in "${indirect_array[@]}"; do
    if "${1}" "${array_element}"; then
      new_array+=("${array_element}")
    fi
  done

  if [[ "${#new_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${new_array[@]}"))"
  fi
}

stdlib.array.mutate.format() {
  # $1: a valid print format string to apply to each element
  # $2: the array name to modify in place

  local indirect_array=()
  local indirect_array_index=0
  local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    # shellcheck disable=SC2059
    indirect_array[indirect_array_index]="$(builtin printf "${1}" "${indirect_array[indirect_array_index]}")"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

stdlib.array.mutate.insert() {
  # $1: the string to insert
  # $2: the index to insert the string at
  # $3: the array name to modify in place

  local _STDLIB_ARGS_NULL_SAFE=("1")
  local indirect_array=()
  local indirect_reference

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${3}" || return 126

  indirect_reference="${3}[@]"
  indirect_array=("${!indirect_reference}")

  stdlib.string.assert.is_integer_with_range "0" "${#indirect_array[@]}" "${2}" || return 126

  indirect_array=("${indirect_array[@]:"0":"${2}"}" "${1}" "${indirect_array[@]:"${2}"}")
  builtin eval "${3}=($(builtin printf '%q ' "${indirect_array[@]}"))"
}

stdlib.array.mutate.prepend() {
  # $1: the string to prepend
  # $2: the array name to modify in place

  local _STDLIB_ARGS_NULL_SAFE=("1")
  local indirect_array=()
  local indirect_array_index
  local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    indirect_array[indirect_array_index]="${1}${indirect_array[indirect_array_index]}"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

stdlib.array.mutate.remove() {
  # $1: the index to insert the string at
  # $2: the array name to modify in place

  local indirect_array=()
  local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126
  stdlib.array.assert.not_empty "${2}" || return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  stdlib.string.assert.is_integer_with_range "0" "$(("${#indirect_array[@]}" - 1))" "${1}" || return 126

  builtin unset 'indirect_array["${1}"]'
  builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
}

stdlib.array.mutate.reverse() {
  # $1: the array name to modify in place

  local element
  local indirect_array=()
  local indirect_array_index_1
  local indirect_array_index_2
  local indirect_reference

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index_1 = 0, indirect_array_index_2 = "${#indirect_array[@]}" - 1; indirect_array_index_1 < indirect_array_index_2; indirect_array_index_1++, indirect_array_index_2--)); do
    element="${indirect_array[indirect_array_index_1]}"
    indirect_array[indirect_array_index_1]="${indirect_array[indirect_array_index_2]}"
    indirect_array[indirect_array_index_2]="${element}"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${1}=()"
  else
    builtin eval "${1}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}
