#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error
}

_example_fn() {
  :
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________________returns_status_code_127;;127" \
    "extra_arg________________returns_status_code_127;_example_fn|extra_arg;127" \
    "is_a_fn__________________returns_status_code___1;_example_fn;1" \
    "is_not_a_fn______________returns_status_code___0;not_a_fn;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args________________;;ARGUMENTS_INVALID" \
    "extra_arg______________;_example_fn|extra_arg;ARGUMENTS_INVALID" \
    "is_a_fn________________;_example_fn;IS_FN|_example_fn"
}

test_stdlib_fn_assert_not_fn__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.assert.not_fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_assert_not_fn__@vary

test_stdlib_fn_assert_not_fn__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.fn.assert.not_fn "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}
@parametrize_with_error_messages \
  test_stdlib_fn_assert_not_fn__@vary__logs_an_error
