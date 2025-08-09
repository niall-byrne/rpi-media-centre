#!/bin/bash

test_cli_pretty_wrap_column__arg__column_width_10__wrap_20__correct_output() {
  TEST_EXPECTED="this is a "$'\n'"            string of "$'\n'"            text that "$'\n'"            i would like "$'\n'"            to wrap "
  TEST_INPUT="this is a string of text that i would like to wrap"

  _capture.output _cli_pretty_wrap_column "10" "20" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_wrap_column__arg__column_width_10__wrap_20__cr__correct_output() {
  TEST_EXPECTED="this is a "$'\n'"            string of "$'\n'"            text "$'\n'"            that i would "$'\n'"            like to wrap "
  TEST_INPUT="this is a string of text *that i would like to wrap"

  _capture.output _cli_pretty_wrap_column "10" "20" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_wrap_column__pipe__column_width_10__wrap_20__correct_output() {
  TEST_EXPECTED="this is a "$'\n'"            string of "$'\n'"            text that "$'\n'"            i would like "$'\n'"            to wrap "
  TEST_INPUT="this is a string of text that i would like to wrap"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_wrap_column "10" "20")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
