#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/testing/tests/assertions/capture.sh"

test_mock_object__assert_any_call__no_calls_____value_absent__fails() {
  _mock.create test_mock

  _capture_assertion_failure test_mock.mock.assert_any_call_is "called"

  assert_equals \
    "test_mock was not called once with 'called'
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_any_call_is__2_calls___value_absent__fails() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_any_call_is "arg1"

  assert_equals \
    "test_mock was not called once with 'arg1'
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_any_call_is__3_calls___value_present__succeeds() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_any_call_is "arg1 arg2 successful"
}

test_mock_object__assert_any_call_is__3_calls___value_repeated__succeeds() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_any_call_is "arg1 arg2"
}
