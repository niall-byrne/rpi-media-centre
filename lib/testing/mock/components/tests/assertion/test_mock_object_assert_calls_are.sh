#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/testing/tests/assertions/capture.sh"

test_mock_object__assert_calls_are__not_called___single_element_array__fais() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\";"
  )

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_equals \
    "test_mock was not called!" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_calls_are__single_arg___single_element_array____matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\";"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_mock_object__assert_calls_are__single_arg___multiple_element_array__matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\";"
    "call 2; call2"$'\n'"call2 call2 \'\";"
    "call 3; call3"$'\n'"call3 call3 \'\";"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_mock_object__assert_calls_are__double_args__multiple_element_array__matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\"; call1arg2"
    "call 2; call2"$'\n'"call2 call2 \'\"; call2arg2"
    "call 3; call3"$'\n'"call3 call3 \'\"; call3arg2"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_mock_object__assert_calls_are__double_args__single_element_array____index_0___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\"; call1arg2 - does not match"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_equals \
    " at index 0 the expected argument string was not found
 expected [$'call 1; call1
call1 call1 \\'\"; call1arg2 - does not match'] but was [$'call 1; call1
call1 call1 \\'\"; call1arg2']" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_calls_are__double_args__multiple_element_array__index_0___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\"; call1arg2 - does not match"
    "call 2; call2"$'\n'"call2 call2 \'\"; call2arg2"
    "call 3; call3"$'\n'"call3 call3 \'\"; call3arg2"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_equals \
    " at index 0 the expected argument string was not found
 expected [$'call 1; call1
call1 call1 \\'\"; call1arg2 - does not match'] but was [$'call 1; call1
call1 call1 \\'\"; call1arg2']" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_calls_are__double_args__multiple_element_array__index_1___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\"; call1arg2"
    "call 2; call2"$'\n'"call2 call2 \'\"; call2arg2 - does not match"
    "call 3; call3"$'\n'"call3 call3 \'\"; call3arg2"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_equals \
    " at index 1 the expected argument string was not found
 expected [$'call 2; call2
call2 call2 \\'\"; call2arg2 - does not match'] but was [$'call 2; call2
call2 call2 \\'\"; call2arg2']" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_calls_are__double_args__multiple_element_array__index_2___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "call 1; call1"$'\n'"call1 call1 \'\"; call1arg2"
    "call 2; call2"$'\n'"call2 call2 \'\"; call2arg2"
    "call 3; call3"$'\n'"call3 call3 \'\"; call3arg2 - does not match"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_equals \
    " at index 2 the expected argument string was not found
 expected [$'call 3; call3
call3 call3 \\'\"; call3arg2 - does not match'] but was [$'call 3; call3
call3 call3 \\'\"; call3arg2']" \
    "${TEST_OUTPUT}"
}
