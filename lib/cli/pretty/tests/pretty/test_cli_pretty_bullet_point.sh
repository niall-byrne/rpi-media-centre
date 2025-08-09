#!/bin/bash

@parametrize_with_indents() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_INDENT_SIZE,EXPECTED_INDENT" \
    "indent_size_5,5,     " \
    "indent_size_3,3,   "
}

test_cli_pretty_bullet_point__arg____default_indent__correct_output() {
  TEST_EXPECTED="- ${THEME_ENTITY}bullet point${THEME_NC}"
  TEST_INPUT="bullet point"

  _capture.output _cli_pretty_bullet_point "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_bullet_point__arg____@vary___correct_output() {
  TEST_EXPECTED="${EXPECTED_INDENT}- ${THEME_ENTITY}bullet point${THEME_NC}"
  TEST_INPUT="bullet point"

  _capture.output _cli_pretty_bullet_point "${TEST_INPUT}" "${TEST_INDENT_SIZE}"

  assert_output "${TEST_EXPECTED}"
}

@parametrize_with_indents \
  test_cli_pretty_bullet_point__arg____@vary___correct_output

test_cli_pretty_bullet_point__pipe___@vary___correct_output() {
  TEST_EXPECTED="${EXPECTED_INDENT}- ${THEME_ENTITY}bullet point${THEME_NC}"
  TEST_INPUT="bullet point"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_bullet_point - "${TEST_INDENT_SIZE}")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}

@parametrize_with_indents \
  test_cli_pretty_bullet_point__pipe___@vary___correct_output
