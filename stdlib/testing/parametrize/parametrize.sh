#!/bin/bash

# stdlib testing parametrize library

builtin set -eo pipefail

_PARAMETRIZE_DEBUG="${PARAMETRIZE_DEBUG:-"0"}"
_PARAMETRIZE_FIELD_SEPARATOR=";"
_PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture "
_PARAMETRIZE_PARAMETRIZER_PREFIX="@parametrize_with_"
_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES="0"
_PARAMETRIZE_VARIANT_TAG="@vary"

_PARAMETRIZE_GENERATED_FUNCTIONS=()

@parametrize() {
  # $1: (required) the name of the test function to parametrize
  # $@: (optional) test fixtures (or setup commands to execute) before test execution begins.
  #     These commands can have access to the variables that have been parametrized for
  #     more complex scenario generation.
  #     i.e. "@fixture function_name" or "@fixture builtin echo hello"
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

  # shellcheck disable=SC2034
  local PARAMETRIZE_SCENARIO_NAME

  original_test_function_name="${1}"
  original_test_function_reference="__parametrized_original_function_definition_${1}"

  [[ "${#@}" -gt "1" ]] || {
    _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    return 127
  }
  @parametrize._components.validate.fn_name.test "${original_test_function_name}" || return "$?"

  stdlib.fn.derive.clone \
    "${original_test_function_name}" \
    "${original_test_function_reference}"

  builtin unset -f "${1}"

  shift

  parametrize_configuration=("${@}")

  @parametrize._components.configuration.parse \
    parametrize_configuration \
    parametrize_configuration_scenario_start_index \
    array_environment_variables \
    array_fixture_commands \
    test_function_variant_padding_value || return "$?"

  parametrize_configuration=("${parametrize_configuration[@]:parametrize_configuration_scenario_start_index}")

  for ((parametrize_configuration_index = 0; "${parametrize_configuration_index}" < "${#parametrize_configuration[@]}"; parametrize_configuration_index++)); do
    parametrize_configuration_line="${parametrize_configuration[parametrize_configuration_index]}"
    IFS="${_PARAMETRIZE_FIELD_SEPARATOR}" read -ra array_scenario_values <<< "${parametrize_configuration_line}"

    test_function_variant_name="$(
      @parametrize._components.create.string.padded_test_fn_variant_name \
        "${original_test_function_name}" \
        "${array_scenario_values[0]}" \
        "${test_function_variant_padding_value}"
    )"

    if stdlib.fn.query.is_fn "${test_function_variant_name}"; then
      _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)"
      {
        _testing.message.get PARAMETRIZE_PREFIX_TEST_NAME
        builtin echo ": '$(
          __testing.protected stdlib.string.colour \
            "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" \
            "${original_test_function_name}"
        )'"
        _testing.message.get PARAMETRIZE_PREFIX_VARIANT_NAME
        builtin echo ": '$(
          __testing.protected stdlib.string.colour \
            "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" \
            "${test_function_variant_name}"
        )'"
      } >&2 # KCOV_EXCLUDE_LINE
      _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)"
      return 126
    fi

    @parametrize._components.create.fn.test_variant \
      "${test_function_variant_name}" \
      "${original_test_function_name}" \
      "${original_test_function_reference}" \
      array_environment_variables \
      array_fixture_commands \
      array_scenario_values

    _PARAMETRIZE_GENERATED_FUNCTIONS+=("${test_function_variant_name}")

  done
}
