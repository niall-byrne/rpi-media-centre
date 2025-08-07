#!/bin/bash

# stdlib testing parametrize apply library

set -eo pipefail

@parametrize.apply() {
  # $1: the name of the test function to parametrize
  # $@: a series of parametrize functions to apply to this function

  local _PM_COUNTER=0
  local _PM_CURRENT_FUNCTION
  local _PM_STACK_FUNCTIONS=()
  local _PM_WRAPPED_FN_NAME=""
  local _PM_WRAPPED_FN_REFERENCE=""

  local _PARAMETRIZED_STACK_VARIANTS=()
  local _PARAMETRIZED_PADDING_VALUE=0

  _PM_WRAPPED_FN_NAME="${1}"
  _PM_STACK_FUNCTIONS=("${@:2}")

  @parametrize._components.validate.fn_name.test "${_PM_WRAPPED_FN_NAME}"

  @parametrize._components.create.array.fn_variant_tags "${@:2}"

  for ((_PM_COUNTER = 0; _PM_COUNTER < "${#_PM_STACK_FUNCTIONS[@]}"; _PM_COUNTER++)); do
    _PM_CURRENT_FUNCTION="${_PM_STACK_FUNCTIONS[_PM_COUNTER]}"
    _PM_WRAPPED_FN_REFERENCE="$(
      #:nocov:
      # bashcov doesn't report this section correctly
      @parametrize._components.create.string.padded_test_fn_variant_name \
        "${_PM_WRAPPED_FN_NAME}" \
        "${_PARAMETRIZED_STACK_VARIANTS[_PM_COUNTER]}" \
        "${_PARAMETRIZED_PADDING_VALUE}"
      #:nocov:
    )"
    stdlib.fn.derive.clone \
      "${_PM_WRAPPED_FN_NAME}" \
      "${_PM_WRAPPED_FN_REFERENCE}"

    "${_PM_CURRENT_FUNCTION}" "${_PM_WRAPPED_FN_REFERENCE}"
  done

  unset -f "${_PM_WRAPPED_FN_NAME}"
}
