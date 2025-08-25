#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________returns_status_code_127;;127" \
    "extra_arg_________returns_status_code_127;a|1|input|extra_arg;127" \
    "null_string_______returns_status_code_126;a|1||;126" \
    "null_char_________returns_status_code_126;|1|input;126" \
    "null_index________returns_status_code_126;a||input;126" \
    "char_not_present__returns_status_code___1;a|2|abc;1" \
    "char_first________returns_status_code___0;a|0|abc;0" \
    "char_last_________returns_status_code___0;c|2|abc;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_has_char_n__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.has_char_n "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_has_char_n__@vary
