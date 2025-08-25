#!/bin/bash

setup() {
  _mock.create getent
}

@parameterize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "extra_arg___returns_status_code_127;group1|extra_arg;127" \
    "no_args_____returns_status_code___0;;0"
}

test_security_get_euid__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.get.euid "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parameterize_with_arg_combos \
  test_security_get_euid__@vary

test_security_get_euid__valid_args__returns_expected_value() {
  _capture.stdout stdlib.security.get.euid

  assert_output "$(id -u)"
}
