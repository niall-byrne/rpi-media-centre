#!/bin/bash

setup() {
  _mock.create _backup_job_task_upload_s3_from_latest_tarball
  _mock.create _control_pushd
}

@parametrize_with_tarball_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_LOCAL_TARBALL_FOLDER;TEST_JOB_REMOTE_ENCRYPTION_KEY_PATH;TEST_JOB_LOCAL_SOURCE" \
    "with_key;/path/to/tarballs;/path/to/key;;" \
    "without_key;/path/to/tarballs;;;"
}

@parametrize_with_stream_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_LOCAL_TARBALL_FOLDER;TEST_JOB_REMOTE_ENCRYPTION_KEY_PATH;TEST_JOB_LOCAL_SOURCE" \
    "with_key;;/path/to/key;/path/to/source" \
    "without_key;;;/another/path with spaces"
}

# shellcheck disable=SC2034
test_backup_job_task_upload_s3__from_tarball__@vary__calls_from_latest_tarball() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_JOB_LOCAL_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_JOB_REMOTE_ENCRYPTION_KEY_PATH}"
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_JOB_LOCAL_SOURCE}"

  _backup_job_task_upload_s3

  _backup_job_task_upload_s3_from_latest_tarball.mock.assert_called_once_with ""
}

@parametrize_with_tarball_scenarios \
  test_backup_job_task_upload_s3__from_tarball__@vary__calls_from_latest_tarball

# shellcheck disable=SC2034
test_backup_job_task_upload_s3__from_tarball__@vary__does_not_call_pushd() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_JOB_LOCAL_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_JOB_REMOTE_ENCRYPTION_KEY_PATH}"
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_JOB_LOCAL_SOURCE}"

  _backup_job_task_upload_s3

  _control_pushd.mock.assert_not_called
}

@parametrize_with_tarball_scenarios \
  test_backup_job_task_upload_s3__from_tarball__@vary__does_not_call_pushd

# shellcheck disable=SC2034
test_backup_job_task_upload_s3__from_stream___@vary__calls_pushd() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_JOB_LOCAL_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_JOB_REMOTE_ENCRYPTION_KEY_PATH}"
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_JOB_LOCAL_SOURCE}"
  local expected_dirname

  expected_dirname="$(dirname "${RPI_BACKUP_JOB_LOCAL_SOURCE}")"

  _backup_job_task_upload_s3

  _control_pushd.mock.assert_called_once_with \
    "1(${expected_dirname}) 2(_backup_job_task_upload_s3_from_tarball_stream)"
}

@parametrize_with_stream_scenarios \
  test_backup_job_task_upload_s3__from_stream___@vary__calls_pushd

# shellcheck disable=SC2034
test_backup_job_task_upload_s3__from_stream___@vary__does_not_call_from_latest_tarball() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_JOB_LOCAL_TARBALL_FOLDER}"
  local RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH="${TEST_JOB_REMOTE_ENCRYPTION_KEY_PATH}"
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_JOB_LOCAL_SOURCE}"

  _backup_job_task_upload_s3

  _backup_job_task_upload_s3_from_latest_tarball.mock.assert_not_called
}

@parametrize_with_stream_scenarios \
  test_backup_job_task_upload_s3__from_stream___@vary__does_not_call_from_latest_tarball
