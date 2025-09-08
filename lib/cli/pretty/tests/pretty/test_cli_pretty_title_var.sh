#!/bin/bash

test_cli_pretty_title_var__sets_var() {
  TEST_EXPECTED="${THEME_TITLE}string${THEME_NC}"
  TEST_INPUT="string"

  _cli_pretty_title_var TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
