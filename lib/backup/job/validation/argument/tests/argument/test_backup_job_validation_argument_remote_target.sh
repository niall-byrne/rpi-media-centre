#!/bin/bash

setup() {
  _mock.create _backup_job_validation_argument_remote_parameter_s3
  _mock.create _backup_job_validation_error
}

@parametrize_with_valid_scenarios() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARGET" \
    "empty_target__;;" \
    "s3_target_____;s3://bucket"
}

@parametrize_with_invalid_scenario() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_TARGET" \
    "invalid_target;invalid"
}

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_target__valid_scenarios___empty_target____does_not_validate_s3_parameter() {
  local RPI_BACKUP_JOB_REMOTE_TARGET=""

  _backup_job_validation_argument_remote_target

  _backup_job_validation_argument_remote_parameter_s3.mock.assert_not_called
}

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_target__valid_scenarios___s3_target_______validates_s3_parameter() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="s3://bucket"

  _backup_job_validation_argument_remote_target

  _backup_job_validation_argument_remote_parameter_s3.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_target__valid_scenarios___empty_target____does_not_call_dependencies() {
  local RPI_BACKUP_JOB_REMOTE_TARGET=""

  _backup_job_validation_argument_remote_target

  _backup_job_validation_argument_remote_parameter_s3.mock.assert_not_called
}

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_target__@vary___@vary__does_not_generate_validation_error() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_TARGET}"

  _backup_job_validation_argument_remote_target

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize.apply \
  test_backup_job_validation_argument_remote_target__@vary___@vary__does_not_generate_validation_error \
  @parametrize_with_valid_scenarios

# shellcheck disable=SC2034
test_backup_job_validation_argument_remote_target__@vary__@vary__generates_validation_error() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_TARGET}"

  _backup_job_validation_argument_remote_target

  _backup_job_validation_error.mock.assert_called_once_with \
    "1(Invalid remote storage target for this job.) 2(_backup_job_message_remote_target)"
}

@parametrize.apply \
  test_backup_job_validation_argument_remote_target__@vary__@vary__generates_validation_error \
  @parametrize_with_invalid_scenario
