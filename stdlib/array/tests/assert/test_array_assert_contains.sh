#!/bin/bash

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")

  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127,,127" \
    "extra_arg_____________returns_status_code_127,ARRAY1|value|extra_arg,127" \
    "array_arg_is_string___returns_status_code_126,NOT_ARRAY|value,126" \
    "value_arg_is_null_____returns_status_code___1,ARRAY1||,1" \
    "value_is_not_present__returns_status_code___1,ARRAY1|beef,1" \
    "value_is_present______returns_status_code___0,ARRAY1|wraps,0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_LOG_MESSAGE" \
    "extra_arg___________,ARRAY1|value|extra_arg,Invalid arguments provided!" \
    "array_arg_is_string_,NOT_ARRAY|value,Invalid arguments provided!" \
    "value_arg_is_null___,ARRAY1||,The value '' is not found in the 'ARRAY1' array!" \
    "value_is_not_present,ARRAY1|beef,The value 'beef' is not found in the 'ARRAY1' array!"
}

test_stdlib_array_assert_contains__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.assert.contains "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_assert_contains__@vary

test_stdlib_array_assert_contains__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_log_messages "|" "${TEST_EXPECTED_LOG_MESSAGE}"

  _capture.rc stdlib.array.assert.contains "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_array_assert_contains__@vary__logs_an_error
