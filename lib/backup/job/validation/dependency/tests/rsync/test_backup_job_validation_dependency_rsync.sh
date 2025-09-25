#!/bin/bash

setup() {
  _mock.create _dependencies_group_backups_rsync
}

@parametrize_with_rsync_folder_set() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCAL_RSYNC_FOLDER" \
    "rsync_folder_set;foo"
}

@parametrize_with_rsync_folder_not_set() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCAL_RSYNC_FOLDER" \
    "rsync_folder_not_set;;"
}

test_backup_job_validation_dependency_rsync__@vary__calls_rsync_dependency_check() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_LOCAL_RSYNC_FOLDER}"

  _backup_job_validation_dependency_rsync

  _dependencies_group_backups_rsync.mock.assert_called_once_with ""
}

@parametrize_with_rsync_folder_set \
  test_backup_job_validation_dependency_rsync__@vary__calls_rsync_dependency_check

test_backup_job_validation_dependency_rsync__@vary__skips_rsync_dependency_check() {
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_LOCAL_RSYNC_FOLDER}"

  _backup_job_validation_dependency_rsync

  _dependencies_group_backups_rsync.mock.assert_not_called
}

@parametrize_with_rsync_folder_not_set \
  test_backup_job_validation_dependency_rsync__@vary__skips_rsync_dependency_check