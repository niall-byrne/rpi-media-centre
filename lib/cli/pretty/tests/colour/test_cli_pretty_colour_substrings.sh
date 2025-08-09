#!/bin/bash

test_cli_pretty_colour_substrings__arg__highlight__correct_output() {
  TEST_EXPECTED="test ${THEME_HIGHLIGHT}string${THEME_NC} ${THEME_HIGHLIGHT}string${THEME_NC}"
  TEST_INPUT="test string string"

  _capture.output _cli_pretty_colour_substrings "HIGHLIGHT" "string" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_colour_substrings__pipe__highlight__correct_output() {
  TEST_EXPECTED="test ${THEME_HIGHLIGHT}string${THEME_NC} ${THEME_HIGHLIGHT}string${THEME_NC}"
  TEST_INPUT="test string string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_colour_substrings_pipe "HIGHLIGHT" "string")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
