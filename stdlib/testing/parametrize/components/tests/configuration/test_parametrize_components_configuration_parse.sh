#!/bin/bash

setup() {
  _mock.create @parametrize._components.validate.scenario

  SIMPLE_SCENARIO=(
    "@fixture fixture_command_1"
    "@fixture fixture_command_2"
    "VAR1,VAR2,VAR3"
    "scenario1,value1-1,value1-2,value1-3"
    "scenario2,value2-1,value2-2,value2-3"
    "scenario3,value3-1,value3-2,value3-3"
  )
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_configuration_parse__simple_scenario__parses_each_environment_variable_correctly() {
  local EXPECTED_PARSED_ENV_VARS=(
    "VAR1"
    "VAR2"
    "VAR3"
  )

  local _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture"
  local _PARAMETRIZE_FIELD_SEPERATOR=","
  local _P_STACK_ENV_VARS=()
  local _P_STACK_SCENARIOS=()
  local _P_PADDING
  local _P_STACK_FIXTURES=()

  @parametrize._components.configuration.parse "${SIMPLE_SCENARIO[@]}"

  assert_array_equals EXPECTED_PARSED_ENV_VARS _P_STACK_ENV_VARS
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_configuration_parse__simple_scenario__parses_each_fixture_correctly() {
  local EXPECTED_PARSED_FIXTURES=(
    " fixture_command_1"
    " fixture_command_2"
  )

  local _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture"
  local _PARAMETRIZE_FIELD_SEPERATOR=","
  local _P_STACK_ENV_VARS=()
  local _P_STACK_SCENARIOS=()
  local _P_PADDING
  local _P_STACK_FIXTURES=()

  @parametrize._components.configuration.parse "${SIMPLE_SCENARIO[@]}"

  assert_array_equals EXPECTED_PARSED_FIXTURES _P_STACK_FIXTURES
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_configuration_parse__simple_scenario__parses_each_scenario_correctly() {
  local ACTUAL_PARSED_SCENARIOS=()
  local EXPECTED_PARSED_SCENARIOS=(
    "scenario1 value1-1 value1-2 value1-3"
    "scenario2 value2-1 value2-2 value2-3"
    "scenario3 value3-1 value3-2 value3-3"
  )
  @parametrize._components.validate.scenario.mock.set.subcommand 'ACTUAL_PARSED_SCENARIOS+=("${_P_STACK_SCENARIOS[*]}")'

  local _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture"
  local _PARAMETRIZE_FIELD_SEPERATOR=","
  local _P_STACK_ENV_VARS=()
  local _P_STACK_SCENARIOS=()
  local _P_PADDING
  local _P_STACK_FIXTURES=()

  @parametrize._components.configuration.parse "${SIMPLE_SCENARIO[@]}"

  assert_array_equals EXPECTED_PARSED_SCENARIOS ACTUAL_PARSED_SCENARIOS
}

# shellcheck disable=SC2034,SC2016
test_parametrize_components_configuration_parse__simple_scenario__sets_the_correct_scenario_name_padding_value() {
  local ACTUAL_PARSED_SCENARIOS=()
  local EXPECTED_PARSED_SCENARIOS=(
    "scenario1 value1-1 value1-2 value1-3"
    "scenario2 value2-1 value2-2 value2-3"
    "scenario3 value3-1 value3-2 value3-3"
  )
  @parametrize._components.validate.scenario.mock.set.subcommand 'ACTUAL_PARSED_SCENARIOS+=("${_P_STACK_SCENARIOS[*]}")'

  local _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture"
  local _PARAMETRIZE_FIELD_SEPERATOR=","
  local _P_STACK_ENV_VARS=()
  local _P_STACK_SCENARIOS=()
  local _P_PADDING
  local _P_STACK_FIXTURES=()

  @parametrize._components.configuration.parse "${SIMPLE_SCENARIO[@]}"

  assert_equals "${_P_PADDING}" "9"
}
