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

test_stdlib_testing_mock_object_get_count__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.get.count "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_get_count__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_get_count__@vary__generates_expected_log_messages() {
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
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.get.count)")
  done

  test_mock.mock.get.count "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_get_count__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_get_count__valid_args__not_called___________________returns_correct_value() {
  _mock.create test_mock

  assert_equals "0" "$(test_mock.mock.get.count)"
}

test_stdlib_testing_mock_object_get_count__valid_args__called_with_digits___________returns_correct_value() {
  _mock.create test_mock
  test_mock 1 2 3
  test_mock 4 5 6

  assert_equals "2" "$(test_mock.mock.get.count)"
}

test_stdlib_testing_mock_object_get_count__valid_args__called_with_simple_strings___returns_correct_value() {
  _mock.create test_mock
  test_mock "one two three"
  test_mock "four five six"
  test_mock "seven eight nine"

  assert_equals "3" "$(test_mock.mock.get.count)"
}

test_stdlib_testing_mock_object_get_count__valid_args__called_with_complex_strings__returns_correct_value() {
  _mock.create test_mock
  test_mock "one two"$'\n'"three"
  test_mock "four five"$'\n'"six"
  test_mock "seven eight"$'\n'"nine"

  assert_equals "3" "$(test_mock.mock.get.count)"
}
