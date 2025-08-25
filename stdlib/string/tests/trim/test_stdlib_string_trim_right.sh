#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args________returns_status_code_127;;127" \
    "extra_arg______returns_status_code_127;10|input_string|extra_arg;127"
}

# shellcheck disable=SC2034
test_stdlib_string_trim_right__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.trim.right "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_trim_right__@vary

test_stdlib_string_trim_right__valid_args_____arg___correct_output() {
  TEST_EXPECTED="string"
  TEST_INPUT="string          "$'\n'$'\t'

  _capture.output stdlib.string.trim.right "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_trim_right__null_input_____arg___correct_output() {
  TEST_INPUT=""

  _capture.output stdlib.string.trim.right "${TEST_INPUT}"

  assert_output_null
}
