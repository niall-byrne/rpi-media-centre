#!/bin/bash

# stdlib testing parametrize compose library

builtin set -eo pipefail

@parametrize.compose() {
  # $1: the name of the test function to parametrize
  # $@: a series of parametrize functions to compose with this function

  local _PARAMETRIZE_GENERATED_FUNCTIONS=()
  local original_test_function_name="${1}"
  local parametrizer_fn
  local parametrizer_fn_array=()
  local parametrizer_fn_target
  local parametrizer_fn_targets=()
  local parametrizer_index=0

  parametrizer_fn_array=("${@:2}")

  [[ "${#@}" -gt "1" ]] || {
    _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    return 127
  }
  @parametrize._components.validate.fn_name.test "${original_test_function_name}" || return 126

  parametrizer_fn_targets=("${original_test_function_name}")
  for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++)); do
    parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}"
    @parametrize._components.validate.fn_name.parametrizer "${parametrizer_fn}" || return 126
    _PARAMETRIZE_GENERATED_FUNCTIONS=()
    for parametrizer_fn_target in "${parametrizer_fn_targets[@]}"; do
      "${parametrizer_fn}" "${parametrizer_fn_target}"
    done
    parametrizer_fn_targets=("${_PARAMETRIZE_GENERATED_FUNCTIONS[@]}")
  done

  builtin unset -f "${original_test_function_name}"
}
