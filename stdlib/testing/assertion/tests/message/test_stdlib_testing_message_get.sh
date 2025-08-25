#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________________returns_status_code_127;;127" \
    "extra_args____________________returns_status_code_127;ASSERT_ERROR_OUTPUT_NULL|two|three|four|five;127" \
    "invalid_arguments_____________returns_status_code_126;INVALID_KEY;126" \
    "valid_argument________________returns_status_code___0;ASSERT_ERROR_OUTPUT_NULL;0" \
    "valid_arguments_with_options__returns_status_code___0;ASSERT_ERROR_FILE_NOT_FOUND|foo;0"
}

@parametrize_with_message_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "assert_file_not_found;ASSERT_ERROR_FILE_NOT_FOUND|bar;the file 'bar' does not exist" \
    "assert_output_non_matching;ASSERT_ERROR_OUTPUT_NON_MATCHING;the expected output string was not generated" \
    "assert_output_null;ASSERT_ERROR_OUTPUT_NULL;the 'TEST_OUTPUT' value is empty, consider using '_capture.output'" \
    "assert_rc_non_matching;ASSERT_ERROR_RC_NON_MATCHING;the expected status code was not returned" \
    "assert_rc_null;ASSERT_ERROR_RC_NULL;the 'TEST_RC' value is empty, consider using '_capture.rc'" \
    "assert_snapshot_non_matching;ASSERT_ERROR_SNAPSHOT_NON_MATCHING|bazz;the contents of 'bazz' does not match the received output" \
    "assert_value_not_null;ASSERT_ERROR_VALUE_NOT_NULL|buzz;The value 'buzz' is not null!" \
    "assert_value_null;ASSERT_ERROR_VALUE_NULL;The value is null!"
}

@parametrize_with_incorrect_arg_counts() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "assert_file_not_found_________no_args;ASSERT_ERROR_FILE_NOT_FOUND" \
    "assert_file_not_found_________too_many_args;ASSERT_ERROR_FILE_NOT_FOUND|bar|bazz" \
    "assert_output_non_matching____too_many_args;ASSERT_ERROR_OUTPUT_NON_MATCHING|too|many" \
    "assert_output_null____________too_many_args;ASSERT_ERROR_OUTPUT_NULL|too|many" \
    "assert_rc_non_matching________too_many_args;ASSERT_ERROR_RC_NON_MATCHING|too|many" \
    "assert_rc_null________________too_many_args;ASSERT_ERROR_RC_NULL|too|many" \
    "assert_snapshot_non_matching__no_args;ASSERT_ERROR_SNAPSHOT_NON_MATCHING" \
    "assert_snapshot_non_matching__too_many_args;ASSERT_ERROR_SNAPSHOT_NON_MATCHING|bar|bazz" \
    "assert_value_not_null_________no_args;ASSERT_ERROR_VALUE_NOT_NULL" \
    "assert_value_not_null_________too_many_args;ASSERT_ERROR_VALUE_NOT_NULL|bar|bazz" \
    "assert_value_null_____________too_many_args;ASSERT_ERROR_VALUE_NULL|too|many"
}

# shellcheck disable=SC2034
test_stdlib_testing_message_get__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc "_testing.assert.message.get" "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_testing_message_get__@vary

# shellcheck disable=SC2034
test_stdlib_testing_message_get__valid_argument________________@vary_____returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout "_testing.assert.message.get" "${args[@]}"

  assert_equals "${TEST_EXPECTED_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize_with_message_content \
  test_stdlib_testing_message_get__valid_argument________________@vary_____returns_correct_message

test_stdlib_testing_message_get__invalid_arguments_____________returns_error_message() {
  _capture.stdout "_testing.assert.message.get" "NON_EXISTENT_KEY"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Unknown message key 'NON_EXISTENT_KEY')"
}

# shellcheck disable=SC2034
test_stdlib_testing_message_get__invalid_arg_count_____________@vary__returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout "_testing.assert.message.get" "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Invalid arguments provided!)"
}

@parametrize_with_incorrect_arg_counts \
  test_stdlib_testing_message_get__invalid_arg_count_____________@vary__returns_correct_message
