#!/bin/bash

test_cli_pretty_strip_trailing_newline__not_called______ensure_new_line_present() {
  TEST_INPUT="aaaaa"

  _capture.output_raw echo "${TEST_INPUT}"

  assert_output "${TEST_INPUT}"$'\n'
}

test_cli_pretty_strip_trailing_newline__arg_____________strips_terminating_new_line() {
  TEST_INPUT="aaaaa"

  _capture.output_raw _cli_pretty_strip_trailing_newline "${TEST_INPUT}"

  assert_output "${TEST_INPUT}"
}

test_cli_pretty_strip_trailing_newline__newline_in_arg__strips_terminating_new_line_only() {
  TEST_INPUT="aaaaa"$'\n'"aaaaa"

  _capture.output_raw _cli_pretty_strip_trailing_newline "${TEST_INPUT}"

  assert_output "${TEST_INPUT}"
}

test_cli_pretty_strip_trailing_newline__pipe____________strips_terminating_new_line() {
  TEST_INPUT="aaaaa"

  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <(echo "${TEST_INPUT}" | _cli_pretty_strip_trailing_newline)

  assert_equals "${TEST_INPUT}" "${TEST_OUTPUT}"
}
