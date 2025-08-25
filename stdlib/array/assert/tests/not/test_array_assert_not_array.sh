#!/bin/bash

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  NOT_ARRAY="not an array"

  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "extra_arg___________returns_status_code_127;ARRAY1|extra_arg;127" \
    "is_an_array_________returns_status_code___1;ARRAY1;1" \
    "is_a_string_________returns_status_code___0;NOT_ARRAY;0" \
    "is_an_empty_string__returns_status_code___0;'';0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args___________;;ARGUMENTS_INVALID" \
    "extra_arg_________;ARRAY1|extra_arg;ARGUMENTS_INVALID" \
    "is_an_array_______;ARRAY1;IS_ARRAY|ARRAY1"
}

test_stdlib_array_assert_not_array__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.assert.not_array "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_assert_not_array__@vary

test_stdlib_array_assert_not_array__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.array.assert.not_array "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}
@parametrize_with_error_messages \
  test_stdlib_array_assert_not_array__@vary__logs_an_error
