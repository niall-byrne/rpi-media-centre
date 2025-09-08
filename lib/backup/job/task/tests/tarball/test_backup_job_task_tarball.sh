#!/bin/bash

setup() {
  _mock.create _cli_log_notice
  _mock.create _backup_job_task_wrapper
}

@parametrize_with_folder_set() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARBALL_FOLDER" \
    "simple_path_____;/path/to/tarballs" \
    "path_with_spaces;/a/path with spaces"
}

# shellcheck disable=SC2034
test_backup_job_task_tarball__folder_not_set____logs_notice_message() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER=""

  _backup_job_task_tarball

  _cli_log_notice.mock.assert_called_once_with \
    "1( -- BACKUP JOB: No tarball required for this job !)"
}

# shellcheck disable=SC2034
test_backup_job_task_tarball__folder_not_set____does_not_call_backup_job_task_wrapper() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER=""

  _backup_job_task_tarball

  _backup_job_task_wrapper.mock.assert_not_called
}

# shellcheck disable=SC2034
test_backup_job_task_tarball__@vary__does_not_log_notice_message() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"

  _backup_job_task_tarball

  _cli_log_notice.mock.assert_not_called
}

@parametrize_with_folder_set \
  test_backup_job_task_tarball__@vary__does_not_log_notice_message

# shellcheck disable=SC2034
test_backup_job_task_tarball__@vary__calls_the_backup_job_task_wrapper() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_TARBALL_FOLDER}"

  _backup_job_task_tarball

  _backup_job_task_wrapper.mock.assert_called_once_with \
    "1(_backup_job_task_tarball_filesystem)"
}

@parametrize_with_folder_set \
  test_backup_job_task_tarball__@vary__calls_the_backup_job_task_wrapper
