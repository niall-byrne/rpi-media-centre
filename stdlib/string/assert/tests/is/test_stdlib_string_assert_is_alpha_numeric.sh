#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127;;127" \
    "extra_arg__________returns_status_code_127;AA|extra_arg;127" \
    "empty_string_______returns_status_code_126;|;126" \
    "symbols_present____returns_status_code___1;@#!;1" \
    "mixed______________returns_status_code___1;Aa@33aaB;1" \
    "numeric____________returns_status_code___0;0123456789;0" \
    "lowercase__________returns_status_code___0;abcdefghijklmnopqrstuvwxyz;0" \
    "uppercase__________returns_status_code___0;ABCDEFGHIJKLMNOPQRSTUVWXYZ;0" \
    "lower_and_upper____returns_status_code___0;abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;0" \
    "alpha_numeric_mix__returns_status_code___0;0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;0"
}
@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args__________;;ARGUMENTS_INVALID" \
    "extra_arg________;1|extra_arg;ARGUMENTS_INVALID" \
    "empty_string_____;|;IS_NOT_ALPHA_NUMERIC||" \
    "symbols_present__;*&^aabb001;IS_NOT_ALPHA_NUMERIC|*&^aabb001"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_alpha_numeric__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_alpha_numeric "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_alpha_numeric__@vary

test_stdlib_string_assert_is_alpha_numeric__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_alpha_numeric "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_alpha_numeric__@vary__logs_an_error
