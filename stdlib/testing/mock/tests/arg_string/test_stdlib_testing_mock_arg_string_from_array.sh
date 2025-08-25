#!/bin/bash

# shellcheck disable=SC2034
setup() {
  TEST_ARRAY_1=("1" "2" "3")
  TEST_ARRAY_2=("4" "5" "6")
  NOT_AN_ARRAY="1234"

  keyword1=""
  keyword2="2"
  keyword3="alpha beta"
  keyword_with_cr="key"$'\n'"word"
}

@parametrize_with_invalid_args() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "extra_arg_________________________127;TEST_ARRAY_1|TEST_ARRAY_2|extra_arg;127" \
    "no_array_1_______no_array_2_______127;;127" \
    "no_array_1_______invalid_array_2__127;|NOT_AN_ARRAY;127" \
    "no_array_1_______valid_array_2____127;|TEST_ARRAY_2;127" \
    "invalid_array_1__no_array_2_______126;NOT_AN_ARRAY;126" \
    "invalid_array_1__invalid_array_2__126;NOT_AN_ARRAY|NOT_AN_ARRAY;126" \
    "invalid_array_1__valid_array_2____126;NOT_AN_ARRAY|TEST_ARRAY_2;126" \
    "valid_array_1____no_array_2_________0;TEST_ARRAY_1;0" \
    "valid_array_1____invalid_array_2__126;TEST_ARRAY_1|NOT_AN_ARRAY;126" \
    "valid_array_1____valid_array_2______0;TEST_ARRAY_1|TEST_ARRAY_2;0"
}

@parametrize_with_valid_arrays() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_ARRAY_DEFINITION;TEST_KEYWORDS_ARRAY_DEFINITION;TEST_EXPECTED_STDOUT" \
    "single_arg_____________________;arg1;;1(arg1)" \
    "dual_args______________________;arg1|arg2;;1(arg1) 2(arg2)" \
    "three_args_____________________;arg1|arg2|arg3;;1(arg1) 2(arg2) 3(arg3)" \
    "single_arg_______single_keyword;arg1;keyword1;1(arg1) keyword1()" \
    "dual_args________dual_keywords_;arg1|arg2;keyword1|keyword2;1(arg1) 2(arg2) keyword1() keyword2(2)" \
    "three_args_______three_keywords;arg1|arg2|arg3;keyword1|keyword2|keyword3;1(arg1) 2(arg2) 3(arg3) keyword1() keyword2(2) keyword3(alpha beta)"
}

test_stdlib_testing_mock_arg_string_from_array__@vary__returns_expected_status_code() {
  local args=()

  _mock.create stdlib.testing.internal.logger.error
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc _mock.arg_string.from_array "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_mock_arg_string_from_array__@vary__returns_expected_status_code

test_stdlib_testing_mock_arg_string_from_array__@vary________generates_correct_arg_string() {
  local args_array=()
  local keywords_array=()

  stdlib.array.make.from_string args_array "|" "${TEST_ARGS_ARRAY_DEFINITION}"
  stdlib.array.make.from_string keywords_array "|" "${TEST_KEYWORDS_ARRAY_DEFINITION}"

  _capture.stdout _mock.arg_string.from_array args_array keywords_array

  assert_output "${TEST_EXPECTED_STDOUT}"
}

@parametrize_with_valid_arrays \
  test_stdlib_testing_mock_arg_string_from_array__@vary________generates_correct_arg_string

test_stdlib_testing_mock_arg_string_from_array__no_args________________________________generates_correct_arg_string() {
  local args_array=()

  _capture.stdout _mock.arg_string.from_array args_array

  assert_output_null
}

test_stdlib_testing_mock_arg_string_from_array__dual_args_cr_____no_keywords___________generates_correct_arg_string() {
  local args_array=("arg"$'\n'"1" "arg2")

  _capture.stdout _mock.arg_string.from_array args_array

  assert_output "1(arg
1) 2(arg2)"
}

test_stdlib_testing_mock_arg_string_from_array__dual_args_cr_____one_keyword_cr________generates_correct_arg_string() {
  local args_array=("arg"$'\n'"1" "arg2")
  local keywords_array=("keyword_with_cr")

  _capture.stdout _mock.arg_string.from_array args_array keywords_array

  assert_output "1(arg
1) 2(arg2) keyword_with_cr(key
word)"
}
