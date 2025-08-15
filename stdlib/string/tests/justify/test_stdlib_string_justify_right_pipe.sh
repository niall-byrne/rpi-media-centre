#!/bin/bash

test_stdlib_string_justify_right__pipe__width_10__correct_output() {
  TEST_EXPECTED="    string"
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.string.justify.right_pipe "10")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
