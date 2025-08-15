#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "extra_arg___________returns_status_code_127;ARRAY1|#|input_string|extra_arg;127" \
    "null_array_name_____returns_status_code_126;|#|input string;126" \
    "null_seperator______returns_status_code_126;test||input string;126" \
    "null_source_string__returns_status_code_0;test|#||;0"
}

test_stdlib_array_make_from_string__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.make.from_string "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_make_from_string__@vary

test_stdlib_array_make_from_string__valid_arguments_____returns_status_code_0() {
  _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "field1|field2|field3"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string__valid_arguments_____creates_new_array() {
  local expected_array=("field1" "field2" "field3")

  _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "field1|field2|field3"

  assert_array_equals expected_array array_name
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string__null_source_string__creates_empty_array() {
  local expected_array=()

  _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "|" \
    ""

  assert_is_array array_name
  assert_array_equals expected_array array_name
}
