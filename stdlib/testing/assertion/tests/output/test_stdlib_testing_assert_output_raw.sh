#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_stdlib_testing_assert_output_raw_____missing_value____________fails() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  test_mock > /dev/null
  _capture_assertion_failure assert_output_raw "test string"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NULL)" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_output_raw_____incorrect_value__________fails() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output_raw test_mock
  _capture_assertion_failure assert_output_raw "wrong string"

  assert_equals \
    " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"$'\n'" expected [wrong string] but was [test string"$'\n'"]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_output_raw_____correct_value____________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output_raw test_mock

  assert_output_raw "test string"$'\n'
}

test_stdlib_testing_assert_output_raw_____correct_multiline_value__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string1"$'\n'"test string2"$'\n'"test string3"

  _capture.output_raw test_mock

  assert_output_raw "test string1"$'\n'"test string2"$'\n'"test string3"$'\n'
}

test_stdlib_testing_assert_output_raw_____correct_value____________does_not_mask_return_code() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"
  test_mock.mock.set.rc 127

  _capture.rc _capture.output_raw test_mock

  assert_output_raw "test string"$'\n'
  assert_rc "127"
}
