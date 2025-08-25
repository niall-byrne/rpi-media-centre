#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/parametrize/tests/__fixtures__/configs.sh"

_mock.create @parametrize._components.debug.message

setup_suite() {
  _mock.create config_1_mocked_fixture_1
  _mock.create config_1_mocked_fixture_2
  _mock.create invalid_test_fn

  _mock.create environment_variable_receiver
  _mock.create scenario_name_receiver
  _mock.create function_name_receiver
}

setup() {
  _mock.create _testing.error
  _mock.create test_function_mock_@vary
}

teardown_suite() {
  _mock.delete @parametrize._components.debug.message
}

test_parametrize__1st_run_test_variants__valid_config__________@vary__populate_indexes() {
  function_name_receiver "${FUNCNAME[1]}"
  environment_variable_receiver "${VAR_1}|${VAR_2}|${VAR_3}"
  scenario_name_receiver "${PARAMETRIZE_SCENARIO_NAME}"
}

_PARAMETRIZE_DEBUG="" @parametrize \
  test_parametrize__1st_run_test_variants__valid_config__________@vary__populate_indexes \
  "${SIMPLE_CONFIG_ONE[@]}"

test_parametrize__1st_run_test_variants__invalid_args__________returns_status_code_127() {
  PARAMETRIZE_DEBUG="" _capture.rc @parametrize

  assert_rc "127"
}

test_parametrize__1st_run_test_variants__invalid_args__________logs_correct_error_message() {
  PARAMETRIZE_DEBUG="" _capture.rc @parametrize

  _testing.error.mock.assert_called_once_with \
    "1(@parametrize: $(stdlib.message.get ARGUMENTS_INVALID))"
}

test_parametrize__1st_run_test_variants__invalid_config________returns_status_code_126() {
  PARAMETRIZE_DEBUG="" _capture.rc @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_ONE[@]}" 2> /dev/null

  assert_rc "126"
}

test_parametrize__1st_run_test_variants__invalid_config________logs_correct_error_message() {
  PARAMETRIZE_DEBUG="" @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_ONE[@]}" 2> /dev/null

  _testing.error.mock.assert_called_once_with \
    "1($(_testing.message.get PARAMETRIZE_CONFIGURATION_ERROR)) 2($(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): config_3_scenario_1) 3($(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): VAR_1 VAR_2 VAR_3 = 3 variables) 4($(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): config3-scenario1-value2 config3-scenario1-value3 = 2 values) 5($(_testing.message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): 'config_3_mocked_fixture_1' 'config_3_mocked_fixture_2' )"
}

test_parametrize__1st_run_test_variants__invalid_config________generates_correct_stderr() {
  PARAMETRIZE_DEBUG="" _capture.stderr @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_ONE[@]}"

  assert_output $"$(_testing.message.get PARAMETRIZE_HEADER_SCENARIO_VALUES)
  VAR_1 = config3-scenario1-value2
  VAR_2 = config3-scenario1-value3
  VAR_3 = "$'\n'"$(_testing.message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES)"
}

test_parametrize__1st_run_test_variants__invalid_test_fn_______returns_status_code_126() {
  PARAMETRIZE_DEBUG="" _capture.rc @parametrize \
    invalid_test_fn \
    "${SIMPLE_CONFIG_ONE[@]}" 2> /dev/null

  assert_rc "126"
}

test_parametrize__1st_run_test_variants__invalid_test_fn_______logs_correct_error_message() {
  PARAMETRIZE_DEBUG="" @parametrize \
    invalid_test_fn \
    "${SIMPLE_CONFIG_ONE[@]}" 2> /dev/null

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "invalid_test_fn"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_NAME))"
}

test_parametrize__1st_run_test_variants__non_existent_test_fn__returns_status_code_126() {
  PARAMETRIZE_DEBUG="" _capture.rc @parametrize \
    test_non_existent_@vary \
    "${SIMPLE_CONFIG_ONE[@]}" 2> /dev/null

  assert_rc "126"
}

test_parametrize__1st_run_test_variants__non_existent_test_fn__logs_correct_error_message() {
  PARAMETRIZE_DEBUG="" @parametrize \
    test_non_existent_@vary \
    "${SIMPLE_CONFIG_ONE[@]}" 2> /dev/null

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "test_non_existent_@vary"))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST))"
}

test_parametrize__1st_run_test_variants__duplicate_variant_____generates_correct_stderr() {
  PARAMETRIZE_DEBUG="" _capture.stderr @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_TWO[@]}"

  assert_output "$(_testing.message.get PARAMETRIZE_PREFIX_TEST_NAME): '$(stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" "test_function_mock_@vary")'
$(_testing.message.get PARAMETRIZE_PREFIX_VARIANT_NAME): '$(stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" "test_function_mock_duplicate_scenario_1")'"
}

test_parametrize__1st_run_test_variants__duplicate_variant_____logs_correct_error_message() {
  PARAMETRIZE_DEBUG="" @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_TWO[@]}" 2> /dev/null

  _testing.error.mock.assert_calls_are \
    "1($(_testing.message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME))" \
    "1($(_testing.message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL))"
}

test_parametrize__1st_run_test_variants__duplicate_variant_____returns_status_code_126() {
  PARAMETRIZE_DEBUG="" _capture.rc @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_TWO[@]}" 2> /dev/null

  assert_rc "126"
}

# shellcheck disable=SC2034
test_parametrize__post_variant_tests_____valid_config__________correct_test_variants_were_executed() {
  function_name_receiver.mock.assert_calls_are \
    "1(test_parametrize__1st_run_test_variants__valid_config__________config_1_scenario_1__populate_indexes)" \
    "1(test_parametrize__1st_run_test_variants__valid_config__________config_1_scenario_2__populate_indexes)" \
    "1(test_parametrize__1st_run_test_variants__valid_config__________config_1_scenario_3__populate_indexes)"
}

# shellcheck disable=SC2034
test_parametrize__post_variant_tests_____valid_config__________scenario_names_were_propagated_to_test() {
  scenario_name_receiver.mock.assert_calls_are \
    "1(config_1_scenario_1)" \
    "1(config_1_scenario_2)" \
    "1(config_1_scenario_3)"
}

# shellcheck disable=SC2034
test_parametrize__post_variant_tests_____valid_config__________correct_environment_variables_were_set() {
  environment_variable_receiver.mock.assert_calls_are \
    "1(config1-scenario1-value1|config1-scenario1-value2|config1-scenario1-value3)" \
    "1(config1-scenario2-value1|config1-scenario2-value2|config1-scenario2-value3)" \
    "1(config1-scenario3-value1|config1-scenario3-value2|config1-scenario3-value3)"
}

# shellcheck disable=SC2034
test_parametrize__post_variant_tests_____valid_config__________correct_fixtures_were_called() {
  config_1_mocked_fixture_1.mock.assert_count_is 3
  config_1_mocked_fixture_2.mock.assert_count_is 3
}

# shellcheck disable=SC2034
test_parametrize__post_variant_tests_____valid_config__________debug_was_not_called() {
  @parametrize._components.debug.message.mock.assert_not_called
}
