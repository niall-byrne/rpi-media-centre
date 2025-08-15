#!/bin/bash

# shellcheck disable=SC2034
setup() {
  not_fn_string="not a function"
  not_fn_array=()

  _mock.create stdlib.logger.error
}

_test_fn() {
  echo "test"
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127,,127" \
    "arg_is_null______returns_status_code_126,|,126" \
    "extra_arg________returns_status_code_127,_test_fn|extra_arg,127" \
    "arg_is_string____returns_status_code___1,not_fn_string,1" \
    "arg_is_array_____returns_status_code___1,not_fn_array,1" \
    "arg_is_function__returns_status_code___0,_test_fn,0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_LOG_MESSAGE" \
    "arg_is_null____,|,The function '' doesn't exist!" \
    "arg_is_string__,not_fn_string,The function 'not_fn_string' doesn't exist!" \
    "arg_is_array___,not_fn_array,The function 'not_fn_array' doesn't exist!"
}

test_stdlib_fn_assert_is_fn__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.assert.is_fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_assert_is_fn__@vary

test_stdlib_fn_assert_is_fn__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_log_messages "|" "${TEST_EXPECTED_LOG_MESSAGE}"

  _capture.rc stdlib.fn.assert.is_fn "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_fn_assert_is_fn__@vary__logs_an_error
