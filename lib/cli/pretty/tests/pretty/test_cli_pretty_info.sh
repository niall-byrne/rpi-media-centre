#!/bin/bash

test_cli_pretty_info__arg__correct_output() {
  TEST_EXPECTED="${THEME_INFO}string${THEME_NC}"
  TEST_INPUT="string"

  _capture.output _cli_pretty_info "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_info__pipe__correct_output() {
  TEST_EXPECTED="${THEME_INFO}string${THEME_NC}"
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_info_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
