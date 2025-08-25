#!/bin/bash

# shellcheck disable=SC2034
setup() {
  test_string="test string"
  test_array=("test" "array")

  _mock.create stdlib.logger.error
}

_test_fn() {
  echo "${1}"
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "arg_is_null_________returns_status_code_126;|;126" \
    "extra_arg___________returns_status_code_127;_test_fn|extra_arg;127" \
    "arg_is_string_______returns_status_code___1;test_string;1" \
    "arg_is_array________returns_status_code___1;test_array;1" \
    "arg_does_not_exist__returns_status_code___1;nothing_at_all;1" \
    "arg_is_valid_fn_____returns_status_code___0;_test_fn;0"
}

# shellcheck disable=SC2034
test_stdlib_fn_query_is_fn__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.query.is_fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_query_is_fn__@vary
