#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.security.get.euid
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_EUID;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "extra_arg______returns_status_code_127;0;extra_arg;127" \
    "euid_is_not_0__returns_status_code___1;1;;1" \
    "euid_is_0______returns_status_code___0;0;;0"
}

# shellcheck disable=SC2034
test_stdlib_security_user_query_is_root__@vary() {
  local args=()

  stdlib.security.get.euid.mock.set.stdout "${TEST_EUID}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.user.query.is_root "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_security_user_query_is_root__@vary
