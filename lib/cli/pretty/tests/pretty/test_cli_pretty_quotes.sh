#!/bin/bash

test_cli_pretty_quotes__arg__single__to_double__correct_output() {
  TEST_EXPECTED="string \"${THEME_QUOTES}important${THEME_NC}\" string"
  TEST_INPUT="string 'important' string"

  _capture_output _cli_pretty_quotes "'" '"' "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_quotes__arg__double__to_single__correct_output() {
  TEST_EXPECTED="string '${THEME_QUOTES}important${THEME_NC}' string"
  TEST_INPUT="string \"important\" string"

  _capture_output _cli_pretty_quotes '"' "'" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_quotes__arg__single__remove__correct_output() {
  TEST_EXPECTED="string ${THEME_QUOTES}important${THEME_NC} string"
  TEST_INPUT="string \"important\" string"

  _capture_output _cli_pretty_quotes '"' '' "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_quotes__pipe__multiple__to_double__correct_output() {
  TEST_EXPECTED="string \"${THEME_QUOTES}important${THEME_NC}\" \"${THEME_QUOTES}important${THEME_NC}\" string"
  TEST_INPUT="string 'important' 'important' string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_quotes "'" '"')"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
