#!/bin/bash

setup() {
  _mock.create aws
  _mock.create _backup_job_task_tarball_get_latest_filename
}

@parametrize_with_inputs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LATEST_FILENAME;TEST_JOB_REMOTE_TARGET;TEST_JOB_NAME;TEST_UPLOAD_OPTIONS_DEFINITION" \
    "simple_path___no_options__;/path/to/latest.tar;s3://bucket/path;job1;;" \
    "simple_path___with_options;/path/to/latest.tar;s3://bucket/path;job1;opt1|opt2" \
    "complex_path__no_options__;/path with spaces/latest.tar;s3://another-bucket/path;job2;;" \
    "complex_path__with_options;/path with spaces/latest.tar;s3://another-bucket/path;job2;opt3|opt4"
}

_fixture_upload_options_arg_string() {
  # $1: the upload option to wrap

  printf " ${upload_option_index}(%s)" "${1}"

  ((upload_option_index++))
}

# shellcheck disable=SC2034
test_backup_job_task_upload_s3_from_latest_tarball_retryable__@vary__calls_aws_cli_as_expected() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_JOB_REMOTE_TARGET}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local RPI_BACKUP_JOB_UPLOAD_OPTIONS=()
  local upload_option_index=6

  stdlib.array.make.from_string RPI_BACKUP_JOB_UPLOAD_OPTIONS "|" "${TEST_UPLOAD_OPTIONS_DEFINITION}"
  _backup_job_task_tarball_get_latest_filename.mock.set.stdout "${TEST_LATEST_FILENAME}"

  _backup_job_task_upload_s3_from_latest_tarball_retryable

  aws.mock.assert_called_once_with \
    "1(s3) 2(cp) 3(--no-progress) 4(${TEST_LATEST_FILENAME}) 5(${TEST_JOB_REMOTE_TARGET}/${TEST_JOB_NAME}.tar)$(stdlib.array.map.fn _fixture_upload_options_arg_string RPI_BACKUP_JOB_UPLOAD_OPTIONS)"
}

@parametrize_with_inputs \
  test_backup_job_task_upload_s3_from_latest_tarball_retryable__@vary__calls_aws_cli_as_expected
