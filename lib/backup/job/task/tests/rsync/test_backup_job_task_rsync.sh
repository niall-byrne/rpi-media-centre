#!/bin/bash

setup() {
  _mock.create _backup_job_task_wrapper
  _mock.create _cli_log_notice
}

@parametrize_with_rsync_targets() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH" \
    "with_rsync_target___;/foo/bar"
}

@parametrize_without_rsync_targets() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_PATH" \
    "without_rsync_target;;"
}

# shellcheck disable=SC2034
test_backup_job_task_rsync__@vary__calls_task_wrapper() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"

  _backup_job_task_rsync

  _backup_job_task_wrapper.mock.assert_called_once_with \
    "1(_backup_job_task_rsync_filesystem)"
}

@parametrize_with_rsync_targets \
  test_backup_job_task_rsync__@vary__calls_task_wrapper

# shellcheck disable=SC2034
test_backup_job_task_rsync__@vary__does_not_log_notice() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"

  _backup_job_task_rsync

  _cli_log_notice.mock.assert_not_called
}

@parametrize_with_rsync_targets \
  test_backup_job_task_rsync__@vary__does_not_log_notice

# shellcheck disable=SC2034
test_backup_job_task_rsync__@vary__does_not_call_task_wrapper() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"

  _backup_job_task_rsync

  _backup_job_task_wrapper.mock.assert_not_called
}

@parametrize_without_rsync_targets \
  test_backup_job_task_rsync__@vary__does_not_call_task_wrapper

# shellcheck disable=SC2034
test_backup_job_task_rsync__@vary__logs_notice() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_PATH}"

  _backup_job_task_rsync

  _cli_log_notice.mock.assert_called_once_with \
    "1( -- BACKUP JOB: No rsync required for this job !)"
}

@parametrize_without_rsync_targets \
  test_backup_job_task_rsync__@vary__logs_notice
