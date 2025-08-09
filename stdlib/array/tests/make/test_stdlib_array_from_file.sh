#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127,,127" \
    "extra_arg________returns_status_code_127,ARRAY1|#|not_a_real_file.txt|extra_arg,127" \
    "null_array_name__returns_status_code_126,|#|not_a_real_file.txt,126" \
    "null_seperator___returns_status_code_126,test||not_a_real_file.txt,126" \
    "null_file_name___returns_status_code_126,test|#||,126"
}

test_stdlib_array_make_from_file__@vary() {
  local args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.make.from_file "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_make_from_file__@vary

test_stdlib_array_make_from_file__valid_arguments__file_does_not_exist__returns_status_code_126() {
  _capture.rc stdlib.array.make.from_file "array_name" "|" "non_existent.txt"

  assert_rc "126"
}

test_stdlib_array_make_from_file__valid_arguments__file_does_not_exist__logs_error_message() {
  stdlib.array.make.from_file "array_name" "|" "non_existent.txt"

  stdlib.logger.error.mock.assert_called_once_with \
    "The path 'non_existent.txt' is not a valid filesystem file!"
}

test_stdlib_array_make_from_file__valid_arguments__file_exists__returns_status_code_0() {
  _capture.rc stdlib.array.make.from_file \
    "array_name" \
    "|" \
    "__fixtures__/array_as_file.txt"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_file__valid_arguments__file_exists__creates_new_array() {
  local expected_array=("field1" "field2" "field3")

  _capture.rc stdlib.array.make.from_file \
    "array_name" \
    "|" \
    "__fixtures__/array_as_file.txt"

  assert_array_equals expected_array array_name
}
