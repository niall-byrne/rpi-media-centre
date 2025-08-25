#!/bin/bash

setup() {
  _mock.create _testing.error
}

_echo_fn() {
  echo "test message"
}

@parametrize_with_invalid_args() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args;;127;ARGUMENTS_INVALID" \
    "extra_arg;mock_function_name|extra_arg;127;ARGUMENTS_INVALID"
}

test_stdlib_testing_mock_create__@vary_____________returns_expected_status_code() {
  local args=()

  TEST_ARGS_DEFINITION="${TEST_ARGS_DEFINITION//'<br>'/$'\n'}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc _mock.create "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_mock_create__@vary_____________returns_expected_status_code

test_stdlib_testing_mock_create__@vary_____________generates_expected_error_logs() {
  local args=()
  local message_args=()

  TEST_ARGS_DEFINITION="${TEST_ARGS_DEFINITION//'<br>'/$'\n'}"
  TEST_EXPECTED_ERROR_CALLS="${TEST_EXPECTED_ERROR_CALLS//'<br>'/$'\n'}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  _mock.create "${args[@]}"

  _testing.error.mock.assert_calls_are \
    "1(_mock.create: $(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_mock_create__@vary_____________generates_expected_error_logs

test_stdlib_testing_mock_create__restricted_name_______returns_status_code_126() {
  _capture.rc _mock.create while

  assert_rc "126"
}

test_stdlib_testing_mock_create__restricted_name_______logs_error_message() {
  _mock.create while

  _testing.error.mock.assert_calls_are \
    "1(_mock.create: $(_testing.message.get MOCK_TARGET_INVALID "while"))"
}

test_stdlib_testing_mock_create__binary__invalid_name__returns_status_code_126() {
  _mock.create stdlib.testing.internal.fn.query.is_valid_name
  stdlib.testing.internal.fn.query.is_valid_name.mock.set.rc 1

  _capture.rc _mock.create ls

  assert_rc "126"
}

test_stdlib_testing_mock_create__binary__invalid_name__logs_error_message() {
  _mock.create _testing.error
  _mock.create stdlib.testing.internal.fn.query.is_valid_name
  stdlib.testing.internal.fn.query.is_valid_name.mock.set.rc 1

  _mock.create ls

  _testing.error.mock.assert_calls_are \
    "1(_mock.create: $(_testing.message.get MOCK_TARGET_INVALID "ls"))"
}

test_stdlib_testing_mock_create__binary__valid_name____without_mock_create___original_implementation_is_called() {
  _capture.stdout ls /dev/null

  assert_output "/dev/null"
}

test_stdlib_testing_mock_create__binary__valid_name____with_mock_create______original_implementation_is_bypassed() {
  _mock.create ls

  _capture.stdout ls /dev/null

  assert_output_null
}

test_stdlib_testing_mock_create__fn______invalid_name__returns_status_code_126() {
  _mock.create stdlib.testing.internal.fn.query.is_valid_name
  stdlib.testing.internal.fn.query.is_valid_name.mock.set.rc 1

  _capture.rc _mock.create _echo_fn

  assert_rc "126"
}

test_stdlib_testing_mock_create__fn______invalid_name__logs_error_message() {
  _mock.create _testing.error
  _mock.create stdlib.testing.internal.fn.query.is_valid_name
  stdlib.testing.internal.fn.query.is_valid_name.mock.set.rc 1

  _mock.create _echo_fn

  _testing.error.mock.assert_calls_are \
    "1(_mock.create: $(_testing.message.get MOCK_TARGET_INVALID "_echo_fn"))"
}

test_stdlib_testing_mock_create__fn______valid_name____without_mock_create___original_implementation_is_called() {
  _capture.stdout _echo_fn

  assert_output "test message"
}

test_stdlib_testing_mock_create__fn______valid_name____with_mock_create______original_implementation_is_bypassed() {
  _mock.create _echo_fn

  _capture.stdout _echo_fn

  assert_output_null
}
