#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args________returns_status_code_127;;127" \
    "extra_arg______returns_status_code_127;input_string|extra_arg;127" \
    "null_input_____returns_status_code___0;|;0" \
    "valid_args_____returns_status_code___0;input_string;0"
}

# shellcheck disable=SC2034
test_stdlib_string_lines_join__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.lines.join "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_lines_join__@vary

test_stdlib_string_lines_join__valid_args_____arg___default_line_ending__correct_output() {
  TEST_EXPECTED="string1 string2 string3 "
  TEST_INPUT="string1 "$'\n'"string2 "$'\n'"string3 "$'\n'

  _capture.output stdlib.string.lines.join "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_lines_join__valid_args_____arg___windows_line_ending__correct_output() {
  TEST_EXPECTED="string1 string2 string3 "
  TEST_INPUT="string1 "$'\r\n'"string2 "$'\r\n'"string3 "$'\r\n'

  _STDLIB_DELIMITER=$'\r\n' _capture.output stdlib.string.lines.join "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_lines_join__null_input_____arg___windows_line_ending__correct_output() {
  TEST_INPUT=""

  _STDLIB_DELIMITER=$'\r\n' _capture.output stdlib.string.lines.join "${TEST_INPUT}"

  assert_output_null
}
