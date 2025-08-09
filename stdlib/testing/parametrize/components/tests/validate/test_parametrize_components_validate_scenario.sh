#!/bin/bash

setup() {
  _mock.create _testing.error
  _testing.error.mock.set.rc 127
}

test_parametrize_components_validate_scenario__not_enough_values__generates_error_message() {
  local _P_STACK_ENV_VARS=("ENV_VAR1" "ENV_VAR2")
  local _P_STACK_SCENARIOS=("scenario_name" "value1")

  _capture.stderr @parametrize._components.validate.scenario

  _testing.error.mock.assert_called_once_with \
    "Misconfigured parametrize parameters! Scenario Name: 'scenario_name' Variables: 'ENV_VAR1 ENV_VAR2' = 2 variables Value Set: 'value1' = 1 values Fixture Commands: '' "
}

test_parametrize_components_validate_scenario__not_enough_values__generates_stderr_messages() {
  local _P_STACK_ENV_VARS=("ENV_VAR1" "ENV_VAR2")
  local _P_STACK_SCENARIOS=("scenario_name" "value1")

  _capture.stderr @parametrize._components.validate.scenario

  assert_output "== Begin Scenario Values =="$'\n'"  ENV_VAR1 = value1"$'\n'"  ENV_VAR2 = "$'\n'"== End Scenario Values =="
}

test_parametrize_components_validate_scenario__too_many_values____generates_error_message() {
  local _P_STACK_ENV_VARS=("ENV_VAR1" "ENV_VAR2")
  local _P_STACK_SCENARIOS=("scenario_name" "value1" "value2" "value3")

  _capture.stderr @parametrize._components.validate.scenario

  _testing.error.mock.assert_called_once_with \
    "Misconfigured parametrize parameters! Scenario Name: 'scenario_name' Variables: 'ENV_VAR1 ENV_VAR2' = 2 variables Value Set: 'value1 value2 value3' = 3 values Fixture Commands: '' "
}

test_parametrize_components_validate_scenario__too_many_values____generates_stderr_messages() {
  local _P_STACK_ENV_VARS=("ENV_VAR1" "ENV_VAR2")
  local _P_STACK_SCENARIOS=("scenario_name" "value1" "value2" "value3")

  _capture.stderr @parametrize._components.validate.scenario

  assert_output "== Begin Scenario Values =="$'\n'"  ENV_VAR1 = value1"$'\n'"  ENV_VAR2 = value2"$'\n'"== End Scenario Values =="
}

test_parametrize_components_validate_scenario__correct_values_____does_not_generate_an_error_message() {
  local _P_STACK_ENV_VARS=("ENV_VAR1" "ENV_VAR2")
  local _P_STACK_SCENARIOS=("scenario_name" "value1" "value2")

  _capture.stderr @parametrize._components.validate.scenario

  _testing.error.mock.assert_not_called
}

test_parametrize_components_validate_scenario__correct_values_____does_not_generate_stderr_messages() {
  local _P_STACK_ENV_VARS=("ENV_VAR1" "ENV_VAR2")
  local _P_STACK_SCENARIOS=("scenario_name" "value1" "value2")

  _capture.stderr @parametrize._components.validate.scenario

  assert_null "${TEST_OUTPUT}"
}
