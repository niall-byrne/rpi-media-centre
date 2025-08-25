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

# shellcheck disable=SC2034
test_stdlib_array_query_is_equal__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.query.is_equal "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_query_is_equal__@vary
