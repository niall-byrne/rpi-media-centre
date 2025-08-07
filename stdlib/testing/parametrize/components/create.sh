#!/bin/bash

# stdlib testing parametrize create component

set -eo pipefail

@parametrize._components.create.array.fn_variant_tags() {
  # $@: an array of function names to convert to variant tags

  local __INDEX=""
  local __FUNCTION=""
  local __VARIANT=""
  for ((__INDEX = 1; __INDEX <= "${#@}"; __INDEX++)); do
    __FUNCTION="${!__INDEX}"
    @parametrize._components.validate.fn_name.parametrizer "${__FUNCTION}"
    __VARIANT="${__FUNCTION/${_PARAMETRIZE_MULTIPLE_PREFIX}/}"
    _PARAMETRIZED_STACK_VARIANTS+=("${__VARIANT}")
    if [[ "${#__VARIANT}" -gt "${_PARAMETRIZED_PADDING_VALUE}" ]]; then
      _PARAMETRIZED_PADDING_VALUE="${#__VARIANT}"
    fi
  done
}

@parametrize._components.create.string.padded_test_fn_variant_name() {
  # $1: the function name to parametrize
  # $2: the function variant's description
  # $3: the length of the longest variant description for padding

  local PADDED_VARIANT_NAME

  PADDED_VARIANT_NAME="${2// /_}"

  if (("${3}" > "${#2}")); then
    PADDED_VARIANT_NAME="$(stdlib.string.pad.right "$(("${3}" - "${#2}"))" "${PADDED_VARIANT_NAME}")"
    PADDED_VARIANT_NAME="${PADDED_VARIANT_NAME// /_}"
  fi

  echo "${1/"${_PARAMETRIZE_VARIANT_TAG}"/"${PADDED_VARIANT_NAME}"}"
}
