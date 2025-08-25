#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

_uppercase() {
  echo "UPPERCASE: ${1}" | tr '[:lower:]' '[:upper:]'
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "extra_args__________returns_status_code_127;_uppercase|test_array|extra_arg;127" \
    "null_array__________returns_status_code_126;_uppercase||;126" \
    "null_fn_____________returns_status_code_126;|test_array;126" \
    "invalid_fn__________returns_status_code_126;_invalid_fn_name|test_array;126" \
    "invalid_array_______returns_status_code_126;_invalid_fn_name|invalid_array;126" \
    "valid_fn_and_array__returns_status_code___0;_uppercase|test_array;0" \
    "empty_array_________returns_status_code___0;_uppercase|empty_array;0"
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_fn__@vary() {
  local args=()
  local empty_array=()
  local test_array=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.mutate.fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_string_array_mutate_fn__@vary

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_fn__valid_args__________single_element_____applies_fn() {
  expected_array=("UPPERCASE: SINGLE ELEMENT")
  test_array=("single element")

  stdlib.array.mutate.fn _uppercase test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_fn__valid_args__________multiple_elements__applies_fn() {
  expected_array=("UPPERCASE: ONE ELEMENT" "UPPERCASE: TWO ELEMENTS" "UPPERCASE: THREE ELEMENTS")
  test_array=("one element" "two elements" "three elements")

  stdlib.array.mutate.fn _uppercase test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_fn__empty_array_________single_element_____applies_fn() {
  expected_array=()
  test_array=()

  stdlib.array.mutate.fn _uppercase test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_fn__empty_array_________multiple_elements__applies_fn() {
  expected_array=()
  test_array=()

  stdlib.array.mutate.fn _uppercase test_array

  assert_array_equals expected_array test_array
}
