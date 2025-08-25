#!/bin/bash

# stdlib testing mock arg_string library

builtin set -eo pipefail

_mock.arg_string.from_array() {
  # $1: the array name to generate an arg string from
  # $2: an optional array name to generate keyword args from

  local _mock_arg_string=""
  local _mock_arg_string_spacer=""
  local _mock_array_index
  local _mock_generated_mock_arg_array
  local _mock_keyword_arg
  local _mock_keyword_args_array=()
  local _mock_keyword_args_array_indirect_reference
  local _mock_position_args_array=()
  local _mock_positional_args_array_indirect_reference

  __testing.protected stdlib.fn.args.require "1" "1" "$@" || return 127
  __testing.protected stdlib.array.assert.is_array "${1}" || return 126

  if [[ "${#@}" == 2 ]]; then
    __testing.protected stdlib.array.assert.is_array "${2}" || return 126
  fi

  __mock.arg_array.from_array \
    _mock_generated_mock_arg_array \
    "${@}"

  builtin echo "${_mock_generated_mock_arg_array[*]}"
}

_mock.arg_string.from_string() {
  # $1: the string to generate an arg string from
  # $2: an optional array name to generate keyword args from
  # _STDLIB_DELIMITER: a char sequence to split the string with, defaults to ' '

  local _mock_args_array=()
  local _mock_arg_string_args=("_mock_args_array")
  local _mock_separator="${_STDLIB_DELIMITER:- }"

  local _STDLIB_ARGS_NULL_SAFE=("2")

  __testing.protected stdlib.fn.args.require "1" "1" "${@}" || return 127

  if [[ -n "${2}" ]]; then
    _mock_arg_string_args+=("${2}")
  fi

  __testing.protected stdlib.array.make.from_string _mock_args_array "${_mock_separator}" "${1}" || return "$?"

  _mock.arg_string.from_array "${_mock_arg_string_args[@]}"
}
