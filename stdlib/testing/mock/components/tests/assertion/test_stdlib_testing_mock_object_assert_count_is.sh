#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.keywords "_STDLIB_ARGS_CALLER_FN_NAME"
}

@parametrize_with_invalid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_MESSAGE_ARG_DEFINITIONS" \
    "no_args___________;;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg_________;1|extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|2" \
    "index_is_invalid__;a;126;IS_NOT_DIGIT|a" \
    "arg_string_is_null;|;126;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|1"
}

test_stdlib_testing_mock_object_assert_count_is__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.assert_count_is "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_count_is__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_assert_count_is__@vary__generates_expected_log_messages() {
  local args=()
  local expected_log_messages=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_arg_definitions " " "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    stdlib.array.make.from_string message_args "|" "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.assert_count_is)")
  done
  test_mock.mock.assert_count_is "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_count_is__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_assert_count_is__valid_args__________not_called______assert_1_time___fails() {
  _mock.create test_mock

  _capture_assertion_failure test_mock.mock.assert_count_is "1"

  assert_equals \
    "$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "test_mock" "0")
 expected [1] but was [0]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_count_is__valid_args__________called_3_times__assert_2_times__fails() {
  _mock.create test_mock
  test_mock
  test_mock
  test_mock

  _capture_assertion_failure test_mock.mock.assert_count_is "2"

  assert_equals \
    "$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "test_mock" "3")
 expected [2] but was [3]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_count_is__valid_args__________called_1_time___assert_1_time___succeeds() {
  _mock.create test_mock

  test_mock

  test_mock.mock.assert_count_is "1"
}

test_stdlib_testing_mock_object_assert_count_is__valid_args__________called_3_times__assert_3_times__succeeds() {
  _mock.create test_mock

  test_mock
  test_mock
  test_mock

  test_mock.mock.assert_count_is "3"
}
