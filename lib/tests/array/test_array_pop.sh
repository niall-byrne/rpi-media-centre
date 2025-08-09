#!/bin/bash

test_array_pop__has_simple_values__returns_last_value() {
  local TEST_ARRAY=("1" "2" "3")
  local _ARRAY_BUFFER=""

  eval "$(_array_pop TEST_ARRAY _ARRAY_BUFFER)"

  assert_equals "3" "${_ARRAY_BUFFER}"
}

test_array_pop__has_simple_values__resizes_array() {
  local TEST_ARRAY=("1" "2" "3")
  local _ARRAY_BUFFER

  eval "$(_array_pop TEST_ARRAY _ARRAY_BUFFER)"

  assert_equals "2" "${#TEST_ARRAY[@]}"
}

test_array_pop__has_complex_values__returns_last_value() {
  local TEST_ARRAY=("1;  \$hello1"$'\n' "2;  \$hello2"$'\n' "3;  \$hello3"$'\n')
  local _ARRAY_BUFFER=""

  eval "$(_array_pop TEST_ARRAY _ARRAY_BUFFER)"

  assert_equals "3;  \$hello3"$'\n' "${_ARRAY_BUFFER}"
}

test_array_pop__has_complex_values__resizes_array() {
  local TEST_ARRAY=("1;  \$hello1"'$\n' "2;  \$hello2"'$\n' "3;  \$hello3"'$\n')
  local _ARRAY_BUFFER

  eval "$(_array_pop TEST_ARRAY _ARRAY_BUFFER)"

  assert_equals "2" "${#TEST_ARRAY[@]}"
}

test_array_pop__has_one_value__returns_last_value() {
  local TEST_ARRAY=("1")
  local _ARRAY_BUFFER=""

  eval "$(_array_pop TEST_ARRAY _ARRAY_BUFFER)"

  assert_equals "1" "${_ARRAY_BUFFER}"
}

test_array_pop__has_one_value__resizes_array() {
  local TEST_ARRAY=("1")
  local _ARRAY_BUFFER

  eval "$(_array_pop TEST_ARRAY _ARRAY_BUFFER)"

  assert_equals "0" "${#TEST_ARRAY[@]}"
}
