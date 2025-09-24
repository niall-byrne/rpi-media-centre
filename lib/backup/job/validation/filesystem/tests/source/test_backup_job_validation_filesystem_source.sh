#!/bin/bash

setup() {
  _mock.create _backup_job_validation_filesystem_source_path
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
test_backup_job_validation_filesystem_source__@vary__path_valid____calls_is_secure() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_PATH}"

  _backup_job_validation_filesystem_source_path.mock.set.rc 0

  _backup_job_validation_filesystem_source

  _backup_job_validation_filesystem_source_path.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_source__@vary__path_valid____calls_is_secure

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_source__@vary__path_invalid__calls_is_secure() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_PATH}"

  _backup_job_validation_filesystem_source_path.mock.set.rc 1

  _backup_job_validation_filesystem_source

  _backup_job_validation_filesystem_source_path.mock.assert_called_once_with \
    "1(${TEST_PATH})"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_source__@vary__path_invalid__calls_is_secure

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_source__@vary__path_valid____does_not_call_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_PATH}"

  _backup_job_validation_filesystem_source_path.mock.set.rc 0

  _backup_job_validation_filesystem_source

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_source__@vary__path_valid____does_not_call_validation_error

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_source__@vary__path_invalid__calls_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_PATH}"

  _backup_job_validation_filesystem_source_path.mock.set.rc 1

  _backup_job_validation_filesystem_source

  _backup_job_validation_error.mock.assert_called_once_with \
    "1(Invalid source path.) 2(_backup_job_message_source_path)"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_source__@vary__path_invalid__calls_validation_error
