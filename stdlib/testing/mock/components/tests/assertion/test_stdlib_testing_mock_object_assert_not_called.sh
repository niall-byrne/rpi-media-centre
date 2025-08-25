#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

setup() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.keywords "_STDLIB_ARGS_CALLER_FN_NAME"
}

test_stdlib_testing_mock_object_assert_not_called__with_args_____returns_status_code_127() {
  _mock.create test_mock

  _capture.rc test_mock.mock.assert_not_called extra_arg

  assert_rc "127"
}

test_stdlib_testing_mock_object_assert_not_called__with_args_____generates_expected_log_messages() {
  _mock.create test_mock

  _capture.rc test_mock.mock.assert_not_called extra_arg

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.message.get ARGUMENT_REQUIREMENTS_VIOLATION 0 0)) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.assert_not_called)" \
    "1($(stdlib.message.get ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL 1)) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.assert_not_called)"
}

test_stdlib_testing_mock_object_assert_not_called__no_calls______succeeds() {
  _mock.create test_mock

  test_mock.mock.assert_not_called
}

test_stdlib_testing_mock_object_assert_not_called__called_once___fails() {
  _mock.create test_mock
  test_mock "call1"

  _capture_assertion_failure test_mock.mock.assert_not_called

  assert_equals \
    "$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "test_mock" "1")
 expected [0] but was [1]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_not_called__called_twice__fails() {
  _mock.create test_mock
  test_mock "call1"
  test_mock "call2"

  _capture_assertion_failure test_mock.mock.assert_not_called

  assert_equals \
    "$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "test_mock" "2")
 expected [0] but was [2]" \
    "${TEST_OUTPUT}"
}
