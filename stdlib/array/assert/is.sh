#!/bin/bash

# stdlib array assert is library

builtin set -eo pipefail

stdlib.array.assert.is_array() {
  # $1: the array name

  local _stdlib_return_code=0

  stdlib.array.query.is_array "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ARRAY "${1}")"
      ;;
  esac

  return "${_stdlib_return_code}"
}

stdlib.array.assert.is_contains() {
  # $1: the value to assert is present
  # $2: the array name

  local _stdlib_return_code=0

  stdlib.array.query.is_contains "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARRAY_VALUE_NOT_FOUND "${1}" "${2}")"
      ;;
  esac

  return "${_stdlib_return_code}"
}

stdlib.array.assert.is_empty() {
  # $1: the array name

  local _stdlib_return_code=0

  stdlib.array.query.is_empty "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get ARRAY_IS_NOT_EMPTY "${1}")"
      ;;
    126)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ARRAY "${1}")"
      ;;
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  return "${_stdlib_return_code}"
}

stdlib.array.assert.is_equal() {
  # $1: the name of the first array to compare
  # $2: the name of the second array to compare

  local _stdlib_array_index
  local _stdlib_array_name_1="${1}"
  local _stdlib_array_name_2="${2}"
  local _stdlib_comparison_errors_array=()
  local _stdlib_indirect_array_1=()
  local _stdlib_indirect_array_2=()
  local _stdlib_indirect_reference_1
  local _stdlib_indirect_reference_2

  [[ "${#@}" == "2" ]] || {
    stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
    return 127
  }
  stdlib.array.assert.is_array "${1}" || return 126
  stdlib.array.assert.is_array "${2}" || return 126

  _stdlib_indirect_reference_1="${_stdlib_array_name_1}[@]"
  _stdlib_indirect_array_1=("${!_stdlib_indirect_reference_1}")
  _stdlib_indirect_reference_2="${_stdlib_array_name_2}[@]"
  _stdlib_indirect_array_2=("${!_stdlib_indirect_reference_2}")

  if [[ "${#_stdlib_indirect_array_1[@]}" != "${#_stdlib_indirect_array_2[@]}" ]]; then
    _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_LENGTH_MISMATCH "${_stdlib_array_name_1}" "${#_stdlib_indirect_array_1[@]}")")
    _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_LENGTH_MISMATCH "${_stdlib_array_name_2}" "${#_stdlib_indirect_array_2[@]}")")
  fi

  for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_indirect_array_1[@]}"; _stdlib_array_index++)); do
    if ((_stdlib_array_index == "${#_stdlib_indirect_array_2[@]}")); then
      builtin break
    fi
    if [[ "${_stdlib_indirect_array_1[_stdlib_array_index]}" != "${_stdlib_indirect_array_2[_stdlib_array_index]}" ]]; then
      _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_ELEMENT_MISMATCH "${_stdlib_array_name_1}" "${_stdlib_array_index}" "${_stdlib_indirect_array_1[_stdlib_array_index]}")")
      _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_ELEMENT_MISMATCH "${_stdlib_array_name_2}" "${_stdlib_array_index}" "${_stdlib_indirect_array_2[_stdlib_array_index]}")")
    fi
  done

  if [[ "${#_stdlib_comparison_errors_array[@]}" -gt "0" ]]; then
    for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_comparison_errors_array[@]}"; _stdlib_array_index++)); do
      stdlib.logger.error "${_stdlib_comparison_errors_array[_stdlib_array_index]}"
    done
    return 1
  fi

  return 0
}
