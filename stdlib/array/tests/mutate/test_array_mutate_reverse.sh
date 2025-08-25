#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error

  empty_array=()
  simple_array=("1" "2" "3")
  single_element=("1")
  invalid_array="1234"
  complex_array=()
  complex_array+=("hello"$'\n'"there")
  complex_array+=("goodbye"$'\n'"there")
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "extra_args__________returns_status_code_127;test_array|extra_arg;127" \
    "null_array__________returns_status_code_126;|;126" \
    "non_existent_array__returns_status_code_126;non_existent;126" \
    "invalid_array_______returns_status_code_126;invalid_array;126" \
    "empty_array_________returns_status_code___0;empty_array;0" \
    "simple_array________returns_status_code___0;simple_array;0" \
    "single_element______returns_status_code___0;single_element;0" \
    "complex_array_______returns_status_code___0;complex_array;0"
}

@parametrize_with_array_contents() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_ARRAY_DEFINITION" \
    "empty_array_______;empty_array;;" \
    "simple_array______;simple_array;3|2|1" \
    "single_element____;single_element;1" \
    "complex_array_____;complex_array;goodbye<br>there|hello<br>there;"
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_reverse__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.mutate.reverse "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_array_mutate_reverse__@vary__returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_array_mutate_reverse__@vary__updates_array_correctly() {
  local args=()
  local expected_array=()

  TEST_EXPECTED_ARRAY_DEFINITION="${TEST_EXPECTED_ARRAY_DEFINITION//"<br>"/$'\n'}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_array "|" "${TEST_EXPECTED_ARRAY_DEFINITION}"

  _capture.rc stdlib.array.mutate.reverse "${args[@]}" > /dev/null

  assert_array_equals "${args[0]}" expected_array
}

@parametrize_with_array_contents \
  test_stdlib_array_mutate_reverse__@vary__updates_array_correctly
