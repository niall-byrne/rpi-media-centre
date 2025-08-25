#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "extra_arg___________returns_status_code_127;1|extra_arg;127" \
    "empty_string________returns_status_code_126;|;126" \
    "alphanumeric________returns_status_code___1;aa011;1" \
    "single_digit________returns_status_code___1;7;1" \
    "5_digit_permission__returns_status_code___1;77777;1" \
    "out_of_range_digit__returns_status_code___1;008;1" \
    "negative_value______returns_status_code___1;-777;1" \
    "3_digit_permission__returns_status_code___0;750;0" \
    "4_digit_permission__returns_status_code___0;2750;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args___________;;ARGUMENTS_INVALID" \
    "extra_arg_________;1|extra_arg;ARGUMENTS_INVALID" \
    "empty_string______;|;IS_NOT_OCTAL_PERMISSION||" \
    "alphanumeric______;aa011;IS_NOT_OCTAL_PERMISSION|aa011" \
    "single_digit______;7;IS_NOT_OCTAL_PERMISSION|7" \
    "5_digit_permission;77777;IS_NOT_OCTAL_PERMISSION|77777" \
    "out_of_range_digit;008;IS_NOT_OCTAL_PERMISSION|008" \
    "negative_value____;-777;IS_NOT_OCTAL_PERMISSION|-777"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_octal_permission__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_octal_permission "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_octal_permission__@vary

test_stdlib_string_assert_is_octal_permission__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_octal_permission "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_octal_permission__@vary__logs_an_error
