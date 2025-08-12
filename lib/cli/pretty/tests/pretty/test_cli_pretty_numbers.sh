#!/bin/bash

test_cli_pretty_numbers__arg__correct_output() {
  TEST_EXPECTED="string ${THEME_ENTITY}1${THEME_NC} string ${THEME_ENTITY}2${THEME_NC} string ${THEME_ENTITY}999${THEME_NC}"
  TEST_INPUT="string 1 string 2 string 999"

  _capture_output _cli_pretty_numbers "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_numbers__pipe__correct_output() {
  TEST_EXPECTED="string ${THEME_ENTITY}1${THEME_NC} string ${THEME_ENTITY}2${THEME_NC} string ${THEME_ENTITY}999${THEME_NC}"
  TEST_INPUT="string 1 string 2 string 999"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_numbers)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
