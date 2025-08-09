#!/bin/bash

test_cli_pretty_brackets_style_1_arg__correct_output() {
  TEST_EXPECTED="string ${THEME_BRACKETS_STYLE_1}[${THEME_BRACKETS_STYLE_1_INNER}with${THEME_BRACKETS_STYLE_1}]${THEME_NC} some mixed ${THEME_BRACKETS_STYLE_1}(${THEME_BRACKETS_STYLE_1_INNER}brackets${THEME_BRACKETS_STYLE_1})${THEME_NC}"
  TEST_INPUT="string [with] some mixed (brackets)"

  _capture.output _cli_pretty_brackets_style_1 "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_brackets_style_1__pipe__correct_output() {
  TEST_EXPECTED="string ${THEME_BRACKETS_STYLE_1}[${THEME_BRACKETS_STYLE_1_INNER}with${THEME_BRACKETS_STYLE_1}]${THEME_NC} some mixed ${THEME_BRACKETS_STYLE_1}(${THEME_BRACKETS_STYLE_1_INNER}brackets${THEME_BRACKETS_STYLE_1})${THEME_NC}"
  TEST_INPUT="string [with] some mixed (brackets)"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_brackets_style_1)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
