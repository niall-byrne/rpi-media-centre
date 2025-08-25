#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create test_mock
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.keywords "_STDLIB_ARGS_CALLER_FN_NAME"
  keyword1="value1"
  keyword2="value2"
}

@parametrize_with_invalid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_MESSAGE_ARG_DEFINITION" \
    "null_arg_;|;126;ARRAY_VALUE_FOUND||_mock_object_keywords"
}

test_stdlib_testing_mock_object_set_keywords__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.set.keywords "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_set_keywords__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_set_keywords__@vary__generates_expected_log_messages() {
  local args=()
  local message_args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  test_mock.mock.set.keywords "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.set.keywords)"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_set_keywords__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_set_keywords__@vary__returns_correct_value() {
  local args=()
  local keyword_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS}"
  stdlib.array.make.from_string keyword_args "|" "${TEST_KEYWORD_ARGS}"

  test_mock.mock.set.keywords "${keyword_args[@]}"

  _capture.rc test_mock "${args[@]}"

  test_mock.mock.assert_called_once_with "${TEST_EXPECTED_CALL}"
}

@parametrize \
  test_stdlib_testing_mock_object_set_keywords__@vary__returns_correct_value \
  "TEST_ARGS;TEST_KEYWORD_ARGS;TEST_EXPECTED_CALL" \
  "no_args____no_keywords;;;;" \
  "one_arg____no_keywords;arg1;;1(arg1)" \
  "two_args___no_keywords;arg1|arg2;;1(arg1) 2(arg2)" \
  "one_arg____one_keyword;arg1;keyword1;1(arg1) keyword1(value1)" \
  "two_args___one_keyword;arg1|arg2;keyword1;1(arg1) 2(arg2) keyword1(value1)" \
  "two_args___two_keywords;arg1|arg2;keyword1|keyword2;1(arg1) 2(arg2) keyword1(value1) keyword2(value2)"
