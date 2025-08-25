#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error

  empty_array=()
  simple_array=("1" "2" "3")
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
    "no_args______________________________;;127" \
    "extra_args___________________________;a|simple_array|extra;127" \
    "simple_array__________valid_string___;a|simple_array;0" \
    "simple_array__________null_string____;|simple_array;0" \
    "non_existent_array____valid_string___;a|non_existent_array;126" \
    "non_existent_array____null_string____;|non_existent_array;126" \
    "invalid_array_________valid_string___;a|invalid_array;126" \
    "invalid_array_________null_string____;|invalid_array;126" \
    "null_array____________valid_string___;a|;127" \
    "null_array____________null_string____;|;127"
}

@parametrize_with_array_contents() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_ARRAY_DEFINITION" \
    "simple_array__________one_char_string;a|simple_array;a1|a2|a3" \
    "complex_array_________one_char_string;a|complex_array;ahello<br>there|agoodbye<br>there" \
    "empty_array___________one_char_string;a|empty_array;;" \
    "simple_array__________complex_string_;a<br>z|simple_array;a<br>z1|a<br>z2|a<br>z3" \
    "complex_array_________complex_string_;a<br>z|complex_array;a<br>zhello<br>there|a<br>zgoodbye<br>there" \
    "empty_array___________complex_string_;a<br>z|empty_array;;" \
    "simple_array__________empty_string___;|simple_array;1|2|3" \
    "complex_array_________empty_string___;|complex_array;hello<br>there|goodbye<br>there" \
    "empty_array___________empty_string___;|empty_array;;"
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_prepend__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.mutate.prepend "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_array_mutate_prepend__@vary__returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_array_mutate_prepend__@vary__updates_array_correctly() {
  local args=()
  local expected_array=()
  local expected_array_def="${TEST_EXPECTED_ARRAY_DEFINITION}"

  TEST_ARGS_DEFINITION="${TEST_ARGS_DEFINITION//'<br>'/$'\n'}"
  TEST_EXPECTED_ARRAY_DEFINITION="${TEST_EXPECTED_ARRAY_DEFINITION//'<br>'/$'\n'}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_array "|" "${TEST_EXPECTED_ARRAY_DEFINITION}"

  stdlib.array.mutate.prepend "${args[@]}"

  assert_array_equals "${args[1]}" expected_array
}

@parametrize_with_array_contents \
  test_stdlib_array_mutate_prepend__@vary__updates_array_correctly
