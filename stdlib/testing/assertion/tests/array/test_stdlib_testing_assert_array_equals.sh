#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  CLONE1=("${ARRAY1[@]}")
  COPIED1=("${ARRAY1[@]}")
  COPIED1[2]="curry"
  SMALLER1=("sandwiches" "pizza")

  ARRAY2=("running" "biking" "guitar")
  LARGER2=("running" "biking" "guitar" "cooking")
  COPIED2=("${ARRAY1[@]}")
  COPIED2[0]="programming"

  NOT_ARRAY="not an array"
}

@parametrize_with_assertion_failures() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "no_args________________;;" \
    "one_arg_only___________;ARRAY1" \
    "extra_arg______________;ARRAY1|ARRAY2|extra_arg" \
    "first_arg_is_string____;NOT_ARRAY|ARRAY1" \
    "second_arg_is_string___;ARRAY1|NOT_ARRAY" \
    "one_array_larger_______;ARRAY2|LARGER2" \
    "one_array_smaller______;ARRAY1|SMALLER1" \
    "first_element_different;ARRAY2|COPIED2" \
    "last_element_different_;ARRAY1|COPIED1"
}

@parametrize_with_assertion_successes() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "arrays_are_equal_______;ARRAY1|CLONE1"
}

test_stdlib_testing_assert_array_equals__@vary__assertion_fails() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture_assertion_failure assert_array_equals "${args[@]}"

  assert_not_null "${TEST_OUTPUT}"
}

@parametrize_with_assertion_failures \
  test_stdlib_testing_assert_array_equals__@vary__assertion_fails

test_stdlib_testing_assert_array_equals__on_any_failure___________captures_emitted_output() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.stderr "stderr logging message"
  stdlib.testing.internal.logger.error.mock.set.stdout "stdout logging message"

  _capture_assertion_failure assert_array_equals "arg1" "arg2"

  assert_output " stderr logging message
 stdout logging message"
}

test_stdlib_testing_assert_array_equals__@vary__assertion_succeeds() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.output assert_array_equals "${args[@]}"

  assert_output_null
}

@parametrize_with_assertion_successes \
  test_stdlib_testing_assert_array_equals__@vary__assertion_succeeds
