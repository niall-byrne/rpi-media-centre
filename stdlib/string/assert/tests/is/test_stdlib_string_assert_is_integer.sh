#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________returns_status_code_127;;127" \
    "extra_arg_________returns_status_code_127;0|extra_arg;127" \
    "empty_string______returns_status_code_126;|;126" \
    "symbols___________returns_status_code___1;@!#;1" \
    "alphanumeric______returns_status_code___1;3a2;1" \
    "positive_integer__returns_status_code___0;3;0" \
    "negative_integer__returns_status_code___0;-3;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_________;;ARGUMENTS_INVALID" \
    "extra_arg_______;1|extra_arg;ARGUMENTS_INVALID" \
    "empty_string____;|;IS_NOT_INTEGER||" \
    "alpha___________;aa;IS_NOT_INTEGER|aa" \
    "alphanumeric____;aa011;IS_NOT_INTEGER|aa011"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_integer__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_integer "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_integer__@vary

test_stdlib_string_assert_is_integer__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_integer "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_integer__@vary__logs_an_error
