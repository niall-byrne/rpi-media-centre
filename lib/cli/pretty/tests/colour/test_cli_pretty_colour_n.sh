#!/bin/bash

test_cli_pretty_colour_n__arg__highlight__correct_output() {
  TEST_EXPECTED="${THEME_HIGHLIGHT}test string${THEME_NC}"
  TEST_INPUT='test string'

  _capture.output_raw _cli_pretty_colour_n "HIGHLIGHT" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_colour_n__pipe__highlight__correct_output() {
  TEST_EXPECTED="${THEME_HIGHLIGHT}test string${THEME_NC}"
  TEST_INPUT="test string"

  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <(echo "${TEST_INPUT}" | _cli_pretty_colour_n_pipe "HIGHLIGHT")

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
