#!/bin/bash

setup() {
  _mock.create _io_ensure_vars_set
  _mock.create mkdir
  _mock.create _security_path_secure
}

test_security_path_mkdir__@vary__calls_io_ensure_vars_set() {
  _array_from_string TEST_ARGUMENTS "|" "${TEST_ARGUMENT_DEFINITION}"

  _security_path_mkdir "${TEST_ARGUMENTS[@]}"

  _io_ensure_vars_set.mock.assert_called_once_with "4 ${EXPECTED_ARGS}"
}

@parametrize \
  "test_security_path_mkdir__@vary__calls_io_ensure_vars_set" \
  "TEST_ARGUMENT_DEFINITION,EXPECTED_ARGS" \
  "valid_arguments,/mnt/path1|user1|group1|644,/mnt/path1 user1 group1 644" \
  "omitted_group__,/mnt/path1|user1|644,/mnt/path1 user1 644" \
  "unset_group____,/mnt/path1|user1||644,/mnt/path1 user1  644"

test_security_path_mkdir__valid_arguments__calls_mkdir() {
  _security_path_mkdir "MOCK_PATH" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  mkdir.mock.assert_called_once_with "-p MOCK_PATH"
}

test_security_path_mkdir__valid_arguments__calls_security_path_secure() {
  _security_path_mkdir "MOCK_PATH" "MOCK_USERNAME" "MOCK_GROUP" "MOCK_PERMISSIONS"

  _security_path_secure.mock.assert_called_once_with "MOCK_PATH MOCK_USERNAME MOCK_GROUP MOCK_PERMISSIONS"
}
