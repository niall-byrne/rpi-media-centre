#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "extra_args____________________returns_status_code_127;MOCK_CALL_ACTUAL_PREFIX|two|three|four|five;127" \
    "invalid_arguments_____________returns_status_code_126;INVALID_KEY;126" \
    "no_args_______________________returns_status_code_127;;127" \
    "valid_argument________________returns_status_code___0;MOCK_CALL_ACTUAL_PREFIX;0" \
    "valid_arguments_with_options__returns_status_code___0;MOCK_CALL_N_NOT_AS_EXPECTED|foo|bar;0"
}

@parametrize_with_message_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "mock_call_actual_prefix;MOCK_CALL_ACTUAL_PREFIX;Actual call" \
    "mock_call_n_not_as_expected;MOCK_CALL_N_NOT_AS_EXPECTED|mock_name|1;Mock 'mock_name' call 1 was not as expected!" \
    "mock_called_n_times;MOCK_CALLED_N_TIMES|mock_name|3;Mock 'mock_name' was called 3 times!" \
    "mock_not_called;MOCK_NOT_CALLED|mock_name;Mock 'mock_name' was not called!" \
    "mock_not_called_once_with;MOCK_NOT_CALLED_ONCE_WITH|mock_name|arg1;Mock 'mock_name' was not called once with 'arg1' !" \
    "mock_not_called_with;MOCK_NOT_CALLED_WITH|mock_name|arg1;Mock 'mock_name' was not called with 'arg1' !"
}

@parametrize_with_incorrect_arg_counts() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "mock_call_actual_prefix_________too_many_args;MOCK_CALL_ACTUAL_PREFIX|bar" \
    "mock_call_n_not_as_expected_____no_args;MOCK_CALL_N_NOT_AS_EXPECTED" \
    "mock_call_n_not_as_expected_____too_few_args;MOCK_CALL_N_NOT_AS_EXPECTED|mock_name" \
    "mock_call_n_not_as_expected_____too_many_args;MOCK_CALL_N_NOT_AS_EXPECTED|mock_name|1|foo" \
    "mock_called_n_times_____________no_args;MOCK_CALLED_N_TIMES" \
    "mock_called_n_times_____________too_few_args;MOCK_CALLED_N_TIMES|mock_name" \
    "mock_called_n_times_____________too_many_args;MOCK_CALLED_N_TIMES|mock_name|1|foo" \
    "mock_not_called_________________no_args;MOCK_NOT_CALLED" \
    "mock_not_called_________________too_many_args;MOCK_NOT_CALLED|mock_name|foo" \
    "mock_not_called_once_with_______no_args;MOCK_NOT_CALLED_ONCE_WITH" \
    "mock_not_called_once_with_______too_few_args;MOCK_NOT_CALLED_ONCE_WITH|mock_name" \
    "mock_not_called_once_with_______too_many_args;MOCK_NOT_CALLED_ONCE_WITH|mock_name|arg1|foo" \
    "mock_not_called_with____________no_args;MOCK_NOT_CALLED_WITH" \
    "mock_not_called_with____________too_few_args;MOCK_NOT_CALLED_WITH|mock_name" \
    "mock_not_called_with____________too_many_args;MOCK_NOT_CALLED_WITH|mock_name|arg1|foo"
}

# shellcheck disable=SC2034
test_stdlib_testing_mock_message_get__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc "_testing.mock.message.get" "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_testing_mock_message_get__@vary

# shellcheck disable=SC2034
test_stdlib_testing_mock_message_get__valid_argument________________@vary_____returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout "_testing.mock.message.get" "${args[@]}"

  assert_equals "${TEST_EXPECTED_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize_with_message_content \
  test_stdlib_testing_mock_message_get__valid_argument________________@vary_____returns_correct_message

test_stdlib_testing_mock_message_get__invalid_arguments_____________returns_error_message() {
  _capture.stdout "_testing.mock.message.get" "NON_EXISTENT_KEY"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Unknown message key 'NON_EXISTENT_KEY')"
}

# shellcheck disable=SC2034
test_stdlib_testing_mock_message_get__invalid_arg_count_____________@vary__returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout "_testing.mock.message.get" "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Invalid arguments provided!)"
}

@parametrize_with_incorrect_arg_counts \
  test_stdlib_testing_mock_message_get__invalid_arg_count_____________@vary__returns_correct_message
