#!/bin/bash
# @file create.sh
# @brief A component for creating parts of parametrized tests.
# @description
#   This script is a component of the parametrization framework. It is not meant to be sourced directly.
#   It provides functions to create variant tags and padded test function names.

# stdlib testing parametrize create component

set -eo pipefail

# @description Creates an array of function variant tags from an array of function names.
# This is an internal function.
# @arg $@ An array of function names to convert to variant tags.
@parametrize._components.create.array.fn_variant_tags() {
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

# @description Creates a padded test function variant name.
# This is an internal function.
# @arg $1 string The function name to parametrize.
# @arg $2 string The function variant's description.
# @arg $3 integer The length of the longest variant description for padding.
# @stdout The padded test function variant name.
@parametrize._components.create.string.padded_test_fn_variant_name() {
  local PADDED_VARIANT_NAME

  PADDED_VARIANT_NAME="${2// /_}"

  if (("${3}" > "${#2}")); then
    PADDED_VARIANT_NAME="$(stdlib.string.pad.right "$(("${3}" - "${#2}"))" "${PADDED_VARIANT_NAME}")"
    PADDED_VARIANT_NAME="${PADDED_VARIANT_NAME// /_}"
  fi

  echo "${1/"${_PARAMETRIZE_VARIANT_TAG}"/"${PADDED_VARIANT_NAME}"}"
}
