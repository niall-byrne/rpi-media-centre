#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_mock_object__assert_not_called__no_calls______succeeds() {
  _mock.create test_mock

  test_mock.mock.assert_not_called
}

test_mock_object__assert_not_called__called_once___fails() {
  _mock.create test_mock
  test_mock "call1"

  _capture_assertion_failure test_mock.mock.assert_not_called

  assert_equals \
    "test_mock was called 1 time(s)"$'\n'" expected [0] but was [1]" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_not_called__called_twice__fails() {
  _mock.create test_mock
  test_mock "call1"
  test_mock "call2"

  _capture_assertion_failure test_mock.mock.assert_not_called

  assert_equals \
    "test_mock was called 2 time(s)"$'\n'" expected [0] but was [2]" \
    "${TEST_OUTPUT}"
}
