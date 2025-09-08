#!/bin/bash

setup() {
  _mock.create _event_script
  _mock.create export
}

teardown() {
  unset RPI_BACKUP_JOB_NAME
  unset RPI_BACKUP_JOB_LOCAL_SOURCE
  unset RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER
  unset RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
  unset RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS
  unset RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH
  unset RPI_BACKUP_JOB_REMOTE_TARGET
  unset RPI_BACKUP_JOB_QUEUE
}

@parametrize_with_variable_names() {
  @parametrize \
    "${1}" \
    "TEST_VARIABLE_NAME" \
    "job_name;RPI_BACKUP_JOB_NAME" \
    "local_source;RPI_BACKUP_JOB_LOCAL_SOURCE" \
    "rsync_folder;RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER" \
    "tarball_folder;RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER" \
    "tarball_versions;RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS" \
    "encryption_key;RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH" \
    "remote_target;RPI_BACKUP_JOB_REMOTE_TARGET" \
    "queue;RPI_BACKUP_JOB_QUEUE"
}

@parametrize_with_variable_values() {
  @parametrize \
    "${1}" \
    "RPI_BACKUP_JOB_NAME;RPI_BACKUP_JOB_LOCAL_SOURCE;RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER;RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER;RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS;RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH;RPI_BACKUP_JOB_REMOTE_TARGET;RPI_BACKUP_JOB_QUEUE" \
    "scenario1;job1;/src1;/rsync1;/tarball1;1;/key1;user1@host1:/target1;queue1" \
    "scenario2;job2;/src2;/rsync2;/tarball2;2;/key2;user2@host2:/target2;queue2"
}

test_backup_job_task_event_wrapper__calls_event_script_with_correct_argument() {
  local event_script="event-backup-job-task-before.sh"

  _backup_job_task_event_wrapper "${event_script}"

  _event_script.mock.assert_called_once_with \
    "1(${event_script})"
}

test_backup_job_task_event_wrapper__@vary__@vary__exports_variable() {
  _backup_job_task_event_wrapper "event.sh"

  export.mock.assert_count_is "8"
  export.mock.assert_any_call_is \
    "1(${TEST_VARIABLE_NAME})"
}

@parametrize.compose \
  test_backup_job_task_event_wrapper__@vary__@vary__exports_variable \
  @parametrize_with_variable_names \
  @parametrize_with_variable_values

test_backup_job_task_event_wrapper__@vary__@vary__exported_variable_has_correct_value() {
  local expected_value="${!TEST_VARIABLE_NAME}"

  _event_script.mock.set.keywords "${TEST_VARIABLE_NAME}"

  _backup_job_task_event_wrapper "event.sh"

  _event_script.mock.assert_called_once_with \
    "1(event.sh) ${TEST_VARIABLE_NAME}(${expected_value})"
}

@parametrize.compose \
  test_backup_job_task_event_wrapper__@vary__@vary__exported_variable_has_correct_value \
  @parametrize_with_variable_names \
  @parametrize_with_variable_values
