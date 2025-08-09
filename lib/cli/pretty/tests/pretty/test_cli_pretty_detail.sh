#!/bin/bash

test_cli_pretty_detail__arg__correct_output() {
  TEST_EXPECTED="${THEME_DETAIL}string${THEME_NC}"
  TEST_INPUT="string"

  _capture.output _cli_pretty_detail "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_detail__pipe__correct_output() {
  TEST_EXPECTED="${THEME_DETAIL}string${THEME_NC}"
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_detail)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
