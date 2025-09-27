#!/bin/bash

setup() {
  _mock.create tar
  _mock.create aws

  tar.mock.set.stdout "mock tar data"
  aws.mock.set.pipeable 1
}

@parametrize_with_inputs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCAL_SOURCE;TEST_JOB_REMOTE_TARGET;TEST_JOB_NAME;TEST_UPLOAD_OPTIONS_DEFINITION;TEST_CONNECT_TIMEOUT;TEST_READ_TIMEOUT" \
    "simple_path___no_options__;/path/to/latest.tar;s3://bucket/path;job1;;99;100" \
    "simple_path___with_options;/path/to/latest.tar;s3://bucket/path;job1;opt1|opt2;101;102" \
    "complex_path__no_options__;/path with spaces/latest.tar;s3://another-bucket/path;job2;;103;104" \
    "complex_path__with_options;/path with spaces/latest.tar;s3://another-bucket/path;job2;opt3|opt4;105;106"
}

_fixture_upload_options_arg_string() {
  # $1: the upload option to wrap

  printf " ${upload_option_index}(%s)" "${1}"

  ((upload_option_index++))
}

# shellcheck disable=SC2034
test_backup_job_task_upload_s3_from_tarball_stream_retryable__@vary__calls_tar_as_expected() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_LOCAL_SOURCE}"
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_JOB_REMOTE_TARGET}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local expected_source_path

  expected_source_path="$(basename "${TEST_LOCAL_SOURCE}")"

  _backup_job_task_upload_s3_from_tarball_stream_retryable

  tar.mock.assert_called_once_with \
    "1(c) 2(${expected_source_path})"
}

@parametrize_with_inputs \
  test_backup_job_task_upload_s3_from_tarball_stream_retryable__@vary__calls_tar_as_expected

# shellcheck disable=SC2034
test_backup_job_task_upload_s3_from_tarball_stream_retryable__@vary__calls_aws_cli_as_expected() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_JOB_REMOTE_TARGET}"
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"
  local RPI_BACKUP_JOB_UPLOAD_OPTIONS=()
  local RPI_BACKUP_S3_REMOTE_TIMEOUT_CONNECT="${TEST_CONNECT_TIMEOUT}"
  local RPI_BACKUP_S3_REMOTE_TIMEOUT_READ="${TEST_READ_TIMEOUT}"
  local upload_option_index=10

  stdlib.array.make.from_string RPI_BACKUP_JOB_UPLOAD_OPTIONS "|" "${TEST_UPLOAD_OPTIONS_DEFINITION}"

  _backup_job_task_upload_s3_from_tarball_stream_retryable

  RPI_BACKUP_JOB_UPLOAD_OPTIONS+=("mock tar data")
  aws.mock.assert_called_once_with \
    "1(--cli-connect-timeout) 2(${TEST_CONNECT_TIMEOUT}) 3(--cli-read-timeout) 4(${TEST_READ_TIMEOUT}) 5(s3) 6(cp) 7(--no-progress) 8(-) 9(${TEST_JOB_REMOTE_TARGET}/${TEST_JOB_NAME}.tar)$(stdlib.array.map.fn _fixture_upload_options_arg_string RPI_BACKUP_JOB_UPLOAD_OPTIONS)"
}

@parametrize_with_inputs \
  test_backup_job_task_upload_s3_from_tarball_stream_retryable__@vary__calls_aws_cli_as_expected
