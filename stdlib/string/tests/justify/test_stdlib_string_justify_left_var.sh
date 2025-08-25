#!/bin/bash

test_stdlib_string_justify_left_var__arg__width_10__sets_var() {
  TEST_EXPECTED="string    "
  TEST_INPUT="string"

  stdlib.string.justify.left_var "10" TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
