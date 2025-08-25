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
    "no_args___;;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg_;1(expected call)|extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|2"
}

@parametrize_with_no_keywords() {
  # $1: the test function to parametrize

  _PARAMETRIZE_FIELD_SEPARATOR="," @parametrize \
    "${1}" \
    "TEST_KEYWORDS,TEST_VALUE,TEST_ARG_STRING" \
    "simple__digit____,,1,1(1)" \
    "complex_digit____,,1000,1(1000)" \
    "empty___simple___,,,1()" \
    "simple__string___,,simple,1(simple)" \
    "complex_string1__,,three<br>three,1(three<br>three)" \
    "complex_string2__,,two; two~~',1(two; two~~')"
}

@parametrize_with_keywords() {
  # $1: the test function to parametrize

  _PARAMETRIZE_FIELD_SEPARATOR="," @parametrize \
    "${1}" \
    "TEST_KEYWORDS,TEST_VALUE,TEST_ARG_STRING" \
    "simple__digit____,keyword1,1,1(1) keyword1(value1)" \
    "complex_digit____,keyword2,1000,1(1000) keyword2(value2)" \
    "empty___simple___,keyword1|keyword2,,1() keyword1(value1) keyword2(value2)" \
    "simple__string___,keyword1,simple,1(simple) keyword1(value1)" \
    "complex_string1__,keyword2,three<br>three,1(three<br>three) keyword2(value2)" \
    "complex_string2__,keyword1|keyword2,two; two~~',1(two; two~~') keyword1(value1) keyword2(value2)"
}

test_stdlib_testing_mock_object_assert_called_once_with__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.assert_called_once_with "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_called_once_with__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_assert_called_once_with__@vary__generates_expected_log_messages() {
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
    expected_log_messages+=("1($(stdlib.message.get "${message_args[@]}")) _STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.assert_called_once_with)")
  done

  test_mock.mock.assert_called_once_with "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_called_once_with__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___no_args______no_keywords________succeeds() {
  local keywords=()

  _mock.create test_mock

  test_mock

  test_mock.mock.assert_called_once_with ""
}

test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___no_args______with_keywords______succeeds() {
  local keywords=()

  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"

  test_mock

  test_mock.mock.assert_called_once_with "keyword1(value1) keyword2(value2)"
}

test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___no_args______no_keywords________fails() {
  local keywords=()

  _mock.create test_mock

  test_mock

  _capture_assertion_failure test_mock.mock.assert_called_once_with "1(arg1)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALL_ACTUAL_PREFIX): []
$(_testing.mock.message.get MOCK_NOT_CALLED_ONCE_WITH "test_mock" "1(arg1)")
 expected [1] but was [0]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___no_args______with_keywords______fails() {
  local keywords=()

  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"

  test_mock

  _capture_assertion_failure test_mock.mock.assert_called_once_with "1(arg1)"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALL_ACTUAL_PREFIX): [keyword1(value1) keyword2(value2)]
$(_testing.mock.message.get MOCK_NOT_CALLED_ONCE_WITH "test_mock" "1(arg1)")
 expected [1] but was [0]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___@vary__@vary__succeeds() {
  local keywords=()

  stdlib.array.make.from_string keywords "|" "${TEST_KEYWORDS}"
  _mock.create test_mock
  test_mock.mock.set.keywords "${keywords[@]}"

  test_mock "${TEST_VALUE}"

  test_mock.mock.assert_called_once_with "${TEST_ARG_STRING}"
}

@parametrize.apply \
  test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___@vary__@vary__succeeds \
  @parametrize_with_no_keywords \
  @parametrize_with_keywords

test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___@vary__@vary__fails() {
  local expected_call="1(non matching value)"
  local keyword_string
  local keywords=()

  stdlib.array.make.from_string keywords "|" "${TEST_KEYWORDS}"
  _mock.create test_mock
  test_mock.mock.set.keywords "${keywords[@]}"
  for keyword_string in "${keywords[@]}"; do
    expected_call+=" ${keyword_string}(${!keyword_string})"
  done

  test_mock "non matching value"

  _capture_assertion_failure test_mock.mock.assert_called_once_with "${TEST_ARG_STRING}"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALL_ACTUAL_PREFIX): [${expected_call}]
$(_testing.mock.message.get MOCK_NOT_CALLED_ONCE_WITH "test_mock" "${TEST_ARG_STRING}")
 expected [1] but was [0]" \
    "${TEST_OUTPUT}"
}

@parametrize.apply \
  test_stdlib_testing_mock_object_assert_called_once_with__valid_args__called_1_time___@vary__@vary__fails \
  @parametrize_with_no_keywords \
  @parametrize_with_keywords

test_stdlib_testing_mock_object_assert_called_once_with__valid_args__@vary_______fails() {
  _mock.create test_mock
  test_mock 2
  test_mock 2
  test_mock 3
  test_mock 3
  test_mock 3

  _capture_assertion_failure test_mock.mock.assert_called_once_with "${TEST_ARG_STRING}"

  assert_equals \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "5")"$'\n'" expected [1] but was [5]" \
    "${TEST_OUTPUT}"
}

_PARAMETRIZE_FIELD_SEPARATOR="," @parametrize \
  test_stdlib_testing_mock_object_assert_called_once_with__valid_args__@vary_______fails \
  "TEST_ARG_STRING,EXPECTED_COUNT" \
  "not_called______no_keywords__empty_string,,0" \
  "not_called______no_keywords__string______,1(0),0" \
  "called_2_times__no_keywords__number______,1(2),2" \
  "called_3_times__no_keywords__string______,1(3),3"
