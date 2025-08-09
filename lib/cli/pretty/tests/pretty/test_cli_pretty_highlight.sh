#!/bin/bash

test_cli_pretty_highlight__arg__correct_output() {
  TEST_EXPECTED="${THEME_HIGHLIGHT}string${THEME_NC}"
  TEST_INPUT="string"

  _capture.output _cli_pretty_highlight "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_highlight__pipe__correct_output() {
  TEST_EXPECTED="${THEME_HIGHLIGHT}string${THEME_NC}"
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_highlight)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
