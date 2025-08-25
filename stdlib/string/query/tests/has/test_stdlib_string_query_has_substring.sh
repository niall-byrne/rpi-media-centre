#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args________________returns_status_code_127;;127" \
    "extra_arg______________returns_status_code_127;a|input|extra_arg;127" \
    "null_string____________returns_status_code_126;a||;126" \
    "null_substring_________returns_status_code_126;|1;126" \
    "substring_not_present__returns_status_code___1;d|abc;1" \
    "substring_present______returns_status_code___1;a|abc;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_has_substring__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.has_substring "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_has_substring__@vary
