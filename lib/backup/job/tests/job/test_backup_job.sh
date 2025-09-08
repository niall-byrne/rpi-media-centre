#!/bin/bash

setup_suite() {
  job_parameter_set=(
    RPI_BACKUP_JOB_NAME
    RPI_BACKUP_JOB_GROUP
    RPI_BACKUP_JOB_LOCAL_SOURCE
    RPI_BACKUP_JOB_LOCAL_RSYNC_FOLDER
    RPI_BACKUP_JOB_LOCAL_TARBALL_FOLDER
    RPI_BACKUP_JOB_LOCAL_TARBALL_VERSIONS
    RPI_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH
    RPI_BACKUP_JOB_REMOTE_TARGET
    RPI_BACKUP_JOB_REMOTE_PARAMETER
    RPI_BACKUP_JOB_QUEUE
  )
}

setup() {
  _mock.create _backup_job_args
  _mock.create _cli_log_notice
  _mock.create _backup_job_task_event_wrapper
  _mock.create _backup_job_cli

  _backup_job_args.mock.set.subcommand "_fixture_load_backup_job_parameters"
  _backup_job_task_event_wrapper.mock.set.keywords "RPI_BACKUP_JOB_QUEUE"
}

_fixture_load_backup_job_parameters() {
  local job_variable
  local test_variable

  for job_variable in "${job_parameter_set[@]}"; do
    test_variable="${job_variable/RPI_/TEST_}"
    printf -v "${job_variable}" "%s" "${!test_variable}"
  done
}

@parametrize_with_args() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_ARGS_DEFINITION" \
    "0_arguments______;;" \
    "1_argument_______;arg1" \
    "2_arguments______;arg1|arg2"
}

@parametrize_with_jobs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_BACKUP_JOB_NAME;TEST_BACKUP_JOB_GROUP;TEST_BACKUP_JOB_LOCAL_SOURCE;TEST_BACKUP_JOB_LOCAL_RSYNC_FOLDER;TEST_BACKUP_JOB_LOCAL_TARBALL_FOLDER;TEST_BACKUP_JOB_LOCAL_TARBALL_VERSIONS;TEST_BACKUP_JOB_REMOTE_ENCRYPTION_KEY_PATH;TEST_BACKUP_JOB_REMOTE_TARGET;TEST_BACKUP_JOB_REMOTE_PARAMETER;TEST_BACKUP_JOB_QUEUE" \
    "scenario1;job_name1;job_group1;local_source1;rsync_folder1;tarball_folder1;tarball_versions1;key_path1;remote_target1;remote_param1;job_queue1" \
    "scenario2;job_name2;job_group2;local_source2;rsync_folder2;tarball_folder2;tarball_versions2;key_path2;remote_target2;remote_param2;job_queue2"
}

# shellcheck disable=SC2034
test_backup_job__@vary__@vary__passes_all_received_arguments_to_backup_args() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _backup_job "${command_args[@]}"

  _backup_job_args.mock.assert_called_once_with \
    "$(_mock.arg_string.from_array command_args)"
}

@parametrize.compose \
  test_backup_job__@vary__@vary__passes_all_received_arguments_to_backup_args \
  @parametrize_with_jobs \
  @parametrize_with_args

# shellcheck disable=SC2034
test_backup_job__@vary__failure_event______logs_correct_messages() {
  local RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="${TEST_BACKUP_JOB_QUEUE}"

  _backup_job

  _cli_log_notice.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Executing '${TEST_BACKUP_JOB_QUEUE}' task for job '${TEST_BACKUP_JOB_NAME}' ...)"
}

@parametrize_with_jobs \
  test_backup_job__@vary__failure_event______logs_correct_messages

# shellcheck disable=SC2034
test_backup_job__@vary__failure_event______calls_error_event_wrapper() {
  local RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="${TEST_BACKUP_JOB_QUEUE}"
  local RPI_BACKUP_JOB_FAILURE_QUEUE="MOCKED_FAILURE_QUEUE_NAME"

  _backup_job

  _backup_job_task_event_wrapper.mock.assert_called_once_with \
    "1(event-backup-job-task-error.sh) RPI_BACKUP_JOB_QUEUE(${RPI_BACKUP_JOB_FAILURE_QUEUE})"
}

@parametrize_with_jobs \
  test_backup_job__@vary__failure_event______calls_error_event_wrapper

# shellcheck disable=SC2034
test_backup_job__@vary__failure_event______does_not_call_backup_cli() {
  local RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="${TEST_BACKUP_JOB_QUEUE}"

  _backup_job

  _backup_job_cli.mock.assert_not_called
}

@parametrize_with_jobs \
  test_backup_job__@vary__failure_event______does_not_call_backup_cli

# shellcheck disable=SC2034
test_backup_job__@vary__failure_event______returns_0() {
  local RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="${TEST_BACKUP_JOB_QUEUE}"

  _capture.rc _backup_job

  assert_rc 0
}

@parametrize_with_jobs \
  test_backup_job__@vary__failure_event______returns_0

# shellcheck disable=SC2034
test_backup_job__@vary__non_failure_event__logs_correct_messages() {
  local RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="MOCKED_NON_MATCHING_QUEUE_NAME"

  _backup_job

  _cli_log_notice.mock.assert_calls_are \
    "1( -- BACKUP JOB: Executing '${TEST_BACKUP_JOB_QUEUE}' task for job '${TEST_BACKUP_JOB_NAME}' ...)" \
    "1( -- BACKUP JOB: Completed '${TEST_BACKUP_JOB_QUEUE}' task for job '${TEST_BACKUP_JOB_NAME}' !)"
}

@parametrize_with_jobs \
  test_backup_job__@vary__non_failure_event__logs_correct_messages

# shellcheck disable=SC2034
test_backup_job__@vary__non_failure_event__calls_backup_cli_with_correct_queue() {
  local RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="MOCKED_NON_MATCHING_QUEUE_NAME"

  _backup_job

  _backup_job_cli.mock.assert_called_once_with "1(${TEST_BACKUP_JOB_QUEUE})"
}

@parametrize_with_jobs \
  test_backup_job__@vary__non_failure_event__calls_backup_cli_with_correct_queue

# shellcheck disable=SC2034
test_backup_job__@vary__non_failure_event__does_not_call_error_event_wrapper() {
  local RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="MOCKED_NON_MATCHING_QUEUE_NAME"

  _backup_job

  _backup_job_task_event_wrapper.mock.assert_not_called
}

@parametrize_with_jobs \
  test_backup_job__@vary__non_failure_event__does_not_call_error_event_wrapper
