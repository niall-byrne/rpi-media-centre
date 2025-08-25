#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127;;127" \
    "extra_arg_____________returns_status_code_127;*|match|extra_arg;127" \
    "null_regex____________returns_status_code_126;|input_string;126" \
    "null_input____________returns_status_code_126;.*||;126" \
    "regex_does_not_match__returns_status_code___1;not match|match;1" \
    "regex_matches_________returns_status_code___0;.*|match;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_is_regex_match__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.is_regex_match "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_is_regex_match__@vary
