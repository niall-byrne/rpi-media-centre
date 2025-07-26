#!/bin/bash

test_capture_stderr__correct_string___________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string"

  _capture_stderr test_mock

  assert_output "test string"
}

test_capture_stderr__correct_string___________ignores_stdout() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string"
  test_mock.mock.set.stdout "unwanted output"

  _capture_stderr test_mock

  assert_output "test string"
}

test_capture_stderr__correct_multiline_value__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string1"$'\n'"test string2"$'\n'"test string3"

  _capture_stderr test_mock

  assert_output "test string1"$'\n'"test string2"$'\n'"test string3"
}

test_capture_stderr__correct_string___________does_not_mask_return_code() {
  _mock.create test_mock
  test_mock.mock.set.stderr "test string"
  test_mock.mock.set.rc 127

  _capture_rc _capture_stderr test_mock

  assert_output "test string"
  assert_rc "127"
}
