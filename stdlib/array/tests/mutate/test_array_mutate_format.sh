#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________________returns_status_code_127;;127" \
    "extra_args________________returns_status_code_127;%s|test_array|extra_arg;127" \
    "null_array________________returns_status_code_126;%s||;126" \
    "null_format_string________returns_status_code_126;|test_array;126" \
    "invalid_array_____________returns_status_code_126;%s|invalid_array;126" \
    "invalid_format_string_____returns_status_code_126;|test_array;126" \
    "valid_array_valid_string__returns_status_code___0;%s|test_array;0" \
    "empty_array_valid_string__returns_status_code___0;%s|empty_array;0"
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_format__@vary() {
  local args=()
  local empty_array=()
  local test_array=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.mutate.format "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_array_mutate_format__@vary

# shellcheck disable=SC2034
test_stdlib_array_mutate_format__valid_args________________default_delimiter__single_element_____applies_printf() {
  expected_array=("# single element")
  test_array=("single element")

  stdlib.array.mutate.format "# %s" test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_format__valid_args________________default_delimiter__multiple_elements__applies_printf() {
  expected_array=("# one element" "# two elements" "# three elements")
  test_array=("one element" "two elements" "three elements")

  stdlib.array.mutate.format "# %s" test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_format__empty_array_______________default_delimiter__single_element_____applies_printf() {
  expected_array=()
  test_array=()

  stdlib.array.mutate.format "# %s" test_array

  assert_array_equals expected_array test_array
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_format__empty_array_______________default_delimiter__multiple_elements__applies_printf() {
  expected_array=()
  test_array=()

  stdlib.array.mutate.format "# %s" test_array

  assert_array_equals expected_array test_array
}
