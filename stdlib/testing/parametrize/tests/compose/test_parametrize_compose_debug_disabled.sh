#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/parametrize/tests/__fixtures__/configs.sh"

_mock.create @parametrize._components.debug.message

TEST_NAME_CAPTURE_FILE=""

setup_suite() {
  TEST_NAME_CAPTURE_FILE="$(mktemp)"
  _mock.create config_1_mocked_fixture_1
  _mock.create config_1_mocked_fixture_2
  _mock.create config_3_mocked_fixture_1
  _mock.create config_3_mocked_fixture_2
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

test_parametrize_compose__debug_disabled__1st_run_test_variants__@vary__@vary__populate_indexes() {
  echo "${FUNCNAME[2]}|${VAR_1}|${VAR_2}|${VAR_3}|${NEW_VAR_1}|${NEW_VAR_2}|${NEW_VAR_3}" >> "${TEST_NAME_CAPTURE_FILE}"
}

@parametrize.compose \
  test_parametrize_compose__debug_disabled__1st_run_test_variants__@vary__@vary__populate_indexes \
  @parametrize_with_simple_config_one \
  @parametrize_with_simple_config_three

# shellcheck disable=SC2034
test_parametrize_compose__debug_disabled__post_variant_tests_____correct_test_variants_were_executed() {
  EXPECTED_TEST_NAMES="test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_1__config_3_scenario_1__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_1__config_3_scenario_2__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_1__config_3_scenario_3__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_2__config_3_scenario_1__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_2__config_3_scenario_2__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_2__config_3_scenario_3__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_3__config_3_scenario_1__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_3__config_3_scenario_2__populate_indexes
test_parametrize_compose__debug_disabled__1st_run_test_variants__config_1_scenario_3__config_3_scenario_3__populate_indexes"

  assert_equals "${EXPECTED_TEST_NAMES}" "$(cut -d '|' -f 1 "${TEST_NAME_CAPTURE_FILE}")"
}

# shellcheck disable=SC2034
test_parametrize_compose__debug_disabled__post_variant_tests_____correct_environment_variables_were_set() {
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
test_parametrize_compose__debug_disabled__post_variant_tests_____correct_fixtures_were_called() {
  config_1_mocked_fixture_1.mock.assert_count_is 9
  config_1_mocked_fixture_2.mock.assert_count_is 9
  config_3_mocked_fixture_1.mock.assert_count_is 9
  config_3_mocked_fixture_2.mock.assert_count_is 9
}

# shellcheck disable=SC2034
test_parametrize__compose__debug_disabled__post_variant_tests_____debug_was_not_called() {
  @parametrize._components.debug.message.mock.assert_not_called
}
