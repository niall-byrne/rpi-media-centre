#!/bin/bash

#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;a|extra_arg;127" \
    "empty_string_____returns_status_code_126;|;126" \
    "symbol___________returns_status_code___1;@#!;1" \
    "numeric__________returns_status_code___1;3323;1" \
    "mixed____________returns_status_code___1;Aa@33aaB;1" \
    "lowercase________returns_status_code___0;abcdefghijklmnopqrstuvwxyz;0" \
    "uppercase________returns_status_code___0;ABCDEFGHIJKLMNOPQRSTUVWXYZ;0" \
    "lower_and_upper__returns_status_code___0;abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_LOG_MESSAGE" \
    "no_args________;;Invalid arguments provided!;" \
    "extra_arg______;1|extra_arg;Invalid arguments provided!;" \
    "empty_string___;|;The value '' is not a set alphabetic only string!" \
    "alphanumeric___;aa011;The value 'aa011' is not a set alphabetic only string!" \
    "non_alpha_digit;3;The value '3' is not a set alphabetic only string!"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_alpha__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_alpha "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_alpha__@vary

test_stdlib_string_assert_is_alpha__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_log_messages "|" "${TEST_EXPECTED_LOG_MESSAGE}"

  _capture.rc stdlib.string.assert.is_alpha "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_alpha__@vary__logs_an_error
