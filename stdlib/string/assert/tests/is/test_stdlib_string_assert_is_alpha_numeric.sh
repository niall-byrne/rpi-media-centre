#!/bin/bash

#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127,,127" \
    "extra_arg__________returns_status_code_127,AA|extra_arg,127" \
    "empty_string_______returns_status_code_126,|,126" \
    "symbols_present____returns_status_code___1,@#!,1" \
    "mixed______________returns_status_code___1,Aa@33aaB,1" \
    "numeric____________returns_status_code___0,0123456789,0" \
    "lowercase__________returns_status_code___0,abcdefghijklmnopqrstuvwxyz,0" \
    "uppercase__________returns_status_code___0,ABCDEFGHIJKLMNOPQRSTUVWXYZ,0" \
    "lower_and_upper____returns_status_code___0,abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,0" \
    "alpha_numeric_mix__returns_status_code___0,0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,0"
}
@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION,TEST_EXPECTED_LOG_MESSAGE" \
    "no_args__________,,Invalid arguments provided!," \
    "extra_arg________,1|extra_arg,Invalid arguments provided!," \
    "empty_string_____,|,The value '' is not a set alpha-numeric only string!" \
    "symbols_present__,*&^aabb001,The value '*&^aabb001' is not a set alpha-numeric only string!"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_alpha_numeric__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_alpha_numeric "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_alpha_numeric__@vary

test_stdlib_string_assert_is_alpha_numeric__@vary__logs_an_error() {
  local args=()
  local expected_log_messages=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra expected_log_messages <<< "${TEST_EXPECTED_LOG_MESSAGE}"

  _capture.rc stdlib.string.assert.is_alpha_numeric "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_alpha_numeric__@vary__logs_an_error
