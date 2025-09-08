#!/bin/bash

setup() {
  _mock.create _cli_log_error
  _mock.create _backup_job_task_wrapper
  _mock.create _backup_job_task_recover_s3
}

@parametrize_with_empty_target() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_REMOTE_TARGET" \
    "empty;;"
}

@parametrize_with_s3_target() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_REMOTE_TARGET" \
    "s3___;s3://bucket/path;"
}

# shellcheck disable=SC2034
test_backup_job_task_recover__@vary__logs_error() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"

  _backup_job_task_recover

  _cli_log_error.mock.assert_called_once_with \
    "1( -- BACKUP JOB: The specified job was not stored remotely !)"
}

@parametrize_with_empty_target \
  test_backup_job_task_recover__@vary__logs_error

# shellcheck disable=SC2034
test_backup_job_task_recover__@vary__does_not_call_wrapper() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"

  _backup_job_task_recover

  _backup_job_task_wrapper.mock.assert_not_called
}

@parametrize_with_empty_target \
  test_backup_job_task_recover__@vary__does_not_call_wrapper

# shellcheck disable=SC2034
test_backup_job_task_recover__@vary__calls_wrapper() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"

  _backup_job_task_recover

  _backup_job_task_wrapper.mock.assert_called_once_with \
    "1(_backup_job_task_recover_s3)"
}

@parametrize_with_s3_target \
  test_backup_job_task_recover__@vary__calls_wrapper

# shellcheck disable=SC2034
test_backup_job_task_recover__@vary__does_not_log_error() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"

  _backup_job_task_recover

  _cli_log_error.mock.assert_not_called
}

@parametrize_with_s3_target \
  test_backup_job_task_recover__@vary__does_not_log_error
