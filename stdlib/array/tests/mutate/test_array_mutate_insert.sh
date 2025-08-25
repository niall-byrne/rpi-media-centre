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
    "no_args__________________________________________;;127" \
    "extra_args_______________________________________;a|1|simple_array|extra;127" \
    "simple_array__________valid_string__valid_index__;a|1|simple_array;0" \
    "simple_array__________valid_string__null_index___;a||simple_array;126" \
    "simple_array__________valid_string__invalid_index;a|x|simple_array;126" \
    "simple_array__________valid_string__bounds_index_;a|4|simple_array;126" \
    "simple_array__________null_string___valid_index__;|1|simple_array;0" \
    "simple_array__________null_string___null_index___;||simple_array;126" \
    "simple_array__________null_string___invalid_index;|x|simple_array;126" \
    "simple_array__________null_string___bounds_index_;|-1|simple_array;126" \
    "non_existent_array____valid_string__valid_index__;a|1|non_existent_array;126" \
    "non_existent_array____valid_string__null_index___;a||non_existent_array;126" \
    "non_existent_array____valid_string__invalid_index;a|x|non_existent_array;126" \
    "non_existent_array____valid_string__bounds_index_;a|-1|non_existent_array;126" \
    "non_existent_array____null_string___valid_index__;|1|non_existent_array;126" \
    "non_existent_array____null_string___null_index___;||non_existent_array;126" \
    "non_existent_array____null_string___invalid_index;|x|non_existent_array;126" \
    "non_existent_array____null_string___bounds_index_;|-1|non_existent_array;126" \
    "invalid_array_________valid_string__valid_index__;a|1|invalid_array;126" \
    "invalid_array_________valid_string__null_index___;a||invalid_array;126" \
    "invalid_array_________valid_string__invalid_index;a|x|invalid_array;126" \
    "invalid_array_________valid_string__bounds_index_;a|-1|invalid_array;126" \
    "invalid_array_________null_string___valid_index__;|1|invalid_array;126" \
    "invalid_array_________null_string___null_index___;||invalid_array;126" \
    "invalid_array_________null_string___invalid_index;|x|invalid_array;126" \
    "invalid_array_________null_string___bounds_index_;|-1|invalid_array;126" \
    "null_array____________valid_string__valid_index__;a|1|;127" \
    "null_array____________valid_string__null_index___;a||;127" \
    "null_array____________valid_string__invalid_index;a|x|;127" \
    "null_array____________valid_string__bounds_index_;a|-1|;127" \
    "null_array____________null_string___valid_index__;|1|;127" \
    "null_array____________null_string___null_index___;||;127" \
    "null_array____________null_string___invalid_index;|x|;127" \
    "null_array____________null_string___bounds_index_;|-1|;127"
}

@parametrize_with_array_contents() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_ARRAY_DEFINITION" \
    "simple_array__________one_char_string;a|1|simple_array;1|a|2|3" \
    "complex_array_________one_char_string;a|1|complex_array;hello<br>there|a|goodbye<br>there" \
    "empty_array___________one_char_string;a|0|empty_array;a" \
    "simple_array__________complex_string_;a<br>z|2|simple_array;1|2|a<br>z|3" \
    "complex_array_________complex_string_;a<br>z|2|complex_array;hello<br>there|goodbye<br>there|a<br>z" \
    "empty_array___________complex_string_;a<br>z|0|empty_array;a<br>z" \
    "simple_array__________empty_string___;|2|simple_array;1|2||3" \
    "complex_array_________empty_string___;|0|complex_array;|hello<br>there|goodbye<br>there" \
    "empty_array___________empty_string___;|0|empty_array;|"
}

# shellcheck disable=SC2034
test_stdlib_array_mutate_insert__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.mutate.insert "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_array_mutate_insert__@vary__returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_array_mutate_insert__@vary______________updates_array_correctly() {
  local args=()
  local expected_array=()
  local expected_array_def="${TEST_EXPECTED_ARRAY_DEFINITION}"

  TEST_ARGS_DEFINITION="${TEST_ARGS_DEFINITION//'<br>'/$'\n'}"
  TEST_EXPECTED_ARRAY_DEFINITION="${TEST_EXPECTED_ARRAY_DEFINITION//'<br>'/$'\n'}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_array "|" "${TEST_EXPECTED_ARRAY_DEFINITION}"

  stdlib.array.mutate.insert "${args[@]}"

  assert_array_equals "${args[2]}" expected_array
}

@parametrize_with_array_contents \
  test_stdlib_array_mutate_insert__@vary______________updates_array_correctly
