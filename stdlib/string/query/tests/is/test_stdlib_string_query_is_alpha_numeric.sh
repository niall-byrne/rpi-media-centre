#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127;;127" \
    "extra_arg__________returns_status_code_127;AA|extra_arg;127" \
    "empty_string_______returns_status_code_126;|;126" \
    "symbol_____________returns_status_code___1;@#!;1" \
    "mixed______________returns_status_code___1;Aa@33aaB;1" \
    "numeric____________returns_status_code___0;0123456789;0" \
    "lowercase__________returns_status_code___0;abcdefghijklmnopqrstuvwxyz;0" \
    "uppercase__________returns_status_code___0;ABCDEFGHIJKLMNOPQRSTUVWXYZ;0" \
    "lower_and_upper____returns_status_code___0;abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;0" \
    "alpha_numeric_mix__returns_status_code___0;0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_is_alpha_numeric__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.is_alpha_numeric "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_is_alpha_numeric__@vary
