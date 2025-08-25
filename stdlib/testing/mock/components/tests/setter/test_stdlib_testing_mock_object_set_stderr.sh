#!/bin/bash

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
    "no_args___;;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg_;1(expected call)|extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|2"
}

test_stdlib_testing_mock_object_set_stderr__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.set.stderr "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_set_stderr__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_set_stderr__@vary__generates_expected_log_messages() {
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
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.set.stderr)")
  done

  test_mock.mock.set.stderr "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_set_stderr__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_set_stderr__valid_args__@vary__generates_correct_output() {
  _mock.create test_mock
  test_mock.mock.set.stderr "${EXPECTED_STDERR}"
  test_mock.mock.set.stdout "not required"

  { TEST_OUTPUT="$(test_mock 2>&1 >&3 3>&-)"; } 3> /dev/null

  assert_equals "${EXPECTED_STDERR}" "${TEST_OUTPUT}"
}

@parametrize \
  test_stdlib_testing_mock_object_set_stderr__valid_args__@vary__generates_correct_output \
  "EXPECTED_STDERR" \
  "empty_string;;" \
  "string1;string1" \
  "string2;string2"
