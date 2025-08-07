#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

test_assert_output__________missing_value____________fails() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  test_mock > /dev/null
  _capture_assertion_failure assert_output "test string"

  assert_equals \
    " the 'TEST_OUTPUT' value is empty, consider using '_capture_output'" \
    "${TEST_OUTPUT}"
}

test_assert_output__normal__incorrect_value__________fails() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output test_mock
  _capture_assertion_failure assert_output "wrong string"

  assert_equals \
    " the expected output string was not generated"$'\n'" expected [wrong string] but was [test string]" \
    "${TEST_OUTPUT}"
}

test_assert_output__raw_____incorrect_value__________fails() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output_raw test_mock
  _capture_assertion_failure assert_output "wrong string"

  assert_equals \
    " the expected output string was not generated"$'\n'" expected [wrong string] but was [test string"$'\n'"]" \
    "${TEST_OUTPUT}"
}

test_assert_output__normal__correct_value____________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output test_mock

  assert_output "test string"
}

test_assert_output__raw_____correct_value____________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output_raw test_mock

  assert_output "test string"$'\n'
}

test_assert_output__normal__correct_multiline_value__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string1"$'\n'"test string2"$'\n'"test string3"

  _capture.output test_mock

  assert_output "test string1"$'\n'"test string2"$'\n'"test string3"
}

test_assert_output__raw_____correct_multiline_value__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string1"$'\n'"test string2"$'\n'"test string3"

  _capture.output_raw test_mock

  assert_output "test string1"$'\n'"test string2"$'\n'"test string3"$'\n'
}

test_assert_output__normal__correct_value____________does_not_mask_return_code() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"
  test_mock.mock.set.rc 127

  _capture.rc _capture.output test_mock

  assert_output "test string"
  assert_rc "127"
}

test_assert_output__raw_____correct_value____________does_not_mask_return_code() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"
  test_mock.mock.set.rc 127

  _capture.rc _capture.output_raw test_mock

  assert_output "test string"$'\n'
  assert_rc "127"
}
