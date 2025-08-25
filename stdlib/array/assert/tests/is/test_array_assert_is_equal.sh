#!/bin/bash

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")
  CLONE1=("${ARRAY1[@]}")
  COPIED1=("${ARRAY1[@]}")
  COPIED1[2]="curry"
  SMALLER1=("sandwiches" "pizza")
  SMALLER1_WITH_DIFF=("burritos" "pizza")

  ARRAY2=("running" "biking" "guitar")
  LARGER2=("running" "biking" "guitar" "cooking")
  LARGER2_WITH_DIFF=("running" "swimming" "guitar" "cooking")
  COPIED2=("${ARRAY2[@]}")
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
    "one_array_larger_________returns_status_code___1;ARRAY2|LARGER2;1" \
    "one_array_smaller________returns_status_code___1;ARRAY1|SMALLER1;1" \
    "first_element_different__returns_status_code___1;ARRAY2|COPIED2;1" \
    "last_element_different___returns_status_code___1;ARRAY1|COPIED1;1" \
    "arrays_are_equal_________returns_status_code___0;ARRAY1|CLONE1;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITIONS" \
    "no_args________________________;;ARGUMENTS_INVALID" \
    "first_arg_is_string____________;NOT_ARRAY|ARRAY1;IS_NOT_ARRAY|NOT_ARRAY;" \
    "second_arg_is_string___________;ARRAY1|NOT_ARRAY;IS_NOT_ARRAY|NOT_ARRAY;" \
    "one_array_larger_and_similar___;ARRAY2|LARGER2;ARRAY_LENGTH_MISMATCH|ARRAY2|3 ARRAY_LENGTH_MISMATCH|LARGER2|4" \
    "one_array_larger_and_different_;ARRAY2|LARGER2_WITH_DIFF;ARRAY_LENGTH_MISMATCH|ARRAY2|3 ARRAY_LENGTH_MISMATCH|LARGER2_WITH_DIFF|4 ARRAY_ELEMENT_MISMATCH|ARRAY2|1|biking ARRAY_ELEMENT_MISMATCH|LARGER2_WITH_DIFF|1|swimming" \
    "one_array_smaller_and_similar__;ARRAY1|SMALLER1;ARRAY_LENGTH_MISMATCH|ARRAY1|3 ARRAY_LENGTH_MISMATCH|SMALLER1|2" \
    "one_array_smaller_and_different;ARRAY1|SMALLER1_WITH_DIFF;ARRAY_LENGTH_MISMATCH|ARRAY1|3 ARRAY_LENGTH_MISMATCH|SMALLER1_WITH_DIFF|2 ARRAY_ELEMENT_MISMATCH|ARRAY1|0|sandwiches ARRAY_ELEMENT_MISMATCH|SMALLER1_WITH_DIFF|0|burritos" \
    "first_element_different________;ARRAY2|COPIED2;ARRAY_ELEMENT_MISMATCH|ARRAY2|0|running ARRAY_ELEMENT_MISMATCH|COPIED2|0|programming" \
    "last_element_different_________;ARRAY1|COPIED1;ARRAY_ELEMENT_MISMATCH|ARRAY1|2|wraps ARRAY_ELEMENT_MISMATCH|COPIED1|2|curry"
}

test_stdlib_array_assert_is_equal__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.assert.is_equal "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_assert_is_equal__@vary

test_stdlib_array_assert_is_equal__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_arg_definitions " " "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    stdlib.array.make.from_string message_args "|" "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}"))")
  done

  stdlib.array.assert.is_equal "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}
@parametrize_with_error_messages \
  test_stdlib_array_assert_is_equal__@vary__logs_an_error
