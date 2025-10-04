#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _backup_manifest_command_all
}

@parametrize_with_group_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_GROUP_NAME" \
    "group1;group1" \
    "group2;group2"
}

test_backup_scheduler_queue_enqueue_group__@vary__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _backup_scheduler_queue_enqueue_group "${TEST_GROUP_NAME}"

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_backup_manifest_command_all"
}

@parametrize_with_group_names \
  test_backup_scheduler_queue_enqueue_group__@vary__calls_dependencies_in_correct_sequence

test_backup_scheduler_queue_enqueue_group__@vary__logs_warning_message() {
  _backup_scheduler_queue_enqueue_group "${TEST_GROUP_NAME}"

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Scheduling the '${TEST_GROUP_NAME}' group of backup jobs ...)"
}

@parametrize_with_group_names \
  test_backup_scheduler_queue_enqueue_group__@vary__logs_warning_message

test_backup_scheduler_queue_enqueue_group__@vary__calls_manifest_all_command_with_correct_args() {
  _backup_scheduler_queue_enqueue_group "${TEST_GROUP_NAME}"

  _backup_manifest_command_all.mock.assert_called_once_with \
    "1(_backup_manifest_command_write_job) 2(${TEST_GROUP_NAME})"
}

@parametrize_with_group_names \
  test_backup_scheduler_queue_enqueue_group__@vary__calls_manifest_all_command_with_correct_args
