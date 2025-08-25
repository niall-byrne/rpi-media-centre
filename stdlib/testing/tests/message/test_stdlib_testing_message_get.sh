#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________________returns_status_code_127;;127" \
    "extra_args____________________returns_status_code_127;DEBUG_DIFF_FOOTER|two|three|four|five;127" \
    "invalid_arguments_____________returns_status_code_126;INVALID_KEY;126" \
    "valid_argument________________returns_status_code___0;DEBUG_DIFF_FOOTER;0" \
    "valid_arguments_with_options__returns_status_code___0;DEBUG_DIFF_FOOTER;0"
}

@parametrize_with_message_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "debug_diff_footer;DEBUG_DIFF_FOOTER;== End Debug Diff ==" \
    "debug_diff_header;DEBUG_DIFF_HEADER;== Start Debug Diff ==" \
    "debug_diff_prefix;DEBUG_DIFF_PREFIX;Diff" \
    "debug_diff_prefix_actual;DEBUG_DIFF_PREFIX_ACTUAL;ACTUAL" \
    "debug_diff_prefix_expected;DEBUG_DIFF_PREFIX_EXPECTED;EXPECTED" \
    "load_module_not_found;LOAD_MODULE_NOT_FOUND|module_name;The module 'module_name' could not be found!" \
    "load_module_notification;LOAD_MODULE_NOTIFICATION|module_name;Loading module 'module_name' ..." \
    "mock_target_invalid;MOCK_TARGET_INVALID|target;The object identified by 'target' cannot be mocked!" \
    "parametrize_configuration_error;PARAMETRIZE_CONFIGURATION_ERROR;Misconfigured parametrize parameters!" \
    "parametrize_error_duplicate_test_variant_detail;PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL;This test variant was created twice, please check your parametrize configuration for this test." \
    "parametrize_error_duplicate_test_variant_name;PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME;Duplicate test variant name!" \
    "parametrize_error_fn_does_not_exist;PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST;It does not exist!" \
    "parametrize_error_parametrizer_fn_invalid;PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID|my_func;The function 'my_func' cannot be used in a parametrize series!" \
    "parametrize_error_parametrizer_fn_name___;PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME;It's name must be prefixed with '${_PARAMETRIZE_PARAMETRIZER_PREFIX}' !" \
    "parametrize_error_test_fn_invalid;PARAMETRIZE_ERROR_TEST_FN_INVALID|my_func;The function 'my_func' cannot be parametrized." \
    "parametrize_error_test_fn_name;PARAMETRIZE_ERROR_TEST_FN_NAME;It's name must start with 'test' and contain a '${_PARAMETRIZE_VARIANT_TAG}' tag, please rename this function!" \
    "parametrize_footer_scenario_values;PARAMETRIZE_FOOTER_SCENARIO_VALUES;== End Scenario Values ==" \
    "parametrize_header_scenario;PARAMETRIZE_HEADER_SCENARIO;Parametrize Scenario" \
    "parametrize_header_scenario_values;PARAMETRIZE_HEADER_SCENARIO_VALUES;== Begin Scenario Values ==" \
    "parametrize_prefix_fixture_command;PARAMETRIZE_PREFIX_FIXTURE_COMMAND;Fixture Command" \
    "parametrize_prefix_fixture_commands;PARAMETRIZE_PREFIX_FIXTURE_COMMANDS;Fixture Commands" \
    "parametrize_prefix_scenario_name;PARAMETRIZE_PREFIX_SCENARIO_NAME;Scenario Name" \
    "parametrize_prefix_scenario_values;PARAMETRIZE_PREFIX_SCENARIO_VALUES;Value Set" \
    "parametrize_prefix_scenario_variable;PARAMETRIZE_PREFIX_SCENARIO_VARIABLE;Variables" \
    "parametrize_prefix_test_name;PARAMETRIZE_PREFIX_TEST_NAME;Test Name" \
    "parametrize_prefix_variant_name;PARAMETRIZE_PREFIX_VARIANT_NAME;Variant name"
}

@parametrize_with_incorrect_arg_counts() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "debug_diff_footer________________________________too_many_args;DEBUG_DIFF_FOOTER|1" \
    "debug_diff_header________________________________too_many_args;DEBUG_DIFF_HEADER|1" \
    "debug_diff_prefix________________________________too_many_args;DEBUG_DIFF_PREFIX|1" \
    "debug_diff_prefix_actual_________________________too_many_args;DEBUG_DIFF_PREFIX_ACTUAL|1" \
    "debug_diff_prefix_expected_______________________too_many_args;DEBUG_DIFF_PREFIX_EXPECTED|1" \
    "load_module_not_found____________________________no_args;LOAD_MODULE_NOT_FOUND" \
    "load_module_not_found____________________________too_many_args;LOAD_MODULE_NOT_FOUND|1|2" \
    "load_module_notification_________________________no_args;LOAD_MODULE_NOTIFICATION" \
    "load_module_notification_________________________too_many_args;LOAD_MODULE_NOTIFICATION|1|2" \
    "mock_target_invalid______________________________no_args;MOCK_TARGET_INVALID" \
    "mock_target_invalid______________________________too_many_args;MOCK_TARGET_INVALID|1|2" \
    "parametrize_configuration_error__________________too_many_args;PARAMETRIZE_CONFIGURATION_ERROR|1" \
    "parametrize_error_duplicate_test_variant_detail__too_many_args;PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL|1" \
    "parametrize_error_duplicate_test_variant_name____too_many_args;PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME|1" \
    "parametrize_error_fn_does_not_exist______________too_many_args;PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST|1" \
    "parametrize_error_parametrizer_fn_invalid________no_args;PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID" \
    "parametrize_error_parametrizer_fn_invalid________too_many_args;PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID|1|2" \
    "parametrize_error_parametrizer_fn_name___________too_many_args;PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME|1" \
    "parametrize_error_test_fn_invalid________________no_args;PARAMETRIZE_ERROR_TEST_FN_INVALID" \
    "parametrize_error_test_fn_invalid________________too_many_args;PARAMETRIZE_ERROR_TEST_FN_INVALID|1|2" \
    "parametrize_error_test_fn_name___________________too_many_args;PARAMETRIZE_ERROR_TEST_FN_NAME|1" \
    "parametrize_footer_scenario_values_______________too_many_args;PARAMETRIZE_FOOTER_SCENARIO_VALUES|1" \
    "parametrize_header_scenario______________________too_many_args;PARAMETRIZE_HEADER_SCENARIO|1" \
    "parametrize_header_scenario_values_______________too_many_args;PARAMETRIZE_HEADER_SCENARIO_VALUES|1" \
    "parametrize_fixture_command______________________too_many_args;PARAMETRIZE_PREFIX_FIXTURE_COMMAND|1" \
    "parametrize_prefix_fixture_commands______________too_many_args;PARAMETRIZE_PREFIX_FIXTURE_COMMANDS|1" \
    "parametrize_prefix_scenario_name_________________too_many_args;PARAMETRIZE_PREFIX_SCENARIO_NAME|1" \
    "parametrize_prefix_scenario_values_______________too_many_args;PARAMETRIZE_PREFIX_SCENARIO_VALUES|1" \
    "parametrize_prefix_scenario_variable_____________too_many_args;PARAMETRIZE_PREFIX_SCENARIO_VARIABLE|1" \
    "parametrize_prefix_test_name_____________________too_many_args;PARAMETRIZE_PREFIX_TEST_NAME|1" \
    "parametrize_prefix_variant_name__________________too_many_args;PARAMETRIZE_PREFIX_VARIANT_NAME|1"
}

# shellcheck disable=SC2034
test_stdlib_testing_message_get__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc _testing.message.get "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_testing_message_get__@vary

# shellcheck disable=SC2034
test_stdlib_testing_message_get__valid_argument________________@vary_____returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _testing.message.get "${args[@]}"

  assert_equals "${TEST_EXPECTED_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize_with_message_content \
  test_stdlib_testing_message_get__valid_argument________________@vary_____returns_correct_message

test_stdlib_testing_message_get__invalid_arguments_____________returns_error_message() {
  _capture.stdout _testing.message.get "NON_EXISTENT_KEY"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Unknown message key 'NON_EXISTENT_KEY')"
}

# shellcheck disable=SC2034
test_stdlib_testing_message_get__invalid_arg_count_____________@vary__returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _testing.message.get "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Invalid arguments provided!)"
}

@parametrize_with_incorrect_arg_counts \
  test_stdlib_testing_message_get__invalid_arg_count_____________@vary__returns_correct_message
