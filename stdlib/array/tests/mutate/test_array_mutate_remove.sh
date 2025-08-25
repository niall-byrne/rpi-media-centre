#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error

  empty_array=()
  simple_array=("1" "2" "3")
  invalid_array="1234"
  complex_array=()
  complex_array+=("hello"$'\n'"there")
  complex_array+=("chat"$'\n'"here")
  complex_array+=("goodbye"$'\n'"there")
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________________________________________;;127" \
    "extra_args_______________________________________;1|simple_array|extra;127" \
    "simple_array__________valid_index__;1|simple_array;0" \
    "simple_array__________null_index___;|simple_array;126" \
    "simple_array__________invalid_index;x|simple_array;126" \
    "simple_array__________bounds_index_;4|simple_array;126" \
    "empty_array___________valid_index__;0|empty_array;126" \
    "empty_array___________null_index___;|empty_array;126" \
    "empty_array___________invalid_index;x|empty_array;126" \
    "empty_array___________bounds_index_;4|empty_array;126" \
    "non_existent_array____valid_index__;1|non_existent_array;126" \
    "non_existent_array____null_index___;|non_existent_array;126" \
    "non_existent_array____invalid_index;x|non_existent_array;126" \
    "non_existent_array____bounds_index_;-1|non_existent_array;126" \
    "invalid_array_________valid_index__;1|invalid_array;126" \
    "invalid_array_________null_index___;|invalid_array;126" \
    "invalid_array_________invalid_index;x|invalid_array;126" \
    "invalid_array_________bounds_index_;-1|invalid_array;126" \
    "null_array____________valid_index__;1|;127" \
    "null_array____________null_index___;|;127" \
    "null_array____________invalid_index;x|;127" \
    "null_array____________bounds_index_;-1|;127"
}

@parametrize_with_array_contents() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_ARRAY_DEFINITION" \
    "simple_array__________first_element__;0|simple_array;2|3" \
    "complex_array_________first_element__;0|complex_array;chat<br>here|goodbye<br>there" \
    "simple_array__________middle_element_;1|simple_array;1|3" \
    "complex_array_________middle_element_;1|complex_array;hello<br>there|goodbye<br>there" \
    "simple_array__________last_element___;2|simple_array;1|2" \
    "complex_array_________last_element___;2|complex_array;hello<br>there|chat<br>here"
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_remove__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.mutate.remove "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_array_mutate_remove__@vary__returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_array_mutate_remove__@vary______________updates_array_correctly() {
  local args=()
  local expected_array=()
  local expected_array_def="${TEST_EXPECTED_ARRAY_DEFINITION}"

  TEST_ARGS_DEFINITION="${TEST_ARGS_DEFINITION//'<br>'/$'\n'}"
  TEST_EXPECTED_ARRAY_DEFINITION="${TEST_EXPECTED_ARRAY_DEFINITION//'<br>'/$'\n'}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_array "|" "${TEST_EXPECTED_ARRAY_DEFINITION}"

  stdlib.array.mutate.remove "${args[@]}"

  assert_array_equals "${args[1]}" expected_array
}

@parametrize_with_array_contents \
  test_stdlib_array_mutate_remove__@vary______________updates_array_correctly
