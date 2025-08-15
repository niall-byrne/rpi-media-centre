#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_mock_object__assert_count_is__not_called______assert_1_time___fails() {
  _mock.create test_mock

  _capture_assertion_failure test_mock.mock.assert_count_is "1"

  assert_equals \
    "test_mock was called 0 time(s)"$'\n'" expected [1] but was [0]" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_count_is__called_3_times__assert_2_times__fails() {
  _mock.create test_mock
  test_mock
  test_mock
  test_mock

  _capture_assertion_failure test_mock.mock.assert_count_is "2"

  assert_equals \
    "test_mock was called 3 time(s)"$'\n'" expected [2] but was [3]" \
    "${TEST_OUTPUT}"
}

test_mock_object__assert_count_is__called_1_time___assert_1_time___succeeds() {
  _mock.create test_mock

  test_mock

  test_mock.mock.assert_count_is "1"
}

test_mock_object__assert_count_is__called_3_times__assert_3_times__succeeds() {
  _mock.create test_mock

  test_mock
  test_mock
  test_mock

  test_mock.mock.assert_count_is "3"
}
