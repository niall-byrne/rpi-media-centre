#!/bin/bash

test_cli_pretty_colour_var__arg__highlight__sets_var() {
  TEST_EXPECTED="${THEME_HIGHLIGHT}test string${THEME_NC}"
  TEST_INPUT="test string"

  _cli_pretty_colour_var "HIGHLIGHT" TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
