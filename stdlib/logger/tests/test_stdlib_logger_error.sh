#!/bin/bash

setup() {
  _mock.create stdlib.logger.traceback
}

test_stdlib_logger_error__arg__correct_stderr() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${STDLIB_COLOUR_LIGHT_RED}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture_stderr_raw stdlib.logger.error "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_logger_error__arg__creates_traceback() {
  TEST_INPUT="test string"

  _capture_stderr_raw stdlib.logger.error "${TEST_INPUT}"

  stdlib.logger.traceback.mock.assert_called_once_with ""
}

test_stdlib_logger_error__arg__no_stdout() {
  TEST_EXPECTED=''
  TEST_INPUT="test string"

  _capture_stdout_raw stdlib.logger.error "${TEST_INPUT}"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
