#!/bin/bash

setup() {
  _mock.create _backup_job_validation_error
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

# shellcheck disable=SC2034
test_backup_job_validation_remote_parameters_s3__without_tarball_folder__valid____@vary__does_not_generate_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER=""
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${TEST_VERSION}"

  _backup_job_validation_argument_tarball_versions

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_valid_versions \
  test_backup_job_validation_remote_parameters_s3__without_tarball_folder__valid____@vary__does_not_generate_validation_error

# shellcheck disable=SC2034
test_backup_job_validation_remote_parameters_s3__with_tarball_folder_____valid____@vary__does_not_generate_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="/mock/folder"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${TEST_VERSION}"

  _backup_job_validation_argument_tarball_versions

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_valid_versions \
  test_backup_job_validation_remote_parameters_s3__with_tarball_folder_____valid____@vary__does_not_generate_validation_error

# shellcheck disable=SC2034
test_backup_job_validation_remote_parameters_s3__without_tarball_folder__invalid__@vary__does_not_generate_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER=""
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${TEST_VERSION}"

  _backup_job_validation_argument_tarball_versions

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_invalid_versions \
  test_backup_job_validation_remote_parameters_s3__without_tarball_folder__invalid__@vary__does_not_generate_validation_error

# shellcheck disable=SC2034
test_backup_job_validation_remote_parameters_s3__with_tarball_folder_____invalid__@vary__generates_validation_error() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="/mock/folder"
  local RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS="${TEST_VERSION}"

  _backup_job_validation_argument_tarball_versions

  _backup_job_validation_error.mock.assert_called_once_with \
    "1(Invalid local tarball version count.) 2(_backup_job_message_tarball_versions)"
}

@parametrize_with_invalid_versions \
  test_backup_job_validation_remote_parameters_s3__with_tarball_folder_____invalid__@vary__generates_validation_error
