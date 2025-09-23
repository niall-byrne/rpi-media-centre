#!/bin/bash

setup() {
  _mock.create _dependencies_group_backups_aws
}

@parametrize_with_s3_target() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_REMOTE_TARGET" \
    "s3_target__________;s3://foo"
}

@parametrize_with_other_targets() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_REMOTE_TARGET" \
    "empty_target_______;;" \
    "non_matching_target;foo"
}

# shellcheck disable=SC2034
test_backup_job_validation_dependency_remote_target__@vary__calls_aws_dependency_check() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"

  _backup_job_validation_dependency_remote_target

  _dependencies_group_backups_aws.mock.assert_called_once_with ""
}

@parametrize_with_s3_target \
  test_backup_job_validation_dependency_remote_target__@vary__calls_aws_dependency_check

# shellcheck disable=SC2034
test_backup_job_validation_dependency_remote_target__@vary__skips_aws_dependency_check() {
  local RPI_BACKUP_JOB_REMOTE_TARGET="${TEST_REMOTE_TARGET}"

  _backup_job_validation_dependency_remote_target

  _dependencies_group_backups_aws.mock.assert_not_called
}

@parametrize_with_other_targets \
  test_backup_job_validation_dependency_remote_target__@vary__skips_aws_dependency_check
