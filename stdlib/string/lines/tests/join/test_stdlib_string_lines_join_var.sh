#!/bin/bash

test_stdlib_string_lines_join_var__arg__sets_var() {
  TEST_EXPECTED="string1 string2 string3 "
  TEST_INPUT="string1 "$'\n'"string2 "$'\n'"string3 "$'\n'

  stdlib.string.lines.join_var TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
