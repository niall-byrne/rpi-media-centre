#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

# shellcheck disable=SC2034
setup() {
  not_fn_string="not a function"
  not_fn_array=()
}

_test_fn() {
  echo "test"
}

@parametrize_with_assertion_failures() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "no_args________;;" \
    "arg_is_null____;|" \
    "extra_arg______;_test_fn|extra_arg" \
    "arg_is_string__;not_fn_string" \
    "arg_is_array___;not_fn_array"
}

@parametrize_with_assertion_successes() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "arg_is_function;_test_fn"
}

test_stdlib_testing_assert_is_fn__@vary__assertion_fails() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture_assertion_failure assert_is_fn "${args[@]}"

  assert_not_null "${TEST_OUTPUT}"
}

@parametrize_with_assertion_failures \
  test_stdlib_testing_assert_is_fn__@vary__assertion_fails

test_stdlib_testing_assert_is_fn__on_any_failure___captures_emitted_output() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.stderr "stderr logging message"
  stdlib.testing.internal.logger.error.mock.set.stdout "stdout logging message"

  _capture_assertion_failure assert_is_fn "arg1"

  assert_output " stderr logging message
 stdout logging message"
}

test_stdlib_testing_assert_is_fn__@vary__assertion_succeeds() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.output assert_is_fn "${args[@]}"

  assert_output_null
}

@parametrize_with_assertion_successes \
  test_stdlib_testing_assert_is_fn__@vary__assertion_succeeds
