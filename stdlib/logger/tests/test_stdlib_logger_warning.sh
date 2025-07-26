#!/bin/bash

test_stdlib_logger_warning__arg__correct_stderr() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${STDLIB_COLOUR_YELLOW}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture_stderr_raw stdlib.logger.warning "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_logger_warning__arg__no_stdout() {
  TEST_EXPECTED=''
  TEST_INPUT="test string"

  _capture_stdout_raw stdlib.logger.warning "${TEST_INPUT}"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
