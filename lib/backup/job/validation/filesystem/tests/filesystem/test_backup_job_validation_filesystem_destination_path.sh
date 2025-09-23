#!/bin/bash

setup() {
  _mock.create stdlib.io.path.assert.is_folder
  _mock.create stdlib.string.assert.is_octal_permission
  _mock.create stdlib.security.path.assert.is_secure
}

@parametrize_with_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH;TEST_PERMISSION;TEST_USERNAME;TEST_GROUPNAME" \
    "scenario1;/path/1;644;user1;group1" \
    "scenario2;/path/2;755;user2;group2"
}

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_destination_path__@vary__validates_path_is_folder() {
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _backup_job_validation_filesystem_destination_path "${TEST_PATH}" "${TEST_PERMISSION}"

  stdlib.io.path.assert.is_folder.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_scenarios \
  test_backup_job_validation_filesystem_destination_path__@vary__validates_path_is_folder

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_destination_path__@vary__validates_octal_permission() {
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _backup_job_validation_filesystem_destination_path "${TEST_PATH}" "${TEST_PERMISSION}"

  stdlib.string.assert.is_octal_permission.mock.assert_called_once_with \
    "1(${TEST_PERMISSION})"
}

@parametrize_with_scenarios \
  test_backup_job_validation_filesystem_destination_path__@vary__validates_octal_permission

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_destination_path__@vary__validates_path_is_properly_secured() {
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _backup_job_validation_filesystem_destination_path "${TEST_PATH}" "${TEST_PERMISSION}"

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(${TEST_USERNAME}) 3(${TEST_GROUPNAME}) 4(${TEST_PERMISSION})"
}

@parametrize_with_scenarios \
  test_backup_job_validation_filesystem_destination_path__@vary__validates_path_is_properly_secured
