#!/bin/bash

_echo_fn() {
  echo "test message"
}

setup() {
  _mock.create _echo_fn
  _mock.create ls
}

test_mock_delete__mocked_binary__without_mock_delete__original_implementation_is_bypassed() {
  _capture.stdout ls /dev/null

  assert_null "${TEST_OUTPUT}"
}

test_mock_delete__mocked_binary__with_mock_delete_____original_implementation_is_restored() {
  _mock.delete ls

  _capture.stdout ls /dev/null

  assert_output "/dev/null"
}

test_mock_delete__mocked_fn______without_mock_delete__original_implementation_is_bypassed() {
  _capture.stdout _echo_fn

  assert_null "${TEST_OUTPUT}"
}

test_mock_delete__mocked_fn______with_mock_delete_____original_implementation_is_restored() {
  _mock.delete _echo_fn

  _capture.stdout _echo_fn

  assert_output "test message"
}
