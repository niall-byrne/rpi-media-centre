#!/bin/bash

test_stdlib_string_wrap__pipe__wrapped_string__pad_width_10__wrap_20__correct_output() {
  TEST_EXPECTED="this is a"$'\n'"          string of"$'\n'"          text that"$'\n'"          i would"$'\n'"          like to"$'\n'"          wrap"
  TEST_INPUT="this is a string of text that i would like to wrap"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.string.wrap_pipe "10" "20")"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
