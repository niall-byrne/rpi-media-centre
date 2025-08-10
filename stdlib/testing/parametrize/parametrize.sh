#!/bin/bash
# @file parametrize.sh
# @brief A library for parametrizing tests.
# @description
#   This library provides a function to parametrize tests, allowing to run the same test with different inputs.

# stdlib testing parametrize library

set -eo pipefail

_PARAMETRIZE_DEBUG="${PARAMETRIZE_DEBUG:-''}"
_PARAMETRIZE_FIELD_SEPERATOR=","
_PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture "
_PARAMETRIZE_MULTIPLE_PREFIX="@parametrize_with_"
_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES=""
_PARAMETRIZE_VARIANT_TAG="@vary"
_PARAMETRIZE_GENERATED_FUNCTIONS=()

# @description Parametrizes a test function.
# It generates a new test function for each scenario provided.
# @arg $1 string The name of the test function to parametrize.
# @arg $@ A list of fixtures, variable names, and scenarios.
#   - Fixtures start with `@fixture`.
#   - The first argument that is not a fixture is the list of variable names, comma-separated.
#   - The rest of the arguments are the scenarios, each being a comma-separated list of a scenario name and values.
@parametrize() {
  local _P_CONFIGURATION_LINE=""
  local _P_CONFIGURATION_LINES=()
  local _P_INDEX=0
  local _P_ORIGINAL_FN_NAME=""
  local _P_ORIGINAL_FN_REFERENCE=""
  local _P_PADDING=0
  local _P_SCENARIO_INDEX=0
  local _P_SCENARIO_DEBUG=""
  local _P_STACK_ENV_VARS=()
  local _P_STACK_FIXTURES=()
  local _P_STACK_SCENARIOS=()
  local _P_WRAPPED_FN_NAME=""
  local _P_EMIT_FUNCTION_NAMES="${_P_EMIT_FUNCTION_NAMES:-0}"

  _P_ORIGINAL_FN_NAME="${1}"
  _P_ORIGINAL_FN_REFERENCE="__parametrized_original_function_definition_${1}"

  @parametrize._components.validate.fn_name.test "${_P_ORIGINAL_FN_NAME}"

  stdlib.fn.derive.clone \
    "${_P_ORIGINAL_FN_NAME}" \
    "${_P_ORIGINAL_FN_REFERENCE}"

  unset -f "${1}"

  shift

  _P_CONFIGURATION_LINES=("${@}")

  @parametrize._components.configuration.parse "${_P_CONFIGURATION_LINES[@]}"

  for ((_P_INDEX = 0; "${_P_INDEX}" < "${#_P_CONFIGURATION_LINES[@]}"; _P_INDEX++)); do
    _P_CONFIGURATION_LINE="${_P_CONFIGURATION_LINES[_P_INDEX]}"
    IFS="${_PARAMETRIZE_FIELD_SEPERATOR}" read -ra _P_STACK_SCENARIOS <<< "${_P_CONFIGURATION_LINE}"
    @parametrize._components.validate.scenario

    _P_WRAPPED_FN_NAME="$(
      #:nocov:
      # bashcov doesn't report this section correctly
      @parametrize._components.create.string.padded_test_fn_variant_name \
        "${_P_ORIGINAL_FN_NAME}" \
        "${_P_STACK_SCENARIOS[0]}" \
        "${_P_PADDING}"
      #:nocov:
    )"

    @parametrize._components.fn

    _PARAMETRIZE_GENERATED_FUNCTIONS+=("${_P_WRAPPED_FN_NAME}")

  done
}
