#!/bin/bash

test_cli_pretty_justify_left__arg__width_10__correct_output() {
  TEST_EXPECTED="string    "
  TEST_INPUT="string"

  _capture_output _cli_pretty_justify_left "10" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_justify_left__arg__width_11__correct_output() {
  TEST_EXPECTED="string     "
  TEST_INPUT="string"

  _capture_output _cli_pretty_justify_left "11" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_justify_left__pipe__width_10__correct_output() {
  TEST_EXPECTED="string    "
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_justify_left "10")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
