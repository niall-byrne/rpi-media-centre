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
    "simple_positional__no_keywords;hello|world;;1(hello)|2(world)" \
    "simple_positional__keywords___;hello|world;kw1|kw2;1(hello)|2(world)|kw1(value1)|kw2(value2)" \
    "complex_position___no_keywords;a b|c'd|e\\\"f;;1(a b)|2(c'd)|3(e\\\"f)" \
    "complex_position___keyword____;a b|c'd|e\\\"f;kw1;1(a b)|2(c'd)|3(e\\\"f)|kw1(value1)"
}

@parametrize_with_array_keyword_arg_cases() {
  @parametrize \
    "${1}" \
    "TEST_POSITIONAL_ARGS;TEST_KEYWORD_ARGS;TEST_EXPECTED_ARRAY" \
    "simple_positional__empty_array_________;hello|world;empty_array|kw1;1(hello)|2(world)|empty_array()|kw1(value1)" \
    "simple_positional__single_element_array;hello|world;single_array|kw1;1(hello)|2(world)|single_array('element1')|kw1(value1)" \
    "simple_positional__multi_element_array_;hello|world;multi_array|kw1;1(hello)|2(world)|multi_array('element1' 'element\ 2')|kw1(value1)" \
    "simple_positional__multiple_arrays_____;hello|world;empty_array|single_array|multi_array|kw1;1(hello)|2(world)|empty_array()|single_array('element1')|multi_array('element1' 'element\ 2')|kw1(value1)"
}

# shellcheck disable=SC2034
test_stdlib_testing_mock_arg_array_from_array__string_keywords__@vary__produces_correct_result() {
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
  test_stdlib_testing_mock_arg_array_from_array__string_keywords__@vary__produces_correct_result

# shellcheck disable=SC2034
test_stdlib_testing_mock_arg_array_from_array__array_keywords___@vary__produces_correct_result() {
  local empty_array=()
  local expected_array=()
  local keyword_args=()
  local multi_array=("element1" "element 2")
  local positional_args=()
  local result_array=()
  local single_array=("element1")

  stdlib.array.make.from_string positional_args "|" "${TEST_POSITIONAL_ARGS}"
  stdlib.array.make.from_string keyword_args "|" "${TEST_KEYWORD_ARGS}"
  stdlib.array.make.from_string expected_array "|" "${TEST_EXPECTED_ARRAY}"

  __mock.arg_array.from_array result_array positional_args keyword_args

  assert_array_equals expected_array result_array
}

@parametrize_with_array_keyword_arg_cases \
  test_stdlib_testing_mock_arg_array_from_array__array_keywords___@vary__produces_correct_result

test_stdlib_testing_mock_arg_array_from_array__no_args() {
  local empty_array=()
  local expected_array=()
  local result_array=()

  __mock.arg_array.from_array result_array empty_array

  assert_array_equals result_array expected_array
}
