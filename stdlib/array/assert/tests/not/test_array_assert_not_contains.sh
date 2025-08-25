#!/bin/bash

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  EMPTY_ARRAY=()
  NULL_ARRAY=("")

  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________________returns_status_code_127;;127" \
    "extra_arg__________________returns_status_code_127;value|ARRAY1|extra_arg;127" \
    "array_arg_is_string________returns_status_code_126;value|NOT_ARRAY;126" \
    "null_value_is_present______returns_status_code___1;|NULL_ARRAY;1" \
    "value_is_present___________returns_status_code___1;wraps|ARRAY1;1" \
    "null_value_is_not_present__returns_status_code___0;|ARRAY1;0" \
    "value_is_not_present_______returns_status_code___0;beef|ARRAY1;0" \
    "array_is_empty_____________returns_status_code___0;beef|EMPTY_ARRAY;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "extra_arg___________;ARRAY1|value|extra_arg;ARGUMENTS_INVALID" \
    "array_arg_is_string_;NOT_ARRAY|value;ARGUMENTS_INVALID" \
    "value_arg_is_null___;|NULL_ARRAY;ARRAY_VALUE_FOUND||NULL_ARRAY" \
    "value_is__present___;sandwiches|ARRAY1;ARRAY_VALUE_FOUND|sandwiches|ARRAY1"
}

test_stdlib_array_assert_not_contains__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.assert.not_contains "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_assert_not_contains__@vary

test_stdlib_array_assert_not_contains__@vary_______logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.array.assert.not_contains "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_array_assert_not_contains__@vary_______logs_an_error
