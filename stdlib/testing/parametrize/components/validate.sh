#!/bin/bash

# stdlib testing parametrize validate component

set -eo pipefail

@parametrize._components.validate.fn_name.parametrizer() {
  # $1: the parametrizer function name to validate

  if ! stdlib.fn.query.is_fn "${1}"; then
    _testing.error "The function '${1}' cannot be used in a parametrize series!"
    _testing.error "It does not exist!"
    return 126
  fi

  if ! stdlib.string.query.starts_with "${_PARAMETRIZE_MULTIPLE_PREFIX}" "${1}"; then
    _testing.error "The function '${1}' cannot be used in a parametrize series!"
    _testing.error "It's name must be prefixed with '${_PARAMETRIZE_MULTIPLE_PREFIX}' !"
    return 126
  fi
}

@parametrize._components.validate.fn_name.test() {
  # $1: the test function name to validate

  if ! stdlib.fn.query.is_fn "${1}"; then
    _testing.error "The function '${1}' cannot be parametrized."
    _testing.error "It does not exist!"
    return 126
  fi

  if ! stdlib.string.query.has_substring "${_PARAMETRIZE_VARIANT_TAG}" "${1}" ||
    ! stdlib.string.query.starts_with "test" "${1}"; then
    _testing.error "The function '${1}' cannot be parametrized."
    _testing.error "It's name must start with 'test' and contain a '${_PARAMETRIZE_VARIANT_TAG}' tag, please rename this function!"
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
      echo "== Begin Scenario Values =="
      for ((validation_index = 0; validation_index < "${#validate_env_var_indirect_array[@]}"; validation_index++)); do
        echo "  ${validate_env_var_indirect_array[validation_index]} = ${validate_scenario_indirect_array[validation_index + 1]}"
      done
      echo "== End Scenario Values =="
      #:nocov:
      # bashcov doesn't report this section correctly
    } >&2
    #:nocov:
    _testing.error \
      "Misconfigured parametrize parameters!" \
      "Scenario Name: '${validate_scenario_indirect_array[0]}'" \
      "Variables: '${validate_env_var_indirect_array[*]}' = ${#validate_env_var_indirect_array[@]} variables" \
      "Value Set: '${validate_scenario_indirect_array[*]:1}' = $((${#validate_scenario_indirect_array[@]} - 1)) values" \
      "Fixture Commands: $(printf "'%s' " "${validate_fixture_indirect_command_array[@]}")"
    return 126
  fi
}
