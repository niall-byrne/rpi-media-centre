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

  # shellcheck disable=SC2034
  {
    local array_environment_variables=()
    local array_fixture_commands=()
    local array_scenario_values=()
  }
  local original_test_function_name=""
  local original_test_function_reference=""
  local parametrize_configuration=()
  local parametrize_configuration_index=0
  local parametrize_configuration_line=""
  local parametrize_configuration_scenario_start_index
  local test_function_variant_name=""
  local test_function_variant_padding_value=0

  original_test_function_name="${1}"
  original_test_function_reference="__parametrized_original_function_definition_${1}"

  [[ "${#@}" -gt "1" ]] || {
    _testing.error "${FUNCNAME[0]}: invalid arguments provided!"
    return 127
  }
  @parametrize._components.validate.fn_name.test "${original_test_function_name}" || return "$?"

  stdlib.fn.derive.clone \
    "${original_test_function_name}" \
    "${original_test_function_reference}"

  unset -f "${1}"

  shift

  parametrize_configuration=("${@}")

  #:nocov:
  # bashcov doesn't report this section correctly
  @parametrize._components.configuration.parse \
    parametrize_configuration \
    parametrize_configuration_scenario_start_index \
    array_environment_variables \
    array_fixture_commands \
    test_function_variant_padding_value || return "$?"
  #:nocov:

  parametrize_configuration=("${parametrize_configuration[@]:parametrize_configuration_scenario_start_index}")

  for ((parametrize_configuration_index = 0; "${parametrize_configuration_index}" < "${#parametrize_configuration[@]}"; parametrize_configuration_index++)); do
    parametrize_configuration_line="${parametrize_configuration[parametrize_configuration_index]}"
    IFS="${_PARAMETRIZE_FIELD_SEPERATOR}" read -ra array_scenario_values <<< "${parametrize_configuration_line}"

    test_function_variant_name="$(
      #:nocov:
      # bashcov doesn't report this section correctly
      @parametrize._components.create.string.padded_test_fn_variant_name \
        "${original_test_function_name}" \
        "${array_scenario_values[0]}" \
        "${test_function_variant_padding_value}"
      #:nocov:
    )"

    if stdlib.fn.query.is_fn "${test_function_variant_name}"; then
      _testing.error "Duplicate test variant name!"
      {
        echo "Test Name: '${STDLIB_COLOUR_LIGHT_BLUE}${original_test_function_name}${STDLIB_COLOUR_NC}'"
        echo "Variant name: '${STDLIB_COLOUR_LIGHT_BLUE}${test_function_variant_name}${STDLIB_COLOUR_NC}'"
        #:nocov:
        # bashcov doesn't report this section correctly
      } >&2
      _testing.error "This test variant was created twice, please check your parametrize configuration for this test."
      return 126
      #:nocov:
    fi

    #:nocov:
    # bashcov doesn't report this section correctly
    @parametrize._components.create.fn.test_variant \
      "${test_function_variant_name}" \
      "${original_test_function_name}" \
      "${original_test_function_reference}" \
      array_environment_variables \
      array_fixture_commands \
      array_scenario_values
    #:nocov:

    _PARAMETRIZE_GENERATED_FUNCTIONS+=("${test_function_variant_name}")

  done
}
