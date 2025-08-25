#!/bin/bash

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  CLONE1=("${ARRAY1[@]}")
  COPIED1=("${ARRAY1[@]}")
  COPIED1[2]="curry"
  SMALLER1=("sandwiches" "pizza")

  ARRAY2=("running" "biking" "guitar")
  LARGER2=("running" "biking" "guitar" "cooking")
  COPIED2=("${ARRAY1[@]}")
  COPIED2[0]="programming"

  NOT_ARRAY="not an array"

  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________________returns_status_code_127;;127" \
    "one_arg_only_____________returns_status_code_127;ARRAY1;127" \
    "extra_arg________________returns_status_code_127;ARRAY1|ARRAY2|extra_arg;127" \
    "first_arg_is_string______returns_status_code_126;NOT_ARRAY|ARRAY1;126" \
    "second_arg_is_string_____returns_status_code_126;ARRAY1|NOT_ARRAY;126" \
    "one_array_larger_________returns_status_code___0;ARRAY2|LARGER2;0" \
    "one_array_smaller________returns_status_code___0;ARRAY1|SMALLER1;0" \
    "first_element_different__returns_status_code___0;ARRAY2|COPIED2;0" \
    "last_element_different___returns_status_code___0;ARRAY1|COPIED1;0" \
    "arrays_are_equal_________returns_status_code___1;ARRAY1|CLONE1;1"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args________________;;ARGUMENTS_INVALID" \
    "one_arg_only___________;ARRAY1;ARGUMENTS_INVALID" \
    "extra_arg______________;ARRAY1|ARRAY2|extra_arg;ARGUMENTS_INVALID" \
    "first_arg_is_string____;NOT_ARRAY|ARRAY1;IS_NOT_ARRAY|NOT_ARRAY" \
    "second_arg_is_string___;ARRAY1|NOT_ARRAY;IS_NOT_ARRAY|NOT_ARRAY" \
    "arrays_are_equal_______;ARRAY1|CLONE1;ARRAY_ARE_EQUAL|ARRAY1|CLONE1"
}

test_stdlib_array_assert_not_equal__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.assert.not_equal "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_assert_not_equal__@vary

test_stdlib_array_assert_not_equal__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.array.assert.not_equal "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}
@parametrize_with_error_messages \
  test_stdlib_array_assert_not_equal__@vary__logs_an_error
