#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_stdlib_testing_assert_output__missing_value____________fails() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  test_mock > /dev/null
  _capture_assertion_failure assert_output "test string"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NULL)" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_output__incorrect_value__________fails() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output test_mock
  _capture_assertion_failure assert_output "wrong string"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"$'\n'" expected [wrong string] but was [test string]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_output__correct_value____________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output test_mock

  assert_output "test string"
}

test_stdlib_testing_assert_output__correct_multiline_value__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string1"$'\n'"test string2"$'\n'"test string3"

  _capture.output test_mock

  assert_output "test string1"$'\n'"test string2"$'\n'"test string3"
}

test_stdlib_testing_assert_output__correct_value____________does_not_mask_return_code() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"
  test_mock.mock.set.rc 127

  _capture.rc _capture.output test_mock

  assert_output "test string"
  assert_rc "127"
}
