#!/bin/bash

# stdlib testing parametrize compose library

set -eo pipefail

@parametrize.compose() {
  # $1: the name of the test function to parametrize
  # $@: a series of parametrize functions to compose with this function

  local _PARAMETRIZE_GENERATED_FUNCTIONS=()
  local _PC_COUNTER=0
  local _PC_CURRENT_FUNCTION
  local _PC_STACK_FUNCTIONS=()
  local _PC_STACK_TARGETS=()
  local _PC_TEST_FN_REFERENCE="${1}"
  local _PC_TEST_TARGET

  _PC_STACK_FUNCTIONS=("${@:2}")

  @parametrize._components.validate.fn_name.test "${_PC_TEST_FN_REFERENCE}"
  @parametrize._components.create.array.fn_variant_tags "${@:2}"

  _PC_STACK_TARGETS=("${_PC_TEST_FN_REFERENCE}")
  for ((_PC_COUNTER = 0; _PC_COUNTER < "${#_PC_STACK_FUNCTIONS[@]}"; _PC_COUNTER++)); do
    _PC_CURRENT_FUNCTION="${_PC_STACK_FUNCTIONS[_PC_COUNTER]}"
    _PARAMETRIZE_GENERATED_FUNCTIONS=()
    for _PC_TEST_TARGET in "${_PC_STACK_TARGETS[@]}"; do
      "${_PC_CURRENT_FUNCTION}" "${_PC_TEST_TARGET}"
    done
    _PC_STACK_TARGETS=("${_PARAMETRIZE_GENERATED_FUNCTIONS[@]}")
  done

  #:nocov:
  # bashcov doesn't report this section correctly
  unset -f "${1}"
  #:nocov:
}
