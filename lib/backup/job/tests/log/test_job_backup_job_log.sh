#!/bin/bash

setup_suite() {
  _VARS_QUEUE_SET______GROUP_SET____=(
    "RPI_BACKUP_JOB_NAME"
    "RPI_BACKUP_JOB_GROUP"
    "RPI_BACKUP_JOB_LOCAL_SOURCE"
    "RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS"
    "RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH"
    "RPI_BACKUP_JOB_REMOTE_TARGET"
    "RPI_BACKUP_JOB_REMOTE_PARAMETER"
    "RPI_BACKUP_JOB_QUEUE"
  )
  _VARS_QUEUE_NOT_SET__GROUP_NOT_SET=(
    "RPI_BACKUP_JOB_NAME"
    "RPI_BACKUP_JOB_LOCAL_SOURCE"
    "RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS"
    "RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH"
    "RPI_BACKUP_JOB_REMOTE_TARGET"
    "RPI_BACKUP_JOB_REMOTE_PARAMETER"
  )
  _VARS_QUEUE_NOT_SET__GROUP_SET____=(
    "RPI_BACKUP_JOB_NAME"
    "RPI_BACKUP_JOB_GROUP"
    "RPI_BACKUP_JOB_LOCAL_SOURCE"
    "RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS"
    "RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH"
    "RPI_BACKUP_JOB_REMOTE_TARGET"
    "RPI_BACKUP_JOB_REMOTE_PARAMETER"
  )
  _VARS_QUEUE_SET______GROUP_NOT_SET=(
    "RPI_BACKUP_JOB_NAME"
    "RPI_BACKUP_JOB_LOCAL_SOURCE"
    "RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER"
    "RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS"
    "RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH"
    "RPI_BACKUP_JOB_REMOTE_TARGET"
    "RPI_BACKUP_JOB_REMOTE_PARAMETER"
    "RPI_BACKUP_JOB_QUEUE"
  )
}

teardown() {
  local variable_name

  for variable_name in "${_VARS_QUEUE_SET_GROUP_SET[@]}"; do
    unset "${variable_name}"
  done
}

@parametrize_with_job_log_scenarios() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_BACKUP_JOB_NAME;RPI_BACKUP_JOB_GROUP;RPI_BACKUP_JOB_LOCAL_SOURCE;RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER;RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION;RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER;RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER_PERMISSION;RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS;RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH;RPI_BACKUP_JOB_REMOTE_TARGET;RPI_BACKUP_JOB_REMOTE_PARAMETER;RPI_BACKUP_JOB_QUEUE" \
    "QUEUE_SET______GROUP_SET____;job_name;job_group;local_source;rsync_folder;rsync_folder_permission;tarball_folder;tarball_folder_permission;tarball_versions;key_path;remote_target;remote_param;job_queue" \
    "QUEUE_NOT_SET__GROUP_NOT_SET;job_name;;local_source;rsync_folder;rsync_folder_permission;tarball_folder;tarball_folder_permission;tarball_versions;key_path;remote_target;remote_param;;" \
    "QUEUE_NOT_SET__GROUP_SET____;job_name;job_group;local_source;rsync_folder;rsync_folder_permission;tarball_folder;tarball_folder_permission;tarball_versions;key_path;remote_target;remote_param;;" \
    "QUEUE_SET______GROUP_NOT_SET;job_name;;local_source;rsync_folder;rsync_folder_permission;tarball_folder;tarball_folder_permission;tarball_versions;key_path;remote_target;remote_param;job_queue"
}

test_backup_job_log__@vary__permissions_set____returns_expected_string() {
  _capture.output _backup_job_log

  assert_snapshot "__fixtures__/with_permissions/${PARAMETRIZE_SCENARIO_NAME}.txt"
}

@parametrize_with_job_log_scenarios \
  test_backup_job_log__@vary__permissions_set____returns_expected_string

test_backup_job_log__@vary__permissions_unset__returns_expected_string() {
  unset RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER_PERMISSION
  unset RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER_PERMISSION

  _capture.output _backup_job_log

  assert_snapshot "__fixtures__/without_permissions/${PARAMETRIZE_SCENARIO_NAME}.txt"
}

@parametrize_with_job_log_scenarios \
  test_backup_job_log__@vary__permissions_unset__returns_expected_string
