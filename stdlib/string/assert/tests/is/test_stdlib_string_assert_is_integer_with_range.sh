#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________________returns_status_code_127;;127" \
    "extra_arg_________________returns_status_code_127;0|0|1|extra_arg;127" \
    "empty_string______________returns_status_code_126;0|1||;126" \
    "invalid_start_____________returns_status_code_126;@|1|1;126" \
    "invalid_end_______________returns_status_code_126;0|@|1;126" \
    "invalid_both______________returns_status_code_126;@|@|1;126" \
    "invalid_range_____________returns_status_code_126;10|0|1;126" \
    "positive_out_of_range_____returns_status_code___1;10|20|5;1" \
    "positive_in_range_________returns_status_code___0;10|20|15;0" \
    "negative_out_of_range_____returns_status_code___1;-20|-10|-5;1" \
    "negative_in_range_________returns_status_code___0;-10|10|0;0" \
    "overlapping_out_of_range__returns_status_code___1;20|20|10;1" \
    "overlapping_in_range______returns_status_code___0;-20|-20|-20;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_________________;;ARGUMENTS_INVALID" \
    "extra_arg_______________;0|0|1|extra_arg;ARGUMENTS_INVALID" \
    "empty_string____________;0|1||;ARGUMENTS_INVALID" \
    "invalid_start___________;@|1|1;ARGUMENTS_INVALID" \
    "invalid_end_____________;0|@|1;ARGUMENTS_INVALID" \
    "invalid_both____________;@|@|1;ARGUMENTS_INVALID" \
    "invalid_range___________;10|0||;ARGUMENTS_INVALID" \
    "positive_out_of_range___;10|20|5;IS_NOT_INTEGER_IN_RANGE|10|20|5" \
    "negative_out_of_range___;-20|-10|-5;IS_NOT_INTEGER_IN_RANGE|-20|-10|-5" \
    "overlapping_out_of_range;20|20|10;IS_NOT_INTEGER_IN_RANGE|20|20|10"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_integer_with_range__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_integer_with_range "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_integer_with_range__@vary

test_stdlib_string_assert_is_integer_with_range__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_integer_with_range "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_integer_with_range__@vary__logs_an_error
