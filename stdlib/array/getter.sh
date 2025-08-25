#!/bin/bash

# stdlib array getter library

builtin set -eo pipefail

_STDLIB_ARRAY_BUFFER=""

stdlib.array.get.last() {
  # $1: the array name

  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.not_empty "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")
  indirect_array_last_element_index="$(("${#indirect_array[@]}" - 1))"

  _STDLIB_ARRAY_BUFFER="${indirect_array[indirect_array_last_element_index]}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

stdlib.array.get.length() {
  # $1: the array name

  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  _STDLIB_ARRAY_BUFFER="${#indirect_array[@]}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

stdlib.array.get.longest() {
  # $1: the array name

  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index
  local current_array_element
  local longest_array_element_length=-1

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.not_empty "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for current_array_element in "${indirect_array[@]}"; do
    if [[ "${#current_array_element}" -gt "${longest_array_element_length}" ]]; then
      longest_array_element_length="${#current_array_element}"
    fi
  done

  _STDLIB_ARRAY_BUFFER="${longest_array_element_length}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

stdlib.array.get.shortest() {
  # $1: the array name

  local indirect_reference
  local indirect_array=()
  local indirect_array_last_element_index
  local current_array_element
  local shortest_array_element_length=-1

  stdlib.fn.args.require "1" "0" "${@}" || return "$?"
  stdlib.array.assert.not_empty "${1}" || return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for current_array_element in "${indirect_array[@]}"; do
    if [[ "${#current_array_element}" -lt "${shortest_array_element_length}" ]] ||
      [[ "${shortest_array_element_length}" == "-1" ]]; then
      shortest_array_element_length="${#current_array_element}"
    fi
  done

  _STDLIB_ARRAY_BUFFER="${shortest_array_element_length}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}
