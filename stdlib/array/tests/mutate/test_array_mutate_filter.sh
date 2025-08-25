#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error

  empty_array=()
  single_value_false=("lowercase")
  single_value_true=("UPPERCASE")
  multi_value_false=("lowercase1" "lowercase2")
  multi_value_mixed=("lowercase1" "UPPERCASE1")
  multi_value_true=("UPPERCASE1" "UPPERCASE2")
}

_is_uppercase() {
  local test_value

  test_value="$(echo "${1}" | tr '[:lower:]' '[:upper:]')"

  [[ "${test_value}" == "${1}" ]]
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "extra_args__________returns_status_code_127;_is_uppercase|test_array|extra_arg;127" \
    "null_array__________returns_status_code_126;_is_uppercase||;126" \
    "null_fn_____________returns_status_code_126;|test_array;126" \
    "invalid_fn__________returns_status_code_126;_invalid_fn_name|test_array;126" \
    "invalid_array_______returns_status_code_126;_invalid_fn_name|invalid_array;126" \
    "valid_fn_and_array__returns_status_code___0;_is_uppercase|test_array;0" \
    "empty_array_________returns_status_code___0;_is_uppercase|empty_array;0"
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_filter__@vary() {
  local args=()
  local empty_array=()
  local test_array=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.mutate.filter "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_string_array_mutate_filter__@vary

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_filter__valid_args__________empty_array_______________applies_filter() {
  empty_array=()
  expected_array=()

  stdlib.array.mutate.filter _is_uppercase empty_array

  assert_array_equals expected_array empty_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_filter__valid_args__________single_element_false______applies_filter() {
  expected_array=()
  test_array=("one element")

  stdlib.array.mutate.filter _is_uppercase test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_filter__valid_args__________single_element_true_______applies_filter() {
  expected_array=("ONE ELEMENT")
  test_array=("ONE ELEMENT")

  stdlib.array.mutate.filter _is_uppercase test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_filter__valid_args__________multi_elements_false______applies_filter() {
  expected_array=()
  test_array=("one element" "two element")

  stdlib.array.mutate.filter _is_uppercase test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_filter__valid_args__________multi_elements_true_______applies_filter() {
  expected_array=("ONE ELEMENT" "TWO ELEMENT" "THREE ELEMENT")
  test_array=("ONE ELEMENT" "TWO ELEMENT" "THREE ELEMENT")

  stdlib.array.mutate.filter _is_uppercase test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_string_array_mutate_filter__valid_args__________multi_elements_partial____applies_filter() {
  expected_array=("ONE ELEMENT" "THREE ELEMENT")
  test_array=("ONE ELEMENT" "two element" "THREE ELEMENT")

  stdlib.array.mutate.filter _is_uppercase test_array

  assert_array_equals expected_array test_array
}
