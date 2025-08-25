#!/bin/bash

# stdlib array extensions to bash_unit assertions

builtin set -eo pipefail

assert_array_equals() {
  # $1: the first array to compare
  # $2: the second array to compare

  local _stdlib_assertion_ouput
  local _stdlib_return_code=0

  _stdlib_assertion_output="$(__testing.protected stdlib.array.assert.is_equal "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_array_length() {
  # $1: the expected length
  # $2: the variable name

  if [[ $# -ne 2 ]]; then
    fail " $(_testing.assert.message.get ASSERT_ERROR_INSUFFICIENT_ARGS assert_array_length)"
  fi

  local _stdlib_expected_length="${1}"
  local _stdlib_indirect_reference
  local _stdlib_indirect_array=()
  local _stdlib_variable_name="${2}"

  _testing.__assertion.value.check "${_stdlib_variable_name}"
  __testing.protected assert_is_array "${_stdlib_variable_name}"

  _stdlib_indirect_reference="${_stdlib_variable_name}[@]"
  _stdlib_indirect_array=("${!_stdlib_indirect_reference}")

  assert_equals "${_stdlib_expected_length}" \
    "${#_stdlib_indirect_array[*]}" ||
    fail " $(_testing.assert.message.get ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING "${_stdlib_expected_length}" "${#_stdlib_indirect_array[*]}")"
}

assert_is_array() {
  # $1: the variable to check

  local _stdlib_assertion_ouput
  local _stdlib_return_code=0

  _stdlib_assertion_output="$(__testing.protected stdlib.array.assert.is_array "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}
