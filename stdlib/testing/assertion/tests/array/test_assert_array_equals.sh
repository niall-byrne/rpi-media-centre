#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  ARRAY2=("running" "biking" "guitar")
}

test_assert_array_equals__first_arg_is_string__fails() {
  _capture_assertion_failure assert_array_equals ARRAY1 "just a string"

  assert_equals \
    " 'just a string' is NOT an array" \
    "${TEST_OUTPUT}"
}

test_assert_array_equals__second_arg_is_string__fails() {
  _capture_assertion_failure assert_array_equals "just a string" ARRAY2

  assert_equals \
    " 'just a string' is NOT an array" \
    "${TEST_OUTPUT}"
}

test_assert_array_equals__one_arg_given__fails() {
  _capture_assertion_failure assert_array_equals ARRAY1

  assert_equals \
    " 'assert_array_equals' was not given sufficient arguments" \
    "${TEST_OUTPUT}"
}

test_assert_array_equals__one_array_is_larger__fails() {
  ARRAY2+=("cooking")

  _capture_assertion_failure assert_array_equals ARRAY1 ARRAY2

  assert_equals \
    " the array 'ARRAY1' has length '3', the array 'ARRAY2' has length '4'
 expected [3] but was [4]" \
    "${TEST_OUTPUT}"
}

test_assert_array_equals__one_array_is_smaller__fails() {
  # shellcheck disable=SC2184
  unset ARRAY1[1]

  _capture_assertion_failure assert_array_equals ARRAY1 ARRAY2

  assert_equals \
    " the array 'ARRAY1' has length '2', the array 'ARRAY2' has length '3'
 expected [2] but was [3]" \
    "${TEST_OUTPUT}"
}

test_assert_array_equals__arrays_are_different_by_first_element__fails() {
  local copied_array

  copied_array=("${ARRAY1[@]}")
  # shellcheck disable=SC2034
  copied_array[0]="programming"

  _capture_assertion_failure assert_array_equals ARRAY1 copied_array

  assert_equals \
    " at index '0' the array 'ARRAY1' has element 'sandwiches', array 'copied_array' has element 'programming'
 expected [sandwiches] but was [programming]" \
    "${TEST_OUTPUT}"
}

test_assert_array_equals__arrays_are_different_by_last_element__fails() {
  local copied_array

  copied_array=("${ARRAY1[@]}")
  # shellcheck disable=SC2034
  copied_array[2]="drinking coffee"

  _capture_assertion_failure assert_array_equals ARRAY1 copied_array

  assert_equals \
    " at index '2' the array 'ARRAY1' has element 'wraps', array 'copied_array' has element 'drinking coffee'
 expected [wraps] but was [drinking coffee]" \
    "${TEST_OUTPUT}"
}

test_assert_array_equals__arrays_are_the_same__succeeds() {
  local copied_array

  # shellcheck disable=SC2034
  copied_array=("${ARRAY1[@]}")

  assert_array_equals ARRAY1 copied_array
}
