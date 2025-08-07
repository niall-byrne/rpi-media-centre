#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_assert_rc__missing_value____fails() {
  _mock.create test_mock
  test_mock.mock.set.rc "127"

  test_mock
  _capture_assertion_failure assert_rc "0"

  assert_equals \
    " the 'TEST_RC' value is empty, consider using '_capture_rc'" \
    "${TEST_OUTPUT}"
}

test_assert_rc__incorrect_value__fails() {
  _mock.create test_mock
  test_mock.mock.set.rc "127"

  _capture.rc test_mock
  _capture_assertion_failure assert_rc "0"

  assert_equals \
    " the expected status code was not returned"$'\n'" expected [0] but was [127]" \
    "${TEST_OUTPUT}"
}

test_assert_rc__correct_value____succeeds() {
  _mock.create test_mock
  test_mock.mock.set.rc "127"

  _capture.rc test_mock

  assert_rc "127"
}
