#!/bin/bash

setup() {
  _mock.create _cli_log_notice
  _mock.create _backup_job_task_wrapper
  _mock.create _backup_job_task_upload_s3
}

@parametrize_with_empty_target() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_REMOTE_TARGET" \
    "empty_________________;;"
}

@parametrize_with_s3_target() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_REMOTE_TARGET" \
    "simple_s3_path________;s3://bucket/path" \
    "s3_path_with_subfolder;s3://bucket/path/subfolder"
}

# shellcheck disable=SC2034
test_backup_job_task_upload__@vary__logs_notice() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_JOB_REMOTE_TARGET}"

  _backup_job_task_upload

  _cli_log_notice.mock.assert_called_once_with \
    "1( -- BACKUP JOB: No upload required for this job !)"
}

@parametrize_with_empty_target \
  test_backup_job_task_upload__@vary__logs_notice

# shellcheck disable=SC2034
test_backup_job_task_upload__@vary__does_not_call_wrapper() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_JOB_REMOTE_TARGET}"

  _backup_job_task_upload

  _backup_job_task_wrapper.mock.assert_not_called
}

@parametrize_with_empty_target \
  test_backup_job_task_upload__@vary__does_not_call_wrapper

# shellcheck disable=SC2034
test_backup_job_task_upload__@vary__does_not_log_notice() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_JOB_REMOTE_TARGET}"

  _backup_job_task_upload

  _cli_log_notice.mock.assert_not_called
}

@parametrize_with_s3_target \
  test_backup_job_task_upload__@vary__does_not_log_notice

# shellcheck disable=SC2034
test_backup_job_task_upload__@vary__calls_wrapper() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_JOB_REMOTE_TARGET}"

  _backup_job_task_upload

  _backup_job_task_wrapper.mock.assert_called_once_with \
    "1(_backup_job_task_upload_s3)"
}

@parametrize_with_s3_target \
  test_backup_job_task_upload__@vary__calls_wrapper
