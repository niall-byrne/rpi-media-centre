#!/bin/bash

test_cli_log_warning__correct_stderr() {
  TEST_EXPECTED="${THEME_LOGGER_WARNING}test string${THEME_NC}"$'\n'
  TEST_INPUT="test string"

  _capture_stderr_raw _cli_log_warning "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_log_warning__no_stdout() {
  TEST_EXPECTED=''
  TEST_INPUT="test string"

  _capture_stdout_raw _cli_log_warning "${TEST_INPUT}"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
