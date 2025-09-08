#!/bin/bash

test_cli_pretty_colour_substrings_var__arg__highlight__sets_var() {
  TEST_EXPECTED="test ${THEME_HIGHLIGHT}string${THEME_NC} ${THEME_HIGHLIGHT}string${THEME_NC}"
  TEST_INPUT="test string string"

  _cli_pretty_colour_substrings_var "HIGHLIGHT" "string" TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
