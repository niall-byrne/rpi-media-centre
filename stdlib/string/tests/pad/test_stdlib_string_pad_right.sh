#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args________returns_status_code_127;;127" \
    "extra_arg______returns_status_code_127;10|input_string|extra_arg;127" \
    "null_width_____returns_status_code_126;|input_string;126" \
    "valid_args_____returns_status_code___0;10|input_string;0"
}

# shellcheck disable=SC2034
test_stdlib_string_pad_right__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.pad.right "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_pad_right__@vary

test_stdlib_string_pad_right__valid_args_____arg___width_10__correct_output() {
  TEST_EXPECTED="string          "
  TEST_INPUT="string"

  _capture.output stdlib.string.pad.right "10" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_pad_right__valid_args_____arg___width_11__correct_output() {
  TEST_EXPECTED="string           "
  TEST_INPUT="string"

  _capture.output stdlib.string.pad.right "11" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_pad_right__null_input_____arg___width_11__correct_output() {
  TEST_EXPECTED="           "
  TEST_INPUT=""

  _capture.output stdlib.string.pad.left "11" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}
