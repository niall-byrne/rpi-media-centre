#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args________________returns_status_code_127;;127" \
    "extra_arg______________returns_status_code_127;value1|value2|extra_arg;127" \
    "empty_match_string_____returns_status_code_126;|value2;126" \
    "empty_input_string_____returns_status_code___0;value1||;0" \
    "non_matching_strings___returns_status_code___0;value1|value2;0" \
    "matching_values________returns_status_code___1;value1|value1;1"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args______________;;ARGUMENTS_INVALID" \
    "extra_arg____________;value1|value2|extra_arg;ARGUMENTS_INVALID" \
    "empty_match_string___;|value2;ARGUMENTS_INVALID" \
    "matching_values______;value1|value1;IS_EQUAL|value1"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_not_equal__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.not_equal "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_not_equal__@vary

test_stdlib_string_assert_not_equal__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.not_equal "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_not_equal__@vary__logs_an_error
