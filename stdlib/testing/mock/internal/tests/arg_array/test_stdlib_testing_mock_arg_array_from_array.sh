#!/bin/bash

# shellcheck disable=SC2034
setup() {
  kw1="value1"
  kw2="value2"
}

@parametrize_with_arg_array_cases() {
  @parametrize \
    "${1}" \
    "TEST_POSITIONAL_ARGS;TEST_KEYWORD_ARGS;TEST_EXPECTED_ARRAY" \
    "positional_only;hello|world;;1(hello)|2(world)" \
    "positional_and_keyword;hello|world;kw1|kw2;1(hello)|2(world)|kw1(value1)|kw2(value2)" \
    "special_chars;a b|c'd|e\\\"f;;1(a b)|2(c'd)|3(e\\\"f)"
}

# shellcheck disable=SC2034
test_stdlib_testing_mock_arg_array_from_array__@vary() {
  local expected_array=()
  local keyword_args=()
  local positional_args=()
  local result_array=()

  stdlib.array.make.from_string positional_args "|" "${TEST_POSITIONAL_ARGS}"
  stdlib.array.make.from_string keyword_args "|" "${TEST_KEYWORD_ARGS}"
  stdlib.array.make.from_string expected_array "|" "${TEST_EXPECTED_ARRAY}"

  __mock.arg_array.from_array result_array positional_args keyword_args

  assert_array_equals expected_array result_array
}

@parametrize_with_arg_array_cases \
  test_stdlib_testing_mock_arg_array_from_array__@vary

test_stdlib_testing_mock_arg_array_from_array__no_args() {
  local empty_array=()
  local expected_array=()
  local result_array=()

  __mock.arg_array.from_array result_array empty_array

  assert_array_equals result_array expected_array
}
