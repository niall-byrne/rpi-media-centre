#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_mock_object__assert_call_n_is__no_calls__assert_call_1__fails() {
  _mock.create test_mock

  _capture_assertion_failure test_mock.mock.assert_call_n_is "1" "called"

  assert_equals \
    "test_mock was called 0 time(s)" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_call_n_is__2_calls___assert_call_1__fails() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "1" "arg1"

  assert_equals \
    "test_mock call 1 was not called as expected"$'\n'" expected [arg1] but was [arg1 arg2]" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_call_n_is__2_calls___assert_call_3__fails() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "3" "arg1 arg2"

  assert_equals \
    "test_mock was called 2 time(s)" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_call_n_is__3_calls___assert_call_2__succeeds() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_call_n_is "2" "arg1 arg2 successful"
}
