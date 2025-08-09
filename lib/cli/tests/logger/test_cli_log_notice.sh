#!/bin/bash

test_cli_log_notice__correct_stdout() {
  TEST_EXPECTED="${THEME_LOGGER_NOTICE}test string${THEME_NC}"$'\n'
  TEST_INPUT="test string"

  _capture_stdout_raw _cli_log_notice "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}
