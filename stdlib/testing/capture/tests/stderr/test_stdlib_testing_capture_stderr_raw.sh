#!/bin/bash

test_stdlib_testing_capture_stderr__raw__correct_value____________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string"

  _capture.stderr_raw test_mock

  assert_output "test string"$'\n'
}

test_stdlib_testing_capture_stderr__raw__correct_value____________ignores_stdout() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string"
  test_mock.mock.set.stdout "unwanted output"

  _capture.stderr_raw test_mock

  assert_output "test string"$'\n'
}

test_stdlib_testing_capture_stderr__raw__correct_multiline_value__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string1"$'\n'"test string2"$'\n'"test string3"

  _capture.stderr_raw test_mock

  assert_output "test string1"$'\n'"test string2"$'\n'"test string3"$'\n'
}

test_stdlib_testing_capture_stderr__raw__correct_value____________does_not_mask_return_code() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string"
  test_mock.mock.set.rc 127

  _capture.rc _capture.stderr_raw test_mock

  assert_output "test string"$'\n'
  assert_rc "127"
}
