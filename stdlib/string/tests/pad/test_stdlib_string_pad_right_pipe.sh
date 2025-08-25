#!/bin/bash

test_stdlib_string_pad_right__pipe__width_10__correct_output() {
  TEST_EXPECTED="string          "
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.string.pad.right_pipe "10")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
