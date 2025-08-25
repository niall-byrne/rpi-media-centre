#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  expected_colour="$(stdlib.setting.theme.get_colour "${STDLIB_THEME_LOGGER_ERROR}")"
}

test_stdlib_logger_error_pipe__default_prefix__correct_stderr() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${!expected_colour}test string${STDLIB_COLOUR_NC}"
  TEST_INPUT="test string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.logger.error_pipe 2>&1)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
