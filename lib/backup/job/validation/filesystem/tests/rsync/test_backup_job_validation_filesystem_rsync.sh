#!/bin/bash

setup() {
  _mock.create _backup_job_validation_filesystem_destination_path
  _mock.create _backup_job_validation_error
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "TEST_PATH;TEST_PERMISSION" \
    "simple_path_______;test_path;755" \
    "path_with_spaces__;a path with spaces;0777" \
    "path_with_subpaths;a/path/with/sub/paths;700"
}

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_rsync__not_set_____________does_not_call_is_secure() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER=""
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION=""

  _backup_job_validation_filesystem_rsync

  _backup_job_validation_filesystem_destination_path.mock.assert_not_called
}

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_rsync__@vary__path_valid____calls_is_secure() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION="${TEST_PERMISSION}"

  _backup_job_validation_filesystem_destination_path.mock.set.rc 0

  _backup_job_validation_filesystem_rsync

  _backup_job_validation_filesystem_destination_path.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(${TEST_PERMISSION})"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_rsync__@vary__path_valid____calls_is_secure

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_rsync__@vary__path_invalid__calls_is_secure() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION="${TEST_PERMISSION}"

  _backup_job_validation_filesystem_destination_path.mock.set.rc 1

  _backup_job_validation_filesystem_rsync

  _backup_job_validation_filesystem_destination_path.mock.assert_called_once_with \
    "1(${TEST_PATH}) 2(${TEST_PERMISSION})"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_rsync__@vary__path_invalid__calls_is_secure

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_rsync__@vary__path_valid____does_not_call_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION="${TEST_PERMISSION}"

  _backup_job_validation_filesystem_destination_path.mock.set.rc 0

  _backup_job_validation_filesystem_rsync

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_rsync__@vary__path_valid____does_not_call_validation_error

# shellcheck disable=SC2034
test_backup_job_validation_filesystem_rsync__@vary__path_invalid__calls_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION="${TEST_PERMISSION}"

  _backup_job_validation_filesystem_destination_path.mock.set.rc 1

  _backup_job_validation_filesystem_rsync

  _backup_job_validation_error.mock.assert_called_once_with \
    "1(Invalid rsync destination path.) 2(_backup_job_message_destination_path)"
}

@parametrize_with_paths \
  test_backup_job_validation_filesystem_rsync__@vary__path_invalid__calls_validation_error
