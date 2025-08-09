#!/bin/bash

test_cli_log_info__correct_stdout() {
  TEST_EXPECTED="${THEME_LOGGER_INFO}test string${THEME_NC}"$'\n'
  TEST_INPUT="test string"

  _capture.stdout_raw _cli_log_info "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}
