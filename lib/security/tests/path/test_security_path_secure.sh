#!/bin/bash

setup() {
  _mock.create _io_ensure_vars_set
  _mock.create chown
  _mock.create chmod
}

test_security_path_secure__@vary__calls_io_ensure_vars_set() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _security_path_secure "${TEST_ARGUMENTS[@]}"

  _io_ensure_vars_set.mock.assert_called_once_with "4 ${EXPECTED_ARGS}"
}

@parametrize \
  "test_security_path_secure__@vary__calls_io_ensure_vars_set" \
  "TEST_ARGUMENT_DEFINITION,EXPECTED_ARGS" \
  "valid_arguments,/mnt/path1|user1|group1|644,/mnt/path1 user1 group1 644" \
  "omitted_group__,/mnt/path1|user1|644,/mnt/path1 user1 644" \
  "unset_group____,/mnt/path1|user1||644,/mnt/path1 user1  644"

test_security_path_secure__valid_arguments__calls_chown() {
  _security_path_secure "MOCK_PATH" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  chown.mock.assert_called_once_with "MOCK_USERNAME:MOCK_GROUP MOCK_PATH"
}

test_security_path_secure__valid_arguments__calls_chmod() {
  _security_path_secure "MOCK_PATH" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  chmod.mock.assert_called_once_with "MOCK_PERMISSIONS MOCK_PATH"
}
