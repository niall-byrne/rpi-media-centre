#!/bin/bash

# stdlib testing parametrize library

set -eo pipefail

_PARAMETRIZE_DEBUG="${PARAMETRIZE_DEBUG:-''}"
_PARAMETRIZE_FIELD_SEPERATOR=","
_PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture "
_PARAMETRIZE_MULTIPLE_PREFIX="@parametrize_with_"
_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES=""
_PARAMETRIZE_VARIANT_TAG="@vary"
_PARAMETRIZE_GENERATED_FUNCTIONS=()

@parametrize() {
  # $1: (required) the name of the test function to parametrize
  # $@: (optional) test fixtures (or setup commands to execute) before test execution begins.
  #     These commands can have access to the variables that have been parametrized for
  #     more complex scenario generation.
  #     i.e. "@fixture function_name" or "@fixture echo hello"
  # $X: (required) a comma separate list of variable names
  #     i.e. VAR1,VAR2,VAR3
  # $@: (required) a comma separated list of a scenario name, and values comprising a test scenario
  #     i.e. SCENARIO_NAME,VALUE1,VALUE2,VALUE3

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
