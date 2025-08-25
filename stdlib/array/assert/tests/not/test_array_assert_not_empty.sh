#!/bin/bash

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  NOT_ARRAY="not an array"
  EMPTY_ARRAY=()

  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;ARRAY1|extra_arg;127" \
    "arg_is_string____returns_status_code_126;NOT_ARRAY;126" \
    "empty_array______returns_status_code___1;EMPTY_ARRAY;1" \
    "populated_array__returns_status_code___0;ARRAY1;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args________;;ARGUMENTS_INVALID" \
    "extra_arg______;ARRAY1|extra_arg;ARGUMENTS_INVALID" \
    "arg_is_string__;NOT_ARRAY;IS_NOT_ARRAY|NOT_ARRAY" \
    "empty_array____;EMPTY_ARRAY;ARRAY_IS_EMPTY|EMPTY_ARRAY"
}

test_stdlib_array_assert_is_not_empty__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.assert.not_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_assert_is_not_empty__@vary

test_stdlib_array_assert_is_not_empty__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.array.assert.not_empty "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_array_assert_is_not_empty__@vary__logs_an_error
