#!/bin/bash

setup() {
  _mock.create _backup_job_task_event_wrapper
  _mock.create _mock_command
}

@parametrize_with_command_args() {
  @parametrize \
    "${1}" \
    "TEST_COMMAND_ARGS_DEFINITION" \
    "no_args;;" \
    "one_arg;arg1" \
    "two_args;arg1|arg2"
}

test_backup_job_task_wrapper__@vary__calls_events_and_command_in_correct_sequence() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  _mock.sequence.record.start

  _backup_job_task_wrapper _mock_command "${command_args[@]}"

  _mock.sequence.assert_is \
    "_backup_job_task_event_wrapper" \
    "_mock_command" \
    "_backup_job_task_event_wrapper"
}

@parametrize_with_command_args \
  test_backup_job_task_wrapper__@vary__calls_events_and_command_in_correct_sequence

test_backup_job_task_wrapper__@vary__calls_event_wrapper_with_correct_arguments() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _backup_job_task_wrapper _mock_command "${command_args[@]}"

  _backup_job_task_event_wrapper.mock.assert_calls_are \
    "1(event-backup-job-task-before.sh)" \
    "1(event-backup-job-task-after.sh)"
}

@parametrize_with_command_args \
  test_backup_job_task_wrapper__@vary__calls_event_wrapper_with_correct_arguments

test_backup_job_task_wrapper__@vary__executes_command_with_correct_arguments() {
  local command_args=()

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _backup_job_task_wrapper _mock_command "${command_args[@]}"

  _mock_command.mock.assert_called_once_with \
    "$(_mock.arg_string.from_array command_args)"
}

@parametrize_with_command_args \
  test_backup_job_task_wrapper__@vary__executes_command_with_correct_arguments

test_backup_job_task_wrapper__@vary__exports_command_array_to_event_script_subshell() {
  local command_args=()
  local expected_array=()
  local expected_array_definition

  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"
  expected_array=("_mock_command" "${command_args[@]}")
  expected_array_definition="$(
    declare -p expected_array
    declare -p expected_array
  )"

  _backup_job_task_event_wrapper.mock.set.subcommand 'declare -p RPI_BACKUP_JOB_COMMAND'

  _capture.output _backup_job_task_wrapper _mock_command "${command_args[@]}"

  assert_output "${expected_array_definition//declare -a expected_array/declare -ax RPI_BACKUP_JOB_COMMAND}"
}

@parametrize_with_command_args \
  test_backup_job_task_wrapper__@vary__exports_command_array_to_event_script_subshell
