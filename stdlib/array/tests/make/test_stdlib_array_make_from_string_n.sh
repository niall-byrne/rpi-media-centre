#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;ARRAY1|2|aa|extra_arg;127" \
    "invalid_count____returns_status_code_126;test|##|aa;126" \
    "null_array_name__returns_status_code_126;|####|20;126" \
    "null_string______returns_status_code___0;test|20||;0" \
    "null_count_______returns_status_code_126;test||aa;126"
}

test_stdlib_array_make_from_string_n__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.make.from_string_n "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_make_from_string_n__@vary

test_stdlib_array_make_from_string_n__valid_arguments__returns_status_code_0() {
  _capture.rc stdlib.array.make.from_string_n \
    "array_name" \
    "3" \
    "##########"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string_n__valid_arguments__creates_new_array() {
  local expected_array=("##########" "##########" "##########")

  _capture.rc stdlib.array.make.from_string_n \
    "array_name" \
    "3" \
    "##########"

  assert_array_equals expected_array array_name
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string_n__null_string______creates_new_array() {
  local expected_array=("" "" "")

  _capture.rc stdlib.array.make.from_string_n \
    "array_name" \
    "3" \
    ""

  assert_array_equals expected_array array_name
}
