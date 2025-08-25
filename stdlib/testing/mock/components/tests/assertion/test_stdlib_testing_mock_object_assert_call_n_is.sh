#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.keywords "_STDLIB_ARGS_CALLER_FN_NAME"
  keyword1="value1"
  keyword2="value2"
}

@parametrize_with_invalid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_MESSAGE_ARG_DEFINITIONS" \
    "no_args___________;;127;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg_________;1|1(expected call)|extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|3" \
    "index_is_invalid__;a|1(expected call);126;IS_NOT_DIGIT|a" \
    "index_is_zero_____;0|1(expected call);126;IS_EQUAL|0"
}

test_stdlib_testing_mock_object_assert_call_n_is__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.assert_call_n_is "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_call_n_is__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_assert_call_n_is__@vary__generates_expected_log_messages() {
  local args=()
  local expected_log_messages=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_arg_definitions " " "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    stdlib.array.make.from_string message_args "|" "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.assert_call_n_is)")
  done

  test_mock.mock.assert_call_n_is "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_call_n_is__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________no_keywords____no_calls__assert_call_1__fails() {
  _mock.create test_mock

  _capture_assertion_failure test_mock.mock.assert_call_n_is "1" "1(called)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "0")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________with_keywords__no_calls__assert_call_1__fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"

  _capture_assertion_failure test_mock.mock.assert_call_n_is "1" "1(called)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "0")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________no_keywords____2_calls___assert_call_1__fails() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "1" "1(arg1)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [1(arg1)] but was [1(arg1) 2(arg2)]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________with_keywords__2_calls___assert_call_1__fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "1" "1(arg1)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [1(arg1)] but was [1(arg1) 2(arg2) keyword1(value1) keyword2(value2)]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________no_keywords____2_calls___assert_call_2__fails() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "2" ""

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "2")
 expected [] but was [1(arg1) 2(arg2)]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________with_keywords__2_calls___assert_call_2__fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "2" ""

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "2")
 expected [] but was [1(arg1) 2(arg2) keyword1(value1) keyword2(value2)]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________no_keywords____2_calls___assert_call_3__fails() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "3" "1(arg1) 2(arg2)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "2")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________with_keywords__2_calls___assert_call_3__fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture_assertion_failure test_mock.mock.assert_call_n_is "3" "1(arg1) 2(arg2)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "2")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________no_keywords____3_calls___assert_call_1__succeeds() {
  _mock.create test_mock
  test_mock
  test_mock

  test_mock.mock.assert_call_n_is "1" ""
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________with_keywords__3_calls___assert_call_1__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock
  test_mock

  test_mock.mock.assert_call_n_is "1" "keyword1(value1) keyword2(value2)"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________no_keywords____3_calls___assert_call_2__succeeds() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_call_n_is "2" "1(arg1) 2(arg2) 3(successful)"
}

test_stdlib_testing_mock_object_assert_call_n_is__valid_args__________with_keywords__3_calls___assert_call_2__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_call_n_is "2" "1(arg1) 2(arg2) 3(successful) keyword1(value1) keyword2(value2)"
}
