#!/bin/bash

test_stdlib_string_trim_left_var__arg__sets_var() {
  TEST_EXPECTED="string"
  TEST_INPUT="          "$'\n'$'\t'"string"

  stdlib.string.trim.left_var TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
