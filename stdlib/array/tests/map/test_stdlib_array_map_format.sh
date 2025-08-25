#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args________________returns_status_code_127;;127" \
    "extra_args_____________returns_status_code_127;%s|test_array|extra_arg;127" \
    "null_array_____________returns_status_code_126;%s||;126" \
    "null_format_string_____returns_status_code_126;|test_array;126" \
    "invalid_array__________returns_status_code_126;%s|invalid_array;126" \
    "invalid_format_string__returns_status_code_126;|test_array;126" \
    "both_valid_____________returns_status_code___0;%s|test_array;0"
}

# shellcheck disable=SC2034
test_stdlib_array_map_format__@vary() {
  local args=()
  local test_array=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.map.format "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_array_map_format__@vary

# shellcheck disable=SC2034
test_stdlib_array_map_format__valid_args_____________default_delimiter__single_element_____applies_printf() {
  test_array=("single element")

  _capture.output_raw stdlib.array.map.format "# %s\n" test_array

  assert_output "# single element"$'\n'
}

# shellcheck disable=SC2034
test_stdlib_array_map_format__valid_args_____________default_delimiter__multiple_elements__applies_printf() {
  test_array=("one element" "two elements" "three elements")

  _capture.output_raw stdlib.array.map.format "# %s\n" test_array

  assert_output "# one element"$'\n'"# two elements"$'\n'"# three elements"$'\n'
}
