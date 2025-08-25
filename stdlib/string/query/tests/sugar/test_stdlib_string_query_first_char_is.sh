#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________returns_status_code_127;;127" \
    "null_string_______returns_status_code_126;a||;126" \
    "null_char_________returns_status_code_126;|abcd;126" \
    "invalid_char______returns_status_code_126;aa|abcd;126" \
    "extra_arg_________returns_status_code_127;a|abcd|extra_arg;127" \
    "char_not_present__returns_status_code___1;b|abcd;1" \
    "char_present______returns_status_code___1;a|abcd;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_first_char_is__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.first_char_is "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_first_char_is__@vary
