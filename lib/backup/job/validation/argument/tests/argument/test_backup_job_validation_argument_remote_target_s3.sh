#!/bin/bash

setup() {
  _mock.create _backup_job_validation_error
}

@parametrize_with_valid_s3_params() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_PARAM" \
    "EMPTY_VALUE;;" \
    "STANDARD;STANDARD" \
    "REDUCED_REDUNDANCY;REDUCED_REDUNDANCY" \
    "STANDARD_IA;STANDARD_IA" \
    "ONEZONE_IA;ONEZONE_IA" \
    "INTELLIGENT_TIERING;INTELLIGENT_TIERING" \
    "GLACIER;GLACIER" \
    "DEEP_ARCHIVE;DEEP_ARCHIVE" \
    "GLACIER_IR;GLACIER_IR"
}

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_parameter_s3__@vary__returns_staus_code_0() {
  local RPI_BACKUP_JOB_REMOTE_PARAMETER="${TEST_PARAM}"

  _capture.rc _backup_job_validation_argument_remote_parameter_s3

  assert_rc "0"
}

@parametrize_with_valid_s3_params \
  test_backup_job_validation_argument_remote_parameter_s3__@vary__returns_staus_code_0

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_parameter_s3__@vary__does_not_generate_validation_error() {
  local RPI_BACKUP_JOB_REMOTE_PARAMETER="${TEST_PARAM}"

  _backup_job_validation_argument_remote_parameter_s3

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_valid_s3_params \
  test_backup_job_validation_argument_remote_parameter_s3__@vary__does_not_generate_validation_error

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_parameter_s3__invalid_param________generates_validation_error() {
  local RPI_BACKUP_JOB_REMOTE_PARAMETER="INVALID"

  _backup_job_validation_argument_remote_parameter_s3

  _backup_job_validation_error.mock.assert_called_once_with \
    "1(Invalid remote S3 storage parameter for this job.) 2(_backup_job_message_remote_param_s3)"
}
