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
    "no_args_____;;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg___;1|extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|2" \
    "invalid_arg_;not_digit;126;ARGUMENTS_INVALID" \
    "arg_too_high;256;126;IS_NOT_INTEGER_IN_RANGE|0|255|256" \
    "arg_too_low_;-1;126;IS_NOT_INTEGER_IN_RANGE|0|255|-1"
}

test_stdlib_testing_mock_object_set_rc__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.set.rc "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_set_rc__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_set_rc__@vary__generates_expected_log_messages() {
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
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.set.rc)")
  done

  test_mock.mock.set.rc "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_set_rc__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_set_rc__valid_args____@vary__returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.rc "${EXPECTED_RC}"

  _capture.rc test_mock

  assert_equals "${EXPECTED_RC}" "${TEST_RC}"
}

@parametrize \
  test_stdlib_testing_mock_object_set_rc__valid_args____@vary__returns_correct_value \
  "EXPECTED_RC" \
  "with_rc_9;9" \
  "with_rc_0;0"
