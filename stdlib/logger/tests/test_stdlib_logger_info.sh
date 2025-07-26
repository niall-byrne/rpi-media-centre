#!/bin/bash

test_stdlib_logger_info__arg__correct_stdout() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${STDLIB_COLOUR_WHITE}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture_stdout_raw stdlib.logger.info "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}
