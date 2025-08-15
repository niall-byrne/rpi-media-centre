#!/bin/bash

# shellcheck disable=SC2034
setup() {
  EMPTY_ARRAY=()
  ARRAY1=("sandwiches" "pizza" "wraps")

  NOT_ARRAY="not an array"
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;ARRAY1|extra_arg;127" \
    "arg_is_string____returns_status_code___1;NOT_ARRAY;1" \
    "empty_array______returns_status_code___0;EMPTY_ARRAY;0" \
    "populated_array__returns_status_code___0;ARRAY1;0"
}

# shellcheck disable=SC2034
test_stdlib_array_query_is_array__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.query.is_array "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_query_is_array__@vary
