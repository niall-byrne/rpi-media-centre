#!/bin/bash

@parametrize_with_invalid_args() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________________________127;;127" \
    "extra_arg_____________________________127;test string| |extra_arg;127" \
    "null_string_and_valid_separator_______127;| ;127" \
    "valid_string_and_null_separator_________0;test string||;0" \
    "valid_string_and_no_separator___________0;test string|;0" \
    "valid_string_and_valid_separator________0;test string| |;0"
}

@parametrize_with_valid_strings() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "no_args__default_separator_______________;arg1|;1(arg1)" \
    "single_arg__default_separator____________;arg1|;1(arg1)" \
    "dual_args__default_separator_____________;arg1 arg2|;1(arg1) 2(arg2)" \
    "three_args__default_separator____________;arg1 arg2 arg3|;1(arg1) 2(arg2) 3(arg3)" \
    "no_args__custom_separator________________;arg1|!;1(arg1)" \
    "single_arg__custom_separator_____________;arg1|!;1(arg1)" \
    "dual_args__custom_separator______________;arg1!arg2|!;1(arg1) 2(arg2)" \
    "three_args__custom_separator_____________;arg1!arg2!arg3|!;1(arg1) 2(arg2) 3(arg3)"
}

test_stdlib_testing_mock_arg_string_from_string__@vary__returns_expected_status_code() {
  local args=()

  _mock.create stdlib.testing.internal.logger.error
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc _mock.arg_string.from_string "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_mock_arg_string_from_string__@vary__returns_expected_status_code

test_stdlib_testing_mock_arg_string_from_string__@vary__generates_correct_arg_string() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _mock.arg_string.from_string "${args[@]}"

  assert_output "${TEST_EXPECTED_STDOUT}"
}

@parametrize_with_valid_strings \
  test_stdlib_testing_mock_arg_string_from_string__@vary__generates_correct_arg_string

test_stdlib_testing_mock_arg_string_from_array__dual_args_with_new_lines__generates_correct_arg_string() {
  _capture.stdout _mock.arg_string.from_string "arg"$'\n'"1 arg2" " "

  assert_output "1(arg
1) 2(arg2)"
}
