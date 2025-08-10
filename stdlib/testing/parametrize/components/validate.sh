#!/bin/bash
# @file validate.sh
# @brief A component for validating parts of parametrized tests.
# @description
#   This script is a component of the parametrization framework. It is not meant to be sourced directly.
#   It provides functions to validate function names and scenarios.

# stdlib testing parametrize validate component

set -eo pipefail

# @description Validates the name of a parametrizer function.
# This is an internal function.
# @arg $1 string The parametrizer function name to validate.
@parametrize._components.validate.fn_name.parametrizer() {
  if ! stdlib.string.query.starts_with "${_PARAMETRIZE_MULTIPLE_PREFIX}" "${1}"; then
    _testing.error "The function '${1}' cannot be used in a parametrize series!  It's name must be prefixed with '${_PARAMETRIZE_MULTIPLE_PREFIX}' !"
  fi
}

# @description Validates the name of a test function.
# This is an internal function.
# @arg $1 string The test function name to validate.
@parametrize._components.validate.fn_name.test() {
  if ! stdlib.string.query.has_substring "${_PARAMETRIZE_VARIANT_TAG}" "${1}" ||
    ! stdlib.string.query.starts_with "test" "${1}"; then
    _testing.error "The function '${1}' cannot be parametrized.  It's name must start with 'test' and contain a '${_PARAMETRIZE_VARIANT_TAG}' tag, please rename this function!"
  fi
}

# @description Validates a scenario configuration.
# This is an internal function.
@parametrize._components.validate.scenario() {
  local VALIDATION_INDEX

  if (("${#_P_STACK_SCENARIOS[@]}" != "${#_P_STACK_ENV_VARS[@]}" + 1)); then
    {
      echo "== Begin Scenario Values =="
      for ((VALIDATION_INDEX = 0; VALIDATION_INDEX < "${#_P_STACK_ENV_VARS[@]}"; VALIDATION_INDEX++)); do
        echo "  ${_P_STACK_ENV_VARS[VALIDATION_INDEX]} = ${_P_STACK_SCENARIOS[VALIDATION_INDEX + 1]}"
      done
      echo "== End Scenario Values =="
      #:nocov:
      # bashcov doesn't report this section correctly
    } >&2
    #:nocov:
    _testing.error \
      "Misconfigured parametrize parameters!" \
      "Scenario Name: '${_P_STACK_SCENARIOS[0]}'" \
      "Variables: '${_P_STACK_ENV_VARS[*]}' = ${#_P_STACK_ENV_VARS[@]} variables" \
      "Value Set: '${_P_STACK_SCENARIOS[*]:1}' = $((${#_P_STACK_SCENARIOS[@]} - 1)) values" \
      "Fixture Commands: $(printf "'%s' " "${_P_STACK_FIXTURES[@]}")"
  fi
}
