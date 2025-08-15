#!/bin/bash

# shellcheck disable=SC2034
setup() {
  ARRAY1=("sandwiches" "pizza" "wraps")

  NOT_ARRAY="not an array"

  NULL_ARRAY=("")
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args________________________returns_status_code_127;;127" \
    "extra_arg______________________returns_status_code_127;ARRAY1|value|extra_arg;127" \
    "array_arg_is_string____________returns_status_code_126;NOT_ARRAY|value;126" \
    "value_arg_is_non_present_null__returns_status_code___1;ARRAY1||;1" \
    "value_is_not_present___________returns_status_code___1;ARRAY1|beef;1" \
    "value_arg_is_present_null______returns_status_code___0;NULL_ARRAY||;0" \
    "value_is_present_______________returns_status_code___0;ARRAY1|wraps;0"
}

# shellcheck disable=SC2034
test_stdlib_array_query_contains__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.query.contains "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_query_contains__@vary
