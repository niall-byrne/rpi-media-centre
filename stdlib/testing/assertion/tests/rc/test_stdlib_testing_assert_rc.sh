#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_stdlib_testing_assert_rc__missing_value____fails() {
  _mock.create test_mock
  test_mock.mock.set.rc "127"

  test_mock
  _capture_assertion_failure assert_rc "0"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_RC_NULL)" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_rc__incorrect_value__fails() {
  _mock.create test_mock
  test_mock.mock.set.rc "127"

  _capture.rc test_mock
  _capture_assertion_failure assert_rc "0"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_RC_NON_MATCHING)"$'\n'" expected [0] but was [127]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_rc__correct_value____succeeds() {
  _mock.create test_mock
  test_mock.mock.set.rc "127"

  _capture.rc test_mock

  assert_rc "127"
}
