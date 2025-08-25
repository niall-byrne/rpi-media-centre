#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127;;127" \
    "extra_arg_____________returns_status_code_127;*|match|extra_arg;127" \
    "null_regex____________returns_status_code_126;|input_string;126" \
    "null_input____________returns_status_code_126;.*||;126" \
    "regex_does_not_match__returns_status_code___1;not match|match;1" \
    "regex_matches_________returns_status_code___0;.*|match;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_____________;;ARGUMENTS_INVALID" \
    "extra_arg___________;*|match|extra_arg;ARGUMENTS_INVALID" \
    "null_regex__________;|input_string;REGEX_DOES_NOT_MATCH||input_string" \
    "null_input__________;.*||;REGEX_DOES_NOT_MATCH|.*||" \
    "regex_does_not_match;not match|match;REGEX_DOES_NOT_MATCH|not match|match"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_regex_match__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_regex_match "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_regex_match__@vary

test_stdlib_string_assert_is_regex_match__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_regex_match "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_regex_match__@vary__logs_an_error
