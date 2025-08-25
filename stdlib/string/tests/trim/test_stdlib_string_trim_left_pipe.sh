#!/bin/bash

test_stdlib_string_trim_left__pipe__correct_output() {
  TEST_EXPECTED="string"
  TEST_INPUT="          "$'\n'$'\t'"string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.string.trim.left_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
