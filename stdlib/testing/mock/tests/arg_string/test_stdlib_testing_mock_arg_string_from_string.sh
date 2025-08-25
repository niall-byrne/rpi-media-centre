#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  kw1="value1"
  kw2="value2"
  empty_array=()
  keywords=("kw1" "kw2")
}

@parametrize_with_invalid_args() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_SEPERATOR;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_________________________________________127;;;127" \
    "extra_arg_______________________________________127; ;test string|empty_array|extra_arg;127" \
    "null_string___no_array_________valid_separator__127; ;|;127" \
    "null_string___invalid_array____valid_separator__127; ;|invalid_array;127" \
    "null_string___valid_array______valid_separator__127; ;|empty_array;127" \
    "valid_string__no_array_________null_separator_____0;;test string;0" \
    "valid_string__invalid_array____null_separator___126;;test string|invalid_array;126" \
    "valid_string__valid_array______null_separator_____0;;test string|empty_array;0" \
    "valid_string__no_array_________valid_separator____0; ;test string;0" \
    "valid_string__invalid_array____valid_separator__126; ;test string|invalid_array;126" \
    "valid_string__valid_array______valid_separator____0; ;test string|empty_array;0"
}

@parametrize_with_valid_strings() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_SEPERATOR;TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "no_args__default_separator_____no_keywords_________;;arg1|;1(arg1)" \
    "no_args__default_separator_____keywords____________;;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "single_arg__default_separator__no_keywords_________;;arg1|;1(arg1)" \
    "single_arg__default_separator__keywords____________;;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "dual_args__default_separator___no_keywords_________;;arg1 arg2|;1(arg1) 2(arg2)" \
    "dual_args__default_separator___keywords____________;;arg1 arg2|keywords;1(arg1) 2(arg2) kw1(value1) kw2(value2)" \
    "three_args__default_separator__no_keywords_________;;arg1 arg2 arg3|;1(arg1) 2(arg2) 3(arg3)" \
    "three_args__default_separator__keywords____________;;arg1 arg2 arg3|keywords;1(arg1) 2(arg2) 3(arg3) kw1(value1) kw2(value2)" \
    "no_args__custom_separator______no_keywords_________;!;arg1;1(arg1)" \
    "no_args__custom_separator______keywords____________;!;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "single_arg__custom_separator___no_keywords_________;!;arg1;1(arg1)" \
    "single_arg__custom_separator___keywords____________;!;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "dual_args__custom_separator____no_keywords_________;!;arg1!arg2;1(arg1) 2(arg2)" \
    "dual_args__custom_separator____keywords____________;!;arg1!arg2|keywords;1(arg1) 2(arg2) kw1(value1) kw2(value2)" \
    "three_args__custom_separator___no_keywords_________;!;arg1!arg2!arg3;1(arg1) 2(arg2) 3(arg3)" \
    "three_args__custom_separator___keywords____________;!;arg1!arg2!arg3|keywords;1(arg1) 2(arg2) 3(arg3) kw1(value1) kw2(value2)"
}

test_stdlib_testing_mock_arg_string_from_string__@vary__returns_expected_status_code() {
  local args=()
  [[ "${TEST_SEPERATOR}" != "" ]] && local _STDLIB_DELIMITER="${TEST_SEPERATOR}"

  _mock.create stdlib.testing.internal.logger.error
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc _mock.arg_string.from_string "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_mock_arg_string_from_string__@vary__returns_expected_status_code

test_stdlib_testing_mock_arg_string_from_string__@vary__generates_correct_arg_string() {
  local args=()
  [[ "${TEST_SEPERATOR}" != "" ]] && local _STDLIB_DELIMITER="${TEST_SEPERATOR}"

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _mock.arg_string.from_string "${args[@]}"

  assert_output "${TEST_EXPECTED_STDOUT}"
}

@parametrize_with_valid_strings \
  test_stdlib_testing_mock_arg_string_from_string__@vary__generates_correct_arg_string

test_stdlib_testing_mock_arg_string_from_string__dual_args_with_new_lines_______no_keywords___________generates_correct_arg_string() {
  _capture.stdout _mock.arg_string.from_string "arg"$'\n'"1 arg2"

  assert_output "1(arg
1) 2(arg2)"
}
