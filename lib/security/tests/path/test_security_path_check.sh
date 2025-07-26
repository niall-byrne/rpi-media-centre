#!/bin/bash

setup() {
  _mock.create _io_ensure_vars_set
  _mock.create _security_path_check_ownership
  _mock.create _security_path_check_permissions

  _security_path_check_ownership.mock.set.rc 0
  _security_path_check_permissions.mock.set.rc 0
}

@parametrize_with_invalid_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "OWNERSHIP_RC,PERMISSION_RC" \
    "invalid_ownership__invalid_permissions,1,1" \
    "valid_ownership____invalid_permissions,0,1" \
    "invalid_ownership__valid_permissions__,1,0"
}

test_security_path_check__@vary__calls_io_ensure_vars_set() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _security_path_check "${TEST_ARGUMENTS[@]}"

  _io_ensure_vars_set.mock.assert_called_once_with "4 ${EXPECTED_ARGS}"
}

@parametrize \
  "test_security_path_check__@vary__calls_io_ensure_vars_set" \
  "TEST_ARGUMENT_DEFINITION,EXPECTED_ARGS" \
  "valid_arguments,/mnt/path1|user1|group1|644,/mnt/path1 user1 group1 644" \
  "omitted_group__,/mnt/path1|user1|644,/mnt/path1 user1 644" \
  "unset_group____,/mnt/path1|user1||644,/mnt/path1 user1  644"

test_security_path_check__valid_arguments__valid_ownership____valid_permissions____calls_security_path_check_ownership() {
  _security_path_check "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  _security_path_check_ownership.mock.assert_called_once_with \
    "/mnt/path1 MOCK_USERNAME MOCK_GROUP"
}

test_security_path_check__valid_arguments__valid_ownership____valid_permissions____calls_security_path_check_permissions() {
  _security_path_check "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  _security_path_check_permissions.mock.assert_called_once_with \
    "/mnt/path1 MOCK_PERMISSIONS"
}

test_security_path_check__valid_arguments__valid_ownership____valid_permissions____returns_0() {
  _capture_rc _security_path_check "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  assert_rc "0"
}

test_security_path_check__valid_arguments__@vary__calls_security_path_check_ownership() {
  _security_path_check_ownership.mock.set.rc "${OWNERSHIP_RC}"
  _security_path_check_permissions.mock.set.rc "${PERMISSION_RC}"

  _security_path_check "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  _security_path_check_ownership.mock.assert_called_once_with \
    "/mnt/path1 MOCK_USERNAME MOCK_GROUP"
}

@parametrize_with_invalid_combos \
  test_security_path_check__valid_arguments__@vary__calls_security_path_check_ownership

test_security_path_check__valid_arguments__invalid_ownership__does_not_call_security_path_check_permissions() {
  _security_path_check_ownership.mock.set.rc 1

  _security_path_check "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  _security_path_check_permissions.mock.assert_not_called
}

test_security_path_check__valid_arguments__@vary__returns_127() {
  _security_path_check_ownership.mock.set.rc "${OWNERSHIP_RC}"
  _security_path_check_permissions.mock.set.rc "${PERMISSION_RC}"

  _capture_rc _security_path_check "/mnt/path1" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  assert_rc "127"
}

@parametrize_with_invalid_combos \
  test_security_path_check__valid_arguments__@vary__returns_127
