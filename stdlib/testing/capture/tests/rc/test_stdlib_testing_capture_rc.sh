#!/bin/bash

mock_function_rc_0() {
  return 0
}

mock_function_rc_127() {
  return 127
}

test_stdlib_testing_capture_rc__correct_rc____@vary__succeeds() {
  _capture.rc "${TEST_FUNCTION}"

  assert_rc "${EXPECTED_RC}"
}

@parametrize \
  test_stdlib_testing_capture_rc__correct_rc____@vary__succeeds \
  "TEST_FUNCTION;EXPECTED_RC" \
  "return_code_0__;mock_function_rc_0;0" \
  "return_code_127;mock_function_rc_127;127"
