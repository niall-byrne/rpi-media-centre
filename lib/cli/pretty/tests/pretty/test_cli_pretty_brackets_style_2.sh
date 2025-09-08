#!/bin/bash

test_cli_pretty_brackets_style_2_arg__correct_output() {
  TEST_EXPECTED="string ${THEME_BRACKETS_STYLE_2}[${THEME_BRACKETS_STYLE_2_INNER}with${THEME_BRACKETS_STYLE_2}]${THEME_NC} some mixed ${THEME_BRACKETS_STYLE_2}(${THEME_BRACKETS_STYLE_2_INNER}brackets${THEME_BRACKETS_STYLE_2})${THEME_NC}"
  TEST_INPUT="string [with] some mixed (brackets)"

  _capture.output _cli_pretty_brackets_style_2 "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_brackets_style_2__pipe__correct_output() {
  TEST_EXPECTED="string ${THEME_BRACKETS_STYLE_2}[${THEME_BRACKETS_STYLE_2_INNER}with${THEME_BRACKETS_STYLE_2}]${THEME_NC} some mixed ${THEME_BRACKETS_STYLE_2}(${THEME_BRACKETS_STYLE_2_INNER}brackets${THEME_BRACKETS_STYLE_2})${THEME_NC}"
  TEST_INPUT="string [with] some mixed (brackets)"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_brackets_style_2_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
