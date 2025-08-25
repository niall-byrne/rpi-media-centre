#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  NOT_ARRAY="not an array"
  EMPTY_ARRAY=()
}

@parametrize_with_assertion_failures() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "no_args________;;" \
    "extra_arg______;ARRAY1|extra_arg" \
    "arg_is_string__;NOT_ARRAY"
}

@parametrize_with_assertion_successes() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "empty_array____;EMPTY_ARRAY" \
    "populated_array;ARRAY1"
}

test_stdlib_testing_assert_is_array__@vary__assertion_fails() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture_assertion_failure assert_is_array "${args[@]}"

  assert_not_null "${TEST_OUTPUT}"
}

@parametrize_with_assertion_failures \
  test_stdlib_testing_assert_is_array__@vary__assertion_fails

test_stdlib_testing_assert_is_array__on_any_failure___captures_emitted_output() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.stderr "stderr logging message"
  stdlib.testing.internal.logger.error.mock.set.stdout "stdout logging message"

  _capture_assertion_failure assert_is_array "arg1"

  assert_output " stderr logging message
 stdout logging message"
}

test_stdlib_testing_assert_is_array__@vary__assertion_succeeds() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.output assert_is_array "${args[@]}"

  assert_output_null
}

@parametrize_with_assertion_successes \
  test_stdlib_testing_assert_is_array__@vary__assertion_succeeds
