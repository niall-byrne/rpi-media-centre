#!/bin/bash

test_stdlib_logger_info__pipe__correct_stderr() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${STDLIB_COLOUR_WHITE}test string${STDLIB_COLOUR_NC}"
  TEST_INPUT="test string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.logger.info_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
