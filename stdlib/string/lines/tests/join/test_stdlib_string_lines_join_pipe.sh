#!/bin/bash

test_stdlib_string_lines_join_pipe__default_line_ending__correct_output() {
  TEST_EXPECTED="string1 string2 string3 "
  TEST_INPUT="string1 "$'\n'"string2 "$'\n'"string3 "$'\n'

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.string.lines.join_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
