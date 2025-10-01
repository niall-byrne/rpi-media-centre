#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _backup_manifest_all_command
}

@parametrize_with_group_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_NAME" \
    "name1;name1" \
    "name2;name2"
}

test_backup_scheduler_queue_enqueue_name__@vary__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _backup_scheduler_queue_enqueue_name "${TEST_NAME}"

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_backup_manifest_all_command"
}

@parametrize_with_group_names \
  test_backup_scheduler_queue_enqueue_name__@vary__calls_dependencies_in_correct_sequence

test_backup_scheduler_queue_enqueue_name__@vary__logs_warning_message() {
  _backup_scheduler_queue_enqueue_name "${TEST_NAME}"

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Scheduling the '${TEST_NAME}' backup job ...)"
}

@parametrize_with_group_names \
  test_backup_scheduler_queue_enqueue_name__@vary__logs_warning_message

test_backup_scheduler_queue_enqueue_name__@vary__calls_manifest_all_command_with_correct_args() {
  _backup_scheduler_queue_enqueue_name "${TEST_NAME}"

  _backup_manifest_all_command.mock.assert_called_once_with \
    "1(_backup_manifest_write_jobs_all) 2() 3(${TEST_NAME})"
}

@parametrize_with_group_names \
  test_backup_scheduler_queue_enqueue_name__@vary__calls_manifest_all_command_with_correct_args
