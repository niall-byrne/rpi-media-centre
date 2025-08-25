#!/bin/bash

# shellcheck disable=SC2034
setup() {
  TEST_ARRAY_1=("a" "bb" "ccc" "d" "fffff")
  TEST_ARRAY_2=("zzzz" "yyy" "xx" "w")
  TEST_ARRAY_3=(" " "  " "   ")
  EMPTY_ARRAY=()
  NOT_ARRAY="not an array"

  _mock.create stdlib.logger.error
}

@parametrize_with_return_codes() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS;TEST_EXPECTED_RC" \
    "no_args______;;127" \
    "extra_arg____;TEST_ARRAY_1|extra_arg;127" \
    "not_array____;NOT_ARRAY;126" \
    "empty_array__;EMPTY_ARRAY;126" \
    "valid_array_1;TEST_ARRAY_1;0" \
    "valid_array_2;TEST_ARRAY_2;0" \
    "valid_array_3;TEST_ARRAY_3;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS;TEST_MESSAGE_DEFINITIONS" \
    "no_args______;;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg____;TEST_ARRAY_1|extra_arg;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|2" \
    "empty_array__;EMPTY_ARRAY;ARRAY_IS_EMPTY|EMPTY_ARRAY" \
    "not_array____;NOT_ARRAY;IS_NOT_ARRAY|NOT_ARRAY"
}

@parametrize_with_success_outputs() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS;TEST_EXPECTED_OUTPUT" \
    "valid_array_1;TEST_ARRAY_1;5" \
    "valid_array_2;TEST_ARRAY_2;4" \
    "valid_array_3;TEST_ARRAY_3;3"
}

test_stdlib_array_get_longest__@vary__returns_expected_status_code() {
  local args=()
  stdlib.array.make.from_string args "|" "${TEST_ARGS}"

  _capture.rc stdlib.array.get.longest "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_return_codes \
  test_stdlib_array_get_longest__@vary__returns_expected_status_code

test_stdlib_array_get_longest__@vary__logs_error() {
  local args=()
  local expected_log_messages=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS}"
  stdlib.array.make.from_string message_arg_definitions " " "${TEST_MESSAGE_DEFINITIONS}"

  for message_arg_definition in "${message_arg_definitions[@]}"; do
    stdlib.array.make.from_string message_args "|" "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}"))")
  done

  _capture.rc stdlib.array.get.longest "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_array_get_longest__@vary__logs_error

test_stdlib_array_get_longest__@vary__returns_expected_output() {
  local args=()
  stdlib.array.make.from_string args "|" "${TEST_ARGS}"

  _capture.output stdlib.array.get.longest "${args[@]}"

  assert_output "${TEST_EXPECTED_OUTPUT}"
}

@parametrize_with_success_outputs \
  test_stdlib_array_get_longest__@vary__returns_expected_output
