#!/bin/bash

test_stdlib_string_trim_right__pipe__correct_output() {
  TEST_EXPECTED="string"
  TEST_INPUT="string          "$'\n'$'\t'

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.string.trim.right_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
