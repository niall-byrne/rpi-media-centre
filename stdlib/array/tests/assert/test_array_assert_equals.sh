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
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args__________________returns_status_code_127,,127" \
    "one_arg_only_____________returns_status_code_127,ARRAY1,127" \
    "extra_arg________________returns_status_code_127,ARRAY1|ARRAY2|extra_arg,127" \
    "first_arg_is_string______returns_status_code_126,NOT_ARRAY|ARRAY1,126" \
    "second_arg_is_string_____returns_status_code_126,ARRAY1|NOT_ARRAY,126" \
    "one_array_larger_________returns_status_code___1,ARRAY2|LARGER2,1" \
    "one_array_smaller________returns_status_code___1,ARRAY1|SMALLER1,1" \
    "first_element_different__returns_status_code___1,ARRAY2|COPIED2,1" \
    "last_element_different___returns_status_code___1,ARRAY1|COPIED1,1" \
    "arrays_are_equal_________returns_status_code___0,ARRAY1|CLONE1,0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_LOG_MESSAGE" \
    "first_arg_is_string____,NOT_ARRAY|ARRAY1,The value 'NOT_ARRAY' is not an array!" \
    "second_arg_is_string___,ARRAY1|NOT_ARRAY,The value 'NOT_ARRAY' is not an array!" \
    "one_array_larger_______,ARRAY2|LARGER2,The array 'ARRAY2' has length '3'|The array 'LARGER2' has length '4'" \
    "one_array_smaller______,ARRAY1|SMALLER1,The array 'ARRAY1' has length '3'|The array 'SMALLER1' has length '2'" \
    "first_element_different,ARRAY2|COPIED2,At index '0':| the array 'ARRAY2' has element 'running'| the array 'COPIED2' has element 'programming'" \
    "last_element_different_,ARRAY1|COPIED1,At index '2':| the array 'ARRAY1' has element 'wraps'| the array 'COPIED1' has element 'curry',"
}

test_stdlib_array_assert_equals__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.assert.equals "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_assert_equals__@vary

test_stdlib_array_assert_equals__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_log_messages "|" "${TEST_EXPECTED_LOG_MESSAGE}"

  _capture.rc stdlib.array.assert.equals "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_array_assert_equals__@vary__logs_an_error
