#!/bin/bash

test_stdlib_logger_notice__pipe__correct_stderr() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${STDLIB_COLOUR_GREY}test string${STDLIB_COLOUR_NC}"
  TEST_INPUT="test string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.logger.notice_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
