#!/bin/bash

test_cli_pretty_header__arg__correct_output() {
  TEST_EXPECTED="${THEME_HEADER}string${THEME_NC}"
  TEST_INPUT="string"

  _capture_output _cli_pretty_header "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_header__pipe__correct_output() {
  TEST_EXPECTED="${THEME_HEADER}string${THEME_NC}"
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_header)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
