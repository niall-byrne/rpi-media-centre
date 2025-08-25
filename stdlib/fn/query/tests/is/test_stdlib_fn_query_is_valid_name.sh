#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;AA|extra_arg;127" \
    "empty_string_____returns_status_code_126;|;126" \
    "subshell_________returns_status_code___1;\\\$(echo shell);1" \
    "ampersand________returns_status_code___1;function1 & function 2;1" \
    "glob_____________returns_status_code___1;function1*;1" \
    "semicolon________returns_status_code___1;function1*;1" \
    "space____________returns_status_code___1;function 1;1" \
    "valid_name_______returns_status_code___0;@valid_FUNCTION-name.1;0"
}

# shellcheck disable=SC2034
test_stdlib_fn_is_valid_name__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.query.is_valid_name "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_is_valid_name__@vary
