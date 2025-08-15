#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/parametrize/tests/__fixtures__/configs.sh"
_testing.load "${STDLIB_DIRECTORY}/testing/parametrize/tests/__fixtures__/parametrizers.sh"

_mock.create @parametrize._components.debug.message

TEST_NAME_CAPTURE_FILE=""

setup_suite() {
  TEST_NAME_CAPTURE_FILE="$(mktemp)"
  _mock.create config_1_mocked_fixture_1
  _mock.create config_1_mocked_fixture_2
  _mock.create config_3_mocked_fixture_1
  _mock.create config_3_mocked_fixture_2

  _mock.create invalid_test_function
}

setup() {
  _mock.create test_fn_mock_@vary
  _mock.create invalid_parametrizer
  _mock.create invalid_test_fn
}

teardown_suite() {
  rm -f "${TEST_NAME_CAPTURE_FILE}"
  _mock.delete @parametrize._components.debug.message
}

@parametrize_with_simple_config_one() {
  # $1: the function you wish to parametrize

  _PARAMETRIZE_DEBUG="" @parametrize \
    "${1}" \
    "${SIMPLE_CONFIG_ONE[@]}"
}

@parametrize_with_simple_config_three() {
  # $1: the function you wish to parametrize

  _PARAMETRIZE_DEBUG="" @parametrize \
    "${1}" \
    "${SIMPLE_CONFIG_THREE[@]}"
}

test_parametrize_compose__1st_run_test_variants__@vary________@vary__populate_indexes() {
  echo "${FUNCNAME[2]}|${VAR_1}|${VAR_2}|${VAR_3}|${NEW_VAR_1}|${NEW_VAR_2}|${NEW_VAR_3}" >> "${TEST_NAME_CAPTURE_FILE}"
}

@parametrize.compose \
  test_parametrize_compose__1st_run_test_variants__@vary________@vary__populate_indexes \
  @parametrize_with_simple_config_one \
  @parametrize_with_simple_config_three

test_parametrize_compose__1st_run_test_variants__@vary__returns_expected_status_code() {
  local args=()

  _mock.create _testing.error
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc @parametrize.compose "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_incorrect_args \
  test_parametrize_compose__1st_run_test_variants__@vary__returns_expected_status_code \
  @parametrize.compose

test_parametrize_compose__1st_run_test_variants__@vary__logs_expected_message() {
  local args=()
  local expected_log_messages=()

  _mock.create _testing.error
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_log_messages "|" "${TEST_EXPECTED_ERROR_MESSAGES}"

  @parametrize.compose "${args[@]}" > /dev/null

  _testing.error.mock.assert_calls_are "${expected_log_messages[@]}"
}

@parametrize_with_incorrect_args \
  test_parametrize_compose__1st_run_test_variants__@vary__logs_expected_message \
  @parametrize.compose

# shellcheck disable=SC2034
test_parametrize_compose__post_variant_tests_____correct_test_variants_were_executed() {
  EXPECTED_TEST_NAMES="test_parametrize_compose__1st_run_test_variants__config_1_scenario_1________config_3_scenario_1__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_1________config_3_scenario_2__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_1________config_3_scenario_3__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_2________config_3_scenario_1__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_2________config_3_scenario_2__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_2________config_3_scenario_3__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_3________config_3_scenario_1__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_3________config_3_scenario_2__populate_indexes
test_parametrize_compose__1st_run_test_variants__config_1_scenario_3________config_3_scenario_3__populate_indexes"

  assert_equals "${EXPECTED_TEST_NAMES}" "$(cut -d '|' -f 1 "${TEST_NAME_CAPTURE_FILE}")"
}

# shellcheck disable=SC2034
test_parametrize_compose__post_variant_tests_____correct_environment_variables_were_set() {
  EXPECTED_ENV_VAR_VALUES="config1-scenario1-value1|config1-scenario1-value2|config1-scenario1-value3|config3-scenario1-value1|config3-scenario1-value2|config3-scenario1-value3
config1-scenario1-value1|config1-scenario1-value2|config1-scenario1-value3|config3-scenario2-value1|config3-scenario2-value2|config3-scenario2-value3
config1-scenario1-value1|config1-scenario1-value2|config1-scenario1-value3|config3-scenario3-value1|config3-scenario3-value2|config3-scenario3-value3
config1-scenario2-value1|config1-scenario2-value2|config1-scenario2-value3|config3-scenario1-value1|config3-scenario1-value2|config3-scenario1-value3
config1-scenario2-value1|config1-scenario2-value2|config1-scenario2-value3|config3-scenario2-value1|config3-scenario2-value2|config3-scenario2-value3
config1-scenario2-value1|config1-scenario2-value2|config1-scenario2-value3|config3-scenario3-value1|config3-scenario3-value2|config3-scenario3-value3
config1-scenario3-value1|config1-scenario3-value2|config1-scenario3-value3|config3-scenario1-value1|config3-scenario1-value2|config3-scenario1-value3
config1-scenario3-value1|config1-scenario3-value2|config1-scenario3-value3|config3-scenario2-value1|config3-scenario2-value2|config3-scenario2-value3
config1-scenario3-value1|config1-scenario3-value2|config1-scenario3-value3|config3-scenario3-value1|config3-scenario3-value2|config3-scenario3-value3"

  assert_equals "${EXPECTED_ENV_VAR_VALUES}" "$(cut -d '|' -f 2,3,4,5,6,7 "${TEST_NAME_CAPTURE_FILE}")"
}

# shellcheck disable=SC2034
test_parametrize_compose__post_variant_tests_____correct_fixtures_were_called() {
  config_1_mocked_fixture_1.mock.assert_count_is 9
  config_1_mocked_fixture_2.mock.assert_count_is 9
  config_3_mocked_fixture_1.mock.assert_count_is 9
  config_3_mocked_fixture_2.mock.assert_count_is 9
}

# shellcheck disable=SC2034
test_parametrize_compose__post_variant_tests_____debug_was_not_called() {
  @parametrize._components.debug.message.mock.assert_not_called
}
