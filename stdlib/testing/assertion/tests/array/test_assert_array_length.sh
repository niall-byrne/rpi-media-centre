#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  # shellcheck disable=SC2034
  ARRAY1=("sandwiches" "pizza" "wraps")
}

test_assert_array_length__args_is_a_string__fails() {
  _capture_assertion_failure assert_array_length "3" "just a string"

  assert_equals \
    " 'just a string' is NOT an array" \
    "${TEST_OUTPUT}"
}

test_assert_array_length__first_arg_is_missing__fails() {
  _capture_assertion_failure assert_array_length

  assert_equals \
    " 'assert_array_length' was not given sufficient arguments" \
    "${TEST_OUTPUT}"
}

test_assert_array_length__second_arg_is_missing__fails() {
  _capture_assertion_failure assert_array_length "3"

  assert_equals \
    " 'assert_array_length' was not given sufficient arguments" \
    "${TEST_OUTPUT}"
}

test_assert_array_length__wrong_length_given__fails() {
  _capture_assertion_failure assert_array_length "4" ARRAY1

  assert_equals \
    " expected [4] but was [3]" \
    "${TEST_OUTPUT}"
}

test_assert_array_length__correct_length_given__succeeds() {
  assert_array_length "3" ARRAY1
}
