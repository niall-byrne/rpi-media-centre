#!/bin/bash

test_stdlib_logger_success__arg__correct_stdout() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${STDLIB_COLOUR_GREEN}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture.stdout_raw stdlib.logger.success "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}
