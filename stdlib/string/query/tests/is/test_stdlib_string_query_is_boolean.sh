#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127;;127" \
    "extra_arg__________returns_status_code_127;1|extra_arg;127" \
    "empty_string_______returns_status_code_126;|;126" \
    "alphanumeric_______returns_status_code___1;aa011;1" \
    "non_boolean_digit__returns_status_code___1;3;1" \
    "boolean_off________returns_status_code___0;0;0" \
    "boolean_on_________returns_status_code___0;1;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_is_boolean__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.is_boolean "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_is_boolean__@vary
