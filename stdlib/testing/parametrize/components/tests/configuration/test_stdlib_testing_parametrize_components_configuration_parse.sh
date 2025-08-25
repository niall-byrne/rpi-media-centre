#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create @parametrize._components.validate.scenario

  test_configuration=(
    "@fixture fixture_command_1"
    "@fixture fixture_command_2"
    "VAR1,VAR2,VAR3"
    "scenario1,value1-1,value1-2,value1-3"
    "scenario2,value2-1,value2-2,value2-3"
    "scenario3,value3-1,value3-2,value3-3"
  )
  test_configuration_without_fixtures=(
    "VAR1,VAR2,VAR3"
    "scenario1,value1-1,value1-2,value1-3"
    "scenario2,value2-1,value2-2,value2-3"
    "scenario3,value3-1,value3-2,value3-3"
  )

  environment_variables=()
  fixture_commands=()
  scenario_start_index=0
  padding_value=0
}

test_parametrize_components_configuration_parse__simple_scenario__sets_environment_variable_array_correctly() {
  local expected_parsed_env_vars=(
    "VAR1"
    "VAR2"
    "VAR3"
  )
  _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture" \
    _PARAMETRIZE_FIELD_SEPARATOR="," \
    @parametrize._components.configuration.parse \
    test_configuration \
    scenario_start_index \
    environment_variables \
    fixture_commands \
    padding_value

  assert_array_equals expected_parsed_env_vars environment_variables
}

test_parametrize_components_configuration_parse__simple_scenario__sets_fixture_array_correctly() {
  local expected_parsed_fixtures=(
    " fixture_command_1"
    " fixture_command_2"
  )

  _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture" \
    _PARAMETRIZE_FIELD_SEPARATOR="," \
    @parametrize._components.configuration.parse \
    test_configuration \
    scenario_start_index \
    environment_variables \
    fixture_commands \
    padding_value

  assert_array_equals expected_parsed_fixtures fixture_commands
}

test_parametrize_components_configuration_parse__simple_scenario__sets_empty_fixture_array_correctly() {
  local expected_parsed_fixtures=()

  _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture" \
    _PARAMETRIZE_FIELD_SEPARATOR="," \
    @parametrize._components.configuration.parse \
    test_configuration_without_fixtures \
    scenario_start_index \
    environment_variables \
    fixture_commands \
    padding_value

  assert_array_equals expected_parsed_fixtures fixture_commands
}

test_parametrize_components_configuration_parse__simple_scenario__validates_each_scenario_correctly() {
  _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture" \
    _PARAMETRIZE_FIELD_SEPARATOR="," \
    @parametrize._components.configuration.parse \
    test_configuration \
    scenario_start_index \
    environment_variables \
    fixture_commands \
    padding_value

  @parametrize._components.validate.scenario.mock.assert_calls_are \
    "1(environment_variables) 2(parse_fixture_commands_array) 3(parse_scenario_array)" \
    "1(environment_variables) 2(parse_fixture_commands_array) 3(parse_scenario_array)" \
    "1(environment_variables) 2(parse_fixture_commands_array) 3(parse_scenario_array)"
}

test_parametrize_components_configuration_parse__simple_scenario__parses_each_scenario_correctly() {
  local actual_parsed_scenarios=()
  local expected_parsed_scenarios=(
    "scenario1 value1-1 value1-2 value1-3"
    "scenario2 value2-1 value2-2 value2-3"
    "scenario3 value3-1 value3-2 value3-3"
  )
  # shellcheck disable=SC2016
  @parametrize._components.validate.scenario.mock.set.subcommand 'actual_parsed_scenarios+=("${parse_scenario_array[*]}")'

  _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture" \
    _PARAMETRIZE_FIELD_SEPARATOR="," \
    @parametrize._components.configuration.parse \
    test_configuration \
    scenario_start_index \
    environment_variables \
    fixture_commands \
    padding_value

  assert_array_equals expected_parsed_scenarios actual_parsed_scenarios
}

test_parametrize_components_configuration_parse__simple_scenario__sets_the_correct_index_for_the_start_of_scenario_configuration() {
  _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture" \
    _PARAMETRIZE_FIELD_SEPARATOR="," \
    @parametrize._components.configuration.parse \
    test_configuration \
    scenario_start_index \
    environment_variables \
    fixture_commands \
    padding_value

  assert_equals "3" "${scenario_start_index}"
}

test_parametrize_components_configuration_parse__simple_scenario__sets_the_correct_scenario_name_padding_value() {
  _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture" \
    _PARAMETRIZE_FIELD_SEPARATOR="," \
    @parametrize._components.configuration.parse \
    test_configuration \
    scenario_start_index \
    environment_variables \
    fixture_commands \
    padding_value

  assert_equals "9" "${padding_value}"
}
