#!/bin/bash

test_stdlib_string_pad_right_var__arg__width_10__sets_var() {
  TEST_EXPECTED="string          "
  TEST_INPUT="string"

  stdlib.string.pad.right_var "10" TEST_INPUT

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
