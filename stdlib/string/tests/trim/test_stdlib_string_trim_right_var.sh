#!/bin/bash

test_stdlib_string_trim_right_var__arg__sets_var() {
  TEST_EXPECTED="string"
  TEST_INPUT="string          "$'\n'$'\t'

  stdlib.string.trim.right_var TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
