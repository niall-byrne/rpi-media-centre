#!/bin/bash

_echo_fn() {
  echo "test message"
}

test_mock_create__binary__without_mock_create___original_implementation_is_called() {
  _capture.stdout ls /dev/null

  assert_output "/dev/null"
}

test_mock_create__binary__with_mock_create______original_implementation_is_bypassed() {
  _mock.create ls

  _capture.stdout ls /dev/null

  assert_null "${TEST_OUTPUT}"
}

test_mock_create__fn______without_mock_create___original_implementation_is_called() {
  _capture.stdout _echo_fn

  assert_output "test message"
}

test_mock_create__fn______with_mock_create______original_implementation_is_bypassed() {
  _mock.create _echo_fn

  _capture.stdout _echo_fn

  assert_null "${TEST_OUTPUT}"
}
