#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create chown
  _mock.create chmod
}

@parametrize_with_required_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;/mnt/path1|user1|group1|644|extra_arg;127" \
    "null_path________returns_status_code_126;|user1|group1|644;126" \
    "null_user________returns_status_code_126;/mnt/path1||group1|644;126" \
    "null_group_______returns_status_code_126;/mnt/path1|user1||644;126" \
    "null_perms_______returns_status_code_126;/mnt/path1|user1|group1||;126" \
    "valid_arguments__returns_status_code___0;/mnt/path1|user1|group1|644;0"
}

test_stdlib_security_path_secure__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.path.secure "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_required_arg_combos \
  test_stdlib_security_path_secure__@vary

test_stdlib_security_path_secure__valid_arguments__calls_chown_correctly() {
  stdlib.security.path.secure "MOCK_PATH" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  chown.mock.assert_called_once_with "1(MOCK_USERNAME:MOCK_GROUP) 2(MOCK_PATH)"
}

test_stdlib_security_path_secure__valid_arguments__calls_chmod_correctly() {
  stdlib.security.path.secure "MOCK_PATH" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  chmod.mock.assert_called_once_with "1(MOCK_PERMISSIONS) 2(MOCK_PATH)"
}
