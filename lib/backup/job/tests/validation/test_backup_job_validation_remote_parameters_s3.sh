#!/bin/bash

setup() {
  _mock.create _cli_log_error
  _mock.create _backup_job_log
  _mock.create _backup_job_message_remote_param
}

@parametrize_with_valid_s3_params() {
  # $1: the test function to parametrize

  @parametrize \
    "$1" \
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

test_backup_job_validation_remote_parameters_s3__valid_param____@vary__returns_0() {
  _capture.rc _backup_job_validation_remote_parameters_s3 "${TEST_PARAM}"

  assert_rc "0"
}

@parametrize_with_valid_s3_params \
  test_backup_job_validation_remote_parameters_s3__valid_param____@vary__returns_0

test_backup_job_validation_remote_parameters_s3__valid_param____@vary__does_not_log_errors() {
  _backup_job_validation_remote_parameters_s3 "${TEST_PARAM}"

  _cli_log_error.mock.assert_not_called
}

@parametrize_with_valid_s3_params \
  test_backup_job_validation_remote_parameters_s3__valid_param____@vary__does_not_log_errors

test_backup_job_validation_remote_parameters_s3__invalid_param__returns_127() {
  _capture.rc _backup_job_validation_remote_parameters_s3 "INVALID"

  assert_rc "127"
}

test_backup_job_validation_remote_parameters_s3__invalid_param__logs_error() {
  _backup_job_validation_remote_parameters_s3 "INVALID"

  _cli_log_error.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Invalid remote S3 storage parameter for this job.)"
}

test_backup_job_validation_remote_parameters_s3__invalid_param__generates_stderr() {
  _backup_job_log.mock.set.stdout "_backup_job_log"
  _backup_job_message_remote_param.mock.set.stdout "_backup_job_message_remote_param"

  _capture.stderr _backup_job_validation_remote_parameters_s3 "INVALID"

  assert_output "_backup_job_log
_backup_job_message_remote_param"
}

test_backup_job_validation_remote_parameters_s3__invalid_param__generates_no_stdout() {
  _backup_job_log.mock.set.stdout "_backup_job_log"
  _backup_job_message_remote_param.mock.set.stdout "_backup_job_message_remote_param"

  _capture.stdout _backup_job_validation_remote_parameters_s3 "INVALID"

  assert_output_null
}
