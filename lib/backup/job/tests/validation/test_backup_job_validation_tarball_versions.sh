#!/bin/bash

setup() {
  _mock.create _cli_log_error
  _mock.create _backup_job_log
  _mock.create _backup_job_message_tarball_versions
}

@parametrize_with_valid_versions() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "TEST_VERSION" \
    "1___________;1" \
    "5___________;5" \
    "9___________;9"
}

@parametrize_with_invalid_versions() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
    "TEST_VERSION" \
    "0___________;0" \
    "10__________;10" \
    "a___________;a" \
    "empty_string;;"
}

test_backup_job_validation_remote_parameters_s3__valid_versions____@vary__returns_0() {
  _capture.rc _backup_job_validation_tarball_versions "${TEST_VERSION}"

  assert_rc "0"
}

@parametrize_with_valid_versions \
  test_backup_job_validation_remote_parameters_s3__valid_versions____@vary__returns_0

test_backup_job_validation_remote_parameters_s3__valid_versions____@vary__does_not_log_errors() {
  _backup_job_validation_tarball_versions "${TEST_VERSION}"

  _cli_log_error.mock.assert_not_called
}

@parametrize_with_valid_versions \
  test_backup_job_validation_remote_parameters_s3__valid_versions____@vary__does_not_log_errors

test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__returns_127() {
  _capture.rc _backup_job_validation_tarball_versions "${TEST_VERSION}"

  assert_rc "127"
}

@parametrize_with_invalid_versions \
  test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__returns_127

test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__logs_error() {
  _backup_job_validation_tarball_versions "${TEST_VERSION}"

  _cli_log_error.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Invalid local tarball version count.)"
}

@parametrize_with_invalid_versions \
  test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__logs_error

test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__generates_stderr() {
  _backup_job_log.mock.set.stdout "mock backup job log"
  _backup_job_message_tarball_versions.mock.set.stdout "mock tarball version message"

  _capture.stderr _backup_job_validation_tarball_versions "${TEST_VERSION}"

  assert_output "mock backup job log
mock tarball version message"
}

@parametrize_with_invalid_versions \
  test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__generates_stderr

test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__generates_no_stdout() {
  _backup_job_log.mock.set.stdout "mock backup job log"
  _backup_job_message_tarball_versions.mock.set.stdout "mock tarball version message"

  _capture.stdout _backup_job_validation_tarball_versions "${TEST_VERSION}"

  assert_output_null
}

@parametrize_with_invalid_versions \
  test_backup_job_validation_remote_parameters_s3__invalid_versions__@vary__generates_no_stdout
