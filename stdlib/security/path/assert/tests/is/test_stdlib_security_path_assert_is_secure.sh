#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.security.path.assert.has_owner
  _mock.create stdlib.security.path.assert.has_group
  _mock.create stdlib.security.path.assert.has_permissions
}

@parametrize_with_required_invalid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127;;127" \
    "extra_args____________returns_status_code_127;/etc|user1|group1|644|extra_arg;127"
}

@parametrize_with_required_valid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_HAS_OWNER_RC;TEST_HAS_GROUP_RC;TEST_HAS_PERMS_RC;TEST_EXPECTED_RC" \
    "test_ownership_fails__returns_status_code_1;1;0;0;1" \
    "test_group_fails______returns_status_code_1;0;1;0;1" \
    "test_perms_fails______returns_status_code_1;0;0;1;1" \
    "test_all_pass_________returns_status_code_0;0;0;0;0"
}

test_stdlib_security_path_assert_is_secure__invalid_args__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.path.assert.is_secure "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_required_invalid_arg_combos \
  test_stdlib_security_path_assert_is_secure__invalid_args__@vary

test_stdlib_security_path_assert_is_secure__valid_args____calls_has_owner_as_expected() {
  stdlib.security.path.assert.is_secure "MOCK_PATH" "MOCK_USER" "MOCK_GROUP" "MOCK_PERM"

  stdlib.security.path.assert.has_owner.mock.assert_called_once_with "1(MOCK_PATH) 2(MOCK_USER)"
}

test_stdlib_security_path_assert_is_secure__valid_args____calls_has_group_as_expected() {
  stdlib.security.path.assert.is_secure "MOCK_PATH" "MOCK_USER" "MOCK_GROUP" "MOCK_PERM"

  stdlib.security.path.assert.has_group.mock.assert_called_once_with "1(MOCK_PATH) 2(MOCK_GROUP)"
}

test_stdlib_security_path_assert_is_secure__valid_args____calls_has_permissions_as_expected() {
  stdlib.security.path.assert.is_secure "MOCK_PATH" "MOCK_USER" "MOCK_GROUP" "MOCK_PERM"

  stdlib.security.path.assert.has_permissions.mock.assert_called_once_with "1(MOCK_PATH) 2(MOCK_PERM)"
}

test_stdlib_security_path_assert_is_secure__valid_args____@vary() {
  stdlib.security.path.assert.has_owner.mock.set.rc "${TEST_HAS_OWNER_RC}"
  stdlib.security.path.assert.has_group.mock.set.rc "${TEST_HAS_GROUP_RC}"
  stdlib.security.path.assert.has_permissions.mock.set.rc "${TEST_HAS_PERMS_RC}"

  _capture.rc stdlib.security.path.assert.is_secure "MOCK_PATH" "MOCK_USER" "MOCK_GROUP" "MOCK_PERM"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_required_valid_arg_combos \
  test_stdlib_security_path_assert_is_secure__valid_args____@vary
