#!/bin/bash

setup() {
  _mock.create mkdir
  _mock.create stdlib.security.path.secure
}

@parametrize_with_invalid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____returns_status_code_127;;127" \
    "extra_args__returns_status_code_127;/etc|user1|group1|644|extra_arg;127" \
    "null_path___returns_status_code_126;|user1|group1|644;126" \
    "null_owner__returns_status_code_126;/etc||group1|644;126" \
    "null_group__returns_status_code_126;/etc|user1||644;126" \
    "null_perms__returns_status_code_126;/etc|user1|group1||;126"
}

test_stdlib_security_path_make_dir__invalid_args__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.path.make.dir "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_security_path_make_dir__invalid_args__@vary

test_stdlib_security_path_make_dir__valid_args____calls_mkdir() {
  stdlib.security.path.make.dir "MOCK_PATH" "MOCK_USER" "MOCK_GROUP" "MOCK_PERM"

  mkdir.mock.assert_called_once_with "1(-p) 2(MOCK_PATH)"
}

test_stdlib_security_path_make_dir__valid_args____calls_secure() {
  stdlib.security.path.make.dir "MOCK_PATH" "MOCK_USER" "MOCK_GROUP" "MOCK_PERM"

  stdlib.security.path.secure.mock.assert_called_once_with "1(MOCK_PATH) 2(MOCK_USER) 3(MOCK_GROUP) 4(MOCK_PERM)"
}

test_stdlib_security_path_make_dir__valid_args____returns_status_code_0() {
  _capture.rc stdlib.security.path.make.dir "MOCK_PATH" "MOCK_USER" "MOCK_GROUP" "MOCK_PERM"

  assert_rc "0"
}
