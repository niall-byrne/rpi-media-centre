#!/bin/bash

setup() {
  _mock.create stdlib.io.path.assert.is_folder
  _mock.create stdlib.string.assert.is_octal_permission
  _mock.create stdlib.security.path.assert.is_secure
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "TEST_PATH;TEST_SVC_USERNAME;TEST_SVC_GROUPNAME;TEST_PERMISSION" \
    "path_1;path1;user1;group1;755" \
    "path_2;path2;user2;group2;700"
}

# shellcheck disable=SC2034
test_backup_job_validation_path__@vary__calls_is_folder() {
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_validation_path "${TEST_PATH}" "${TEST_PERMISSION}"

  stdlib.io.path.assert.is_folder.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_paths \
  test_backup_job_validation_path__@vary__calls_is_folder

# shellcheck disable=SC2034
test_backup_job_validation_path__@vary__calls_is_octal_permission() {
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_validation_path "${TEST_PATH}" "${TEST_PERMISSION}"

  stdlib.string.assert.is_octal_permission.mock.assert_called_once_with \
    "1(${TEST_PERMISSION})"
}

@parametrize_with_paths \
  test_backup_job_validation_path__@vary__calls_is_octal_permission

# shellcheck disable=SC2034
test_backup_job_validation_path__@vary__calls_is_secure() {
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_validation_path "${TEST_PATH}" "${TEST_PERMISSION}"

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(${TEST_SVC_USERNAME}) 3(${TEST_SVC_GROUPNAME}) 4(${TEST_PERMISSION})"
}

@parametrize_with_paths \
  test_backup_job_validation_path__@vary__calls_is_secure
