#!/bin/bash

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
    "extra_arg_;extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|0|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|1"
}

test_stdlib_testing_mock_object_get_calls__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.get.calls "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_get_calls__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_get_calls__@vary__generates_expected_log_messages() {
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
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.get.calls)")
  done

  test_mock.mock.get.calls "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_get_calls__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_get_calls__valid_args__not_called___________________no_keywords____returns_correct_value() {
  _mock.create test_mock

  assert_null "$(test_mock.mock.get.calls)"
}

test_stdlib_testing_mock_object_get_calls__valid_args__not_called___________________with_keywords__returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"

  assert_null "$(test_mock.mock.get.calls)"
}

test_stdlib_testing_mock_object_get_calls__valid_args__called_with_digits___________no_keywords____returns_correct_value() {
  _mock.create test_mock
  test_mock 1 2 3
  test_mock 4 5 6

  assert_equals "1(1) 2(2) 3(3)"$'\n'"1(4) 2(5) 3(6)" "$(test_mock.mock.get.calls)"
}

test_stdlib_testing_mock_object_get_calls__valid_args__called_with_digits___________with_keywords__returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock 1 2 3
  test_mock 4 5 6

  assert_equals \
    "1(1) 2(2) 3(3) keyword1(value1) keyword2(value2)"$'\n'"1(4) 2(5) 3(6) keyword1(value1) keyword2(value2)" \
    "$(test_mock.mock.get.calls)"
}

test_stdlib_testing_mock_object_get_calls__valid_args__called_with_simple_strings___no_keywords____returns_correct_value() {
  _mock.create test_mock
  test_mock "one two" "three"
  test_mock "four five" "six"

  assert_equals "1(one two) 2(three)"$'\n'"1(four five) 2(six)" "$(test_mock.mock.get.calls)"
}

test_stdlib_testing_mock_object_get_calls__valid_args__called_with_simple_strings___with_keywords__returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock "one two" "three"
  test_mock "four five" "six"

  assert_equals \
    "1(one two) 2(three) keyword1(value1) keyword2(value2)"$'\n'"1(four five) 2(six) keyword1(value1) keyword2(value2)" \
    "$(test_mock.mock.get.calls)"
}

test_stdlib_testing_mock_object_get_calls__valid_args__called_with_complex_strings__no_keywords____returns_correct_value() {
  _mock.create test_mock
  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  assert_equals \
    "1(call 1; call1
call1 call1 \'\";)
1(call 2; call2
call2 call2 \'\";)
1(call 3; call3
call3 call3 \'\";)" \
    "$(test_mock.mock.get.calls)"
}

test_stdlib_testing_mock_object_get_calls__valid_args__called_with_complex_strings__with_keywords__returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  assert_equals \
    "1(call 1; call1
call1 call1 \'\";) keyword1(value1) keyword2(value2)
1(call 2; call2
call2 call2 \'\";) keyword1(value1) keyword2(value2)
1(call 3; call3
call3 call3 \'\";) keyword1(value1) keyword2(value2)" \
    "$(test_mock.mock.get.calls)"
}
