#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "null_padding_____returns_status_code_126,|80|input_string,126" \
    "invalid_padding__returns_status_code_126,aa|80|input_string,126" \
    "null_limit_______returns_status_code_126,20||input_string,126" \
    "invalid_limit____returns_status_code_126,20|aa|input_string,126" \
    "extra_arg________returns_status_code_127,20|80|input_string|extra_arg,127" \
    "null_input_______returns_status_code___0,20|80||,0" \
    "valid_args_______returns_status_code___0,20|80|input_string,0"
}

# shellcheck disable=SC2034
test_stdlib_string_wrap__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.wrap "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_wrap__@vary

test_stdlib_string_wrap__valid_args_______arg___short_string____pad_width_10__wrap_20__correct_output() {
  TEST_EXPECTED="don't wrap"
  TEST_INPUT="don't wrap"

  _capture.output stdlib.string.wrap "10" "20" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_wrap__valid_args_______arg___wrapped_string__pad_width_10__wrap_20__correct_output() {
  TEST_EXPECTED="this is a"$'\n'"          string of"$'\n'"          text that"$'\n'"          i would"$'\n'"          like to"$'\n'"          wrap"
  TEST_INPUT="this is a string of text that i would like to wrap"

  _capture.output stdlib.string.wrap "10" "20" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_wrap__valid_args_______arg___wrapped_string__pad_width_5___wrap_20__correct_output() {
  TEST_EXPECTED="this is a"$'\n'"     string of text"$'\n'"     that i would"$'\n'"     like to wrap"
  TEST_INPUT="this is a string of text that i would like to wrap"

  _capture.output stdlib.string.wrap "5" "20" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_wrap__valid_args_______arg___wrapped_string__pad_width_10__wrap_20__cr__correct_output() {
  TEST_EXPECTED="this is a"$'\n'"          string of"$'\n'"          text"$'\n'"          that i"$'\n'"          would like"$'\n'"          to wrap"
  TEST_INPUT="this is a string of text *that i would like to wrap"

  _capture.output stdlib.string.wrap "10" "20" "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_string_wrap__null_input_______arg___wrapped_string__pad_width_10__wrap_20__cr__correct_output() {
  TEST_INPUT=""

  _capture.output stdlib.string.wrap "10" "20" "${TEST_INPUT}"

  assert_null "${TEST_OUTPUT}"
}
