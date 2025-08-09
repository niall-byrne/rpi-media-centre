#!/bin/bash

# stdlib testing parametrize validate component

set -eo pipefail

@parametrize._components.validate.fn_name.parametrizer() {
  # $1: the parametrizer function name to validate

  if ! stdlib.string.query.starts_with "${_PARAMETRIZE_MULTIPLE_PREFIX}" "${1}"; then
    _testing.error "The function '${1}' cannot be used in a parametrize series!  It's name must be prefixed with '${_PARAMETRIZE_MULTIPLE_PREFIX}' !"
  fi
}

@parametrize._components.validate.fn_name.test() {
  # $1: the test function name to validate

  if ! stdlib.string.query.has_substring "${_PARAMETRIZE_VARIANT_TAG}" "${1}" ||
    ! stdlib.string.query.starts_with "test" "${1}"; then
    _testing.error "The function '${1}' cannot be parametrized.  It's name must start with 'test' and contain a '${_PARAMETRIZE_VARIANT_TAG}' tag, please rename this function!"
  fi
}

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
