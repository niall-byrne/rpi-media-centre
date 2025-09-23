#!/bin/bash

setup() {
  _mock.create _backup_job_validation_filesystem_keyfile_is_secure
  _mock.create _backup_job_validation_error
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
test_backup_job_validation_filesystem_keyfile__not_set_____________does_not_call_is_secure() {
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH=""

  _backup_job_validation_filesystem_keyfile

  _backup_job_validation_filesystem_keyfile_is_secure.mock.assert_not_called
}

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_keyfile__@vary__path_valid____calls_is_secure() {
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_PATH}"

  _backup_job_validation_filesystem_keyfile_is_secure.mock.set.rc 0

  _backup_job_validation_filesystem_keyfile

  _backup_job_validation_filesystem_keyfile_is_secure.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_keyfile__@vary__path_valid____calls_is_secure

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_keyfile__@vary__path_invalid__calls_is_secure() {
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_PATH}"

  _backup_job_validation_filesystem_keyfile_is_secure.mock.set.rc 1

  _backup_job_validation_filesystem_keyfile

  _backup_job_validation_filesystem_keyfile_is_secure.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_keyfile__@vary__path_invalid__calls_is_secure

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_keyfile__@vary__path_valid____does_not_call_validation_error() {
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_PATH}"

  _backup_job_validation_filesystem_keyfile_is_secure.mock.set.rc 0

  _backup_job_validation_filesystem_keyfile

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_keyfile__@vary__path_valid____does_not_call_validation_error

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_keyfile__@vary__path_invalid__calls_validation_error() {
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_PATH}"

  _backup_job_validation_filesystem_keyfile_is_secure.mock.set.rc 1

  _backup_job_validation_filesystem_keyfile

  _backup_job_validation_error.mock.assert_called_once_with \
    "1(Invalid encryption key path.) 2(_backup_job_message_keyfile_path)"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_keyfile__@vary__path_invalid__calls_validation_error
