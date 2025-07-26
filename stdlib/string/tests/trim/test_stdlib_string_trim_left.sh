#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args________returns_status_code_127,,127" \
    "extra_arg______returns_status_code_127,10|input_string|extra_arg,127"
}

# shellcheck disable=SC2034
test_stdlib_string_trim_left__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture_rc stdlib.string.trim.left "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_trim_left__@vary

test_stdlib_string_trim_left__valid_args_____arg___correct_output() {
  TEST_EXPECTED="string"
  TEST_INPUT="          "$'\n'$'\t'"string"

  _capture_output stdlib.string.trim.left "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}
