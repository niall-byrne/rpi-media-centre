#!/bin/bash

test_cli_pretty_colour__arg__highlight__correct_output() {
  TEST_EXPECTED="${THEME_HIGHLIGHT}test string${THEME_NC}"$'\n'
  TEST_INPUT="test string"

  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <(_cli_pretty_colour "HIGHLIGHT" "${TEST_INPUT}")

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}

test_cli_pretty_colour__pipe__highlight__correct_output() {
  TEST_EXPECTED="${THEME_HIGHLIGHT}test string${THEME_NC}"$'\n'
  TEST_INPUT="test string"

  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <(echo "${TEST_INPUT}" | _cli_pretty_colour "HIGHLIGHT")

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
