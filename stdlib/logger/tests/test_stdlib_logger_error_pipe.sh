#!/bin/bash

setup() {
  _mock.create stdlib.logger.traceback
}

test_stdlib_logger_error__pipe__correct_stderr() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${STDLIB_COLOUR_LIGHT_RED}test string${STDLIB_COLOUR_NC}"
  TEST_INPUT="test string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.logger.error_pipe 2>&1)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
