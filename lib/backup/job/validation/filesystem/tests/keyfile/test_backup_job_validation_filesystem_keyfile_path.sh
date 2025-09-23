#!/bin/bash

setup() {
  _mock.create stdlib.io.path.assert.is_file
  _mock.create stdlib.security.path.assert.is_secure
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "TEST_PATH" \
    "simple_path_______;test_path" \
    "path_with_spaces__;a path with spaces" \
    "path_with_subpaths;a/path/with/sub/paths"
}

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_keyfile_is_secure__@vary__calls_is_file() {
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_PATH}"

  _backup_job_validation_filesystem_keyfile_is_secure

  stdlib.io.path.assert.is_file.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_keyfile_is_secure__@vary__calls_is_file

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_keyfile_is_secure__@vary__calls_is_secure() {
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_PATH}"

  _backup_job_validation_filesystem_keyfile_is_secure

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(root) 3(root) 4(400)"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_keyfile_is_secure__@vary__calls_is_secure
