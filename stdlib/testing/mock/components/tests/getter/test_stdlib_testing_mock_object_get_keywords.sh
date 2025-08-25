#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.keywords "_STDLIB_ARGS_CALLER_FN_NAME"
  keyword1="value1"
  keyword2="value2"
}

@parametrize_with_invalid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_MESSAGE_ARG_DEFINITIONS" \
    "extra_arg_;extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|0|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|1"
}

test_stdlib_testing_mock_object_get_keywords__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.get.keywords "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_get_keywords__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_get_keywords__@vary__generates_expected_log_messages() {
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
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.get.keywords)")
  done

  test_mock.mock.get.keywords "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_get_keywords__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_get_keywords__valid_args__no_keywords_______returns_correct_value() {
  _mock.create test_mock

  assert_null "$(test_mock.mock.get.keywords)"
}

test_stdlib_testing_mock_object_get_keywords__valid_args__single_keyword____returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1"

  assert_equals "keyword1" "$(test_mock.mock.get.keywords)"
}

test_stdlib_testing_mock_object_get_keywords__valid_args__multiple_keyword__returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2" "keyword3"

  assert_equals "keyword1 keyword2 keyword3" "$(test_mock.mock.get.keywords)"
}
