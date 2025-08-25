#!/bin/bash

# stdlib testing mock internal arg_array library

builtin set -eo pipefail

__mock.arg_array.from_array() {
  # $1: the name of the array to create
  # $2: the array name to generate an arg string from
  # $3: an optional array name to generate keyword args from

  local _mock_arg_array=()
  local _mock_array_index
  local _mock_arg_element
  local _mock_keyword_args_array=()
  local _mock_keyword_args_array_indirect_reference
  local _mock_position_args_array=()
  local _mock_positional_args_array_indirect_reference

  _mock_positional_args_array_indirect_reference="${2}[@]"
  _mock_position_args_array=("${!_mock_positional_args_array_indirect_reference}")

  if [[ -n "${3}" ]]; then
    _mock_keyword_args_array_indirect_reference="${3}[@]"
    _mock_keyword_args_array=("${!_mock_keyword_args_array_indirect_reference}")
  fi

  for ((_mock_array_index = 0; _mock_array_index < "${#_mock_position_args_array[@]}"; _mock_array_index++)); do
    _mock_arg_array+=("$((_mock_array_index + 1))(${_mock_position_args_array[_mock_array_index]})")
  done

  for ((_mock_array_index = 0; _mock_array_index < "${#_mock_keyword_args_array[@]}"; _mock_array_index++)); do
    _mock_keyword_arg="${_mock_keyword_args_array[_mock_array_index]}"
    if [[ -n "${_mock_keyword_arg}" ]]; then
      if __testing.protected stdlib.array.query.is_array "${_mock_keyword_arg}"; then
        _mock_arg_array+=("${_mock_keyword_arg}($(__mock.arg_array.array_arg_as_string))")
      else
        _mock_arg_array+=("${_mock_keyword_arg}(${!_mock_keyword_arg})")
      fi
    fi
  done

  if [[ ${#_mock_arg_array[@]} == "0" ]]; then
    builtin eval "${1}=()"
  else
    builtin eval "${1}=($(builtin printf '%q ' "${_mock_arg_array[@]}"))"
  fi
}

__mock.arg_array.array_arg_as_string() {
  local _mock_keyword_array_arg_indirect_reference
  local _mock_keyword_array_arg=()
  local _mock_keyword_array_arg_as_string

  _mock_keyword_array_arg_indirect_reference="${_mock_keyword_arg}[@]"
  _mock_keyword_array_arg=("${!_mock_keyword_array_arg_indirect_reference}")

  if [[ "${#_mock_keyword_array_arg[@]}" -eq 0 ]]; then
    _mock_keyword_array_arg_as_string=" "
  else
    _mock_keyword_array_arg_as_string="$(builtin printf "'%q' " "${_mock_keyword_array_arg[@]}")"
  fi

  builtin echo "${_mock_keyword_array_arg_as_string%?}"
}
