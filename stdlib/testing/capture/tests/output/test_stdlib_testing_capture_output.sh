#!/bin/bash

test_stdlib_testing_capture_output__correct_value____________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"

  _capture.output test_mock

  assert_output "test string"
}

test_stdlib_testing_capture_output__correct_value____________combines_stderr() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"
  test_mock.mock.set.stderr "test stderr string"

  _capture.output test_mock

  assert_output "test stderr string"$'\n'"test string"
}

test_stdlib_testing_capture_output__correct_multiline_value__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string1"$'\n'"test string2"$'\n'"test string3"

  _capture.output test_mock

  assert_output "test string1"$'\n'"test string2"$'\n'"test string3"
}

test_stdlib_testing_capture_output__correct_value____________does_not_mask_return_code() {
  _mock.create test_mock
  test_mock.mock.set.stdout "test string"
  test_mock.mock.set.rc 127

  _capture.rc _capture.output test_mock

  assert_output "test string"
  assert_rc "127"
}
