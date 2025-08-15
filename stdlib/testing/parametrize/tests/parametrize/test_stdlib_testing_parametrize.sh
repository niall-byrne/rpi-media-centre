#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/parametrize/tests/__fixtures__/configs.sh"

_mock.create @parametrize._components.debug.message

TEST_NAME_CAPTURE_FILE=""

setup_suite() {
  TEST_NAME_CAPTURE_FILE="$(mktemp)"
  _mock.create config_1_mocked_fixture_1
  _mock.create config_1_mocked_fixture_2
  _mock.create invalid_test_fn
}

setup() {
  _mock.create _testing.error
  _mock.create test_function_mock_@vary
}

teardown_suite() {
  rm -f "${TEST_NAME_CAPTURE_FILE}"
  _mock.delete @parametrize._components.debug.message
}

test_parametrize__1st_run_test_variants__valid_config__________@vary__populate_indexes() {
  echo "${FUNCNAME[1]}|${VAR_1}|${VAR_2}|${VAR_3}" >> "${TEST_NAME_CAPTURE_FILE}"
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
    "@parametrize: invalid arguments provided!"
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
    "Misconfigured parametrize parameters! Scenario Name: 'config_3_scenario_1' Variables: 'VAR_1 VAR_2 VAR_3' = 3 variables Value Set: 'config3-scenario1-value2 config3-scenario1-value3' = 2 values Fixture Commands: 'config_3_mocked_fixture_1' 'config_3_mocked_fixture_2' "
}

test_parametrize__1st_run_test_variants__invalid_config________generates_correct_stderr() {
  PARAMETRIZE_DEBUG="" _capture.stderr @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_ONE[@]}"

  assert_output "== Begin Scenario Values =="$'\n'"  VAR_1 = config3-scenario1-value2"$'\n'"  VAR_2 = config3-scenario1-value3"$'\n'"  VAR_3 = "$'\n'"== End Scenario Values =="
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
    "The function 'invalid_test_fn' cannot be parametrized." \
    "It's name must start with 'test' and contain a '@vary' tag, please rename this function!"
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
    "The function 'test_non_existent_@vary' cannot be parametrized." \
    "It does not exist!"
}

test_parametrize__1st_run_test_variants__duplicate_variant_____generates_correct_stderr() {
  PARAMETRIZE_DEBUG="" _capture.stderr @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_TWO[@]}"

  assert_output "Test Name: '${STDLIB_COLOUR_LIGHT_BLUE}test_function_mock_@vary${STDLIB_COLOUR_NC}'
Variant name: '${STDLIB_COLOUR_LIGHT_BLUE}test_function_mock_duplicate_scenario_1${STDLIB_COLOUR_NC}'"
}

test_parametrize__1st_run_test_variants__duplicate_variant_____logs_correct_error_message() {
  PARAMETRIZE_DEBUG="" @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_TWO[@]}" 2> /dev/null

  _testing.error.mock.assert_calls_are \
    "Duplicate test variant name!" \
    "This test variant was created twice, please check your parametrize configuration for this test."
}

test_parametrize__1st_run_test_variants__duplicate_variant_____returns_status_code_126() {
  PARAMETRIZE_DEBUG="" _capture.rc @parametrize \
    test_function_mock_@vary \
    "${INVALID_CONFIG_TWO[@]}" 2> /dev/null

  assert_rc "126"
}

# shellcheck disable=SC2034
test_parametrize__post_variant_tests_____valid_config__________correct_test_variants_were_executed() {
  EXPECTED_TEST_NAMES="test_parametrize__1st_run_test_variants__valid_config__________config_1_scenario_1__populate_indexes
test_parametrize__1st_run_test_variants__valid_config__________config_1_scenario_2__populate_indexes
test_parametrize__1st_run_test_variants__valid_config__________config_1_scenario_3__populate_indexes"

  assert_equals "${EXPECTED_TEST_NAMES}" "$(cut -d '|' -f 1 "${TEST_NAME_CAPTURE_FILE}")"
}

# shellcheck disable=SC2034
test_parametrize__post_variant_tests_____valid_config__________correct_environment_variables_were_set() {
  EXPECTED_ENV_VAR_VALUES="config1-scenario1-value1|config1-scenario1-value2|config1-scenario1-value3
config1-scenario2-value1|config1-scenario2-value2|config1-scenario2-value3
config1-scenario3-value1|config1-scenario3-value2|config1-scenario3-value3"

  assert_equals "${EXPECTED_ENV_VAR_VALUES}" "$(cut -d '|' -f 2,3,4 "${TEST_NAME_CAPTURE_FILE}")"
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
