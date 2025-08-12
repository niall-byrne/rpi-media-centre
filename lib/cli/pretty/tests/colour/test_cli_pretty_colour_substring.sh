#!/bin/bash

test_cli_pretty_colour_substring__arg__highlight__correct_output() {
  TEST_EXPECTED="test ${THEME_HIGHLIGHT}string${THEME_NC} string"
  TEST_INPUT="test string string"

  _capture_output _cli_pretty_colour_substring "HIGHLIGHT" "string" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_colour_substring__pipe__highlight__correct_output() {
  TEST_EXPECTED="test ${THEME_HIGHLIGHT}string${THEME_NC} string"
  TEST_INPUT="test string string"

  # shellcheck disable=SC2034
  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_colour_substring "HIGHLIGHT" "string")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
