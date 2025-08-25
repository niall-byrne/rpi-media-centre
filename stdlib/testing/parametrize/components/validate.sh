#!/bin/bash

# stdlib testing parametrize validate component

builtin set -eo pipefail

@parametrize._components.validate.fn_name.parametrizer() {
  # $1: the parametrizer function name to validate

  if ! stdlib.fn.query.is_fn "${1}"; then
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")"
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)"
    return 126
  fi

  if ! stdlib.string.query.starts_with "${_PARAMETRIZE_PARAMETRIZER_PREFIX}" "${1}"; then
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")"
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)"
    return 126
  fi
}

@parametrize._components.validate.fn_name.test() {
  # $1: the test function name to validate

  if ! stdlib.fn.query.is_fn "${1}"; then
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")"
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)"
    return 126
  fi

  if ! stdlib.string.query.has_substring "${_PARAMETRIZE_VARIANT_TAG}" "${1}" ||
    ! stdlib.string.query.starts_with "test" "${1}"; then
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")"
    _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_NAME)"
    return 126
  fi
}

@parametrize._components.validate.scenario() {
  # $1: the name of the array containing the environment variable names
  # $2: the name of the array containing the fixture commands
  # $3: the name of the array containing the scenario configuration

  local validate_env_var_indirect_array_reference
  local validate_env_var_indirect_array=()
  local validate_fixture_indirect_command_array_reference
  local validate_fixture_indirect_command_array=()
  local validate_scenario_indirect_array_reference
  local validate_scenario_indirect_array=()

  validate_env_var_indirect_array_reference="${1}[@]"
  validate_env_var_indirect_array=("${!validate_env_var_indirect_array_reference}")
  validate_fixture_indirect_command_array_reference="${2}[@]"
  validate_fixture_indirect_command_array=("${!validate_fixture_indirect_command_array_reference}")
  validate_scenario_indirect_array_reference="${3}[@]"
  validate_scenario_indirect_array=("${!validate_scenario_indirect_array_reference}")

  local validation_index

  if (("${#validate_scenario_indirect_array[@]}" != "${#validate_env_var_indirect_array[@]}" + 1)); then
    {
      _testing.message.get PARAMETRIZE_HEADER_SCENARIO_VALUES
      builtin echo
      for ((validation_index = 0; validation_index < "${#validate_env_var_indirect_array[@]}"; validation_index++)); do
        builtin echo "  ${validate_env_var_indirect_array[validation_index]} = ${validate_scenario_indirect_array[validation_index + 1]}"
      done
      _testing.message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES
      builtin echo
    } >&2 # KCOV_EXCLUDE_LINE
    _testing.error \
      "$(_testing.message.get PARAMETRIZE_CONFIGURATION_ERROR)" \
      "$(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): ${validate_scenario_indirect_array[0]}" \
      "$(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ${validate_env_var_indirect_array[*]} = ${#validate_env_var_indirect_array[@]} variables" \
      "$(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): ${validate_scenario_indirect_array[*]:1} = $((${#validate_scenario_indirect_array[@]} - 1)) values" \
      "$(_testing.message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): $(builtin printf "'%s' " "${validate_fixture_indirect_command_array[@]}")"
    return 126
  fi
}
