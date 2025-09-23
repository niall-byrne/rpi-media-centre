#!/bin/bash

setup() {
  _mock.create _cli_log_notice
  _mock.create stdlib.security.path.make.dir
  _mock.create rsync
}

@parametrize_with_rsync_jobs() {
  @parametrize \
    "${1}" \
    "TEST_BACKUP_JOB_LOCAL_SOURCE;TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER;TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION;TEST_SVC_USERNAME;TEST_SVC_GROUPNAME;TEST_EXPECTED_TARGET_DIR" \
    "foo_bar__to__baz_qux________;/foo/bar;/baz/qux;755;user1;group1;/baz/qux/bar-rsync-backup" \
    "path1_path2__to__path3_path4;/path1/path2;/path3/path4;750;user2;group2;/path3/path4/path2-rsync-backup"
}

# shellcheck disable=SC2034
test_backup_job_task_rsync_filesystem__@vary__logs_copy_notice() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_BACKUP_JOB_LOCAL_SOURCE}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION="${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION}"
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_task_rsync_filesystem

  _cli_log_notice.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Copying '${TEST_BACKUP_JOB_LOCAL_SOURCE}' with rsync ...)"
}

@parametrize_with_rsync_jobs \
  test_backup_job_task_rsync_filesystem__@vary__logs_copy_notice

# shellcheck disable=SC2034
test_backup_job_task_rsync_filesystem__@vary__creates_backup_directory() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_BACKUP_JOB_LOCAL_SOURCE}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION="${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION}"
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_task_rsync_filesystem

  stdlib.security.path.make.dir.mock.assert_called_once_with \
    "1(${TEST_EXPECTED_TARGET_DIR}) 2(${TEST_SVC_USERNAME}) 3(${TEST_SVC_GROUPNAME}) 4(${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION})"
}

@parametrize_with_rsync_jobs \
  test_backup_job_task_rsync_filesystem__@vary__creates_backup_directory

# shellcheck disable=SC2034
test_backup_job_task_rsync_filesystem__@vary__calls_rsync() {
  local RPI_BACKUP_JOB_LOCAL_SOURCE="${TEST_BACKUP_JOB_LOCAL_SOURCE}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER="${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER}"
  local RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION="${TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION}"
  local RPI_SVC_USERNAME="${TEST_SVC_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_SVC_GROUPNAME}"

  _backup_job_task_rsync_filesystem

  rsync.mock.assert_called_once_with \
    "1(-a) 2(--delete) 3(${TEST_BACKUP_JOB_LOCAL_SOURCE}) 4(${TEST_EXPECTED_TARGET_DIR}/)"
}

@parametrize_with_rsync_jobs \
  test_backup_job_task_rsync_filesystem__@vary__calls_rsync
