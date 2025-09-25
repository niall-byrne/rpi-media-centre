#!/bin/bash

setup() {
  _mock.create _dependencies_group_backups_tarball
}

@parametrize_with_tarball_folder_set() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCAL_TARBALL_FOLDER" \
    "tarball_folder_set    ;foo"
}

@parametrize_with_tarball_folder_not_set() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCAL_TARBALL_FOLDER" \
    "tarball_folder_not_set;;"
}

test_backup_job_validation_dependency_tarball__@vary__calls_tarball_dependency_check() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_LOCAL_TARBALL_FOLDER}"

  _backup_job_validation_dependency_tarball

  _dependencies_group_backups_tarball.mock.assert_called_once_with ""
}

@parametrize_with_tarball_folder_set \
  test_backup_job_validation_dependency_tarball__@vary__calls_tarball_dependency_check

test_backup_job_validation_dependency_tarball__@vary__skips_tarball_dependency_check() {
  local RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER="${TEST_LOCAL_TARBALL_FOLDER}"

  _backup_job_validation_dependency_tarball

  _dependencies_group_backups_tarball.mock.assert_not_called
}

@parametrize_with_tarball_folder_not_set \
  test_backup_job_validation_dependency_tarball__@vary__skips_tarball_dependency_check