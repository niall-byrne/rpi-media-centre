#!/bin/bash

setup() {
  _mock.create _backup_cli_usage_error
  _mock.create _is_disk_mounted_all
  _mock.create _control_lock
  _mock.create _backup_scheduler_make_queues
  _mock.create _cli_log_warning
  _mock.create _backup_manifest_all_command
  _mock.create _cli_log_success
}

@parametrize_with_group_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_GROUP_NAME" \
    "group1__;group1" \
    "group2__;group2"
}

test_backup_cli_schedule__no_group__calls_usage_error() {
  _backup_cli_schedule ""

  _backup_cli_usage_error.mock.assert_called_once_with ""
}

test_backup_cli_schedule__@vary__calls_dependencies_in_sequence() {
  _mock.sequence.record.start

  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _mock.sequence.assert_is \
    "_is_disk_mounted_all" \
    "_control_lock" \
    "_backup_scheduler_make_queues" \
    "_cli_log_warning" \
    "_backup_manifest_all_command" \
    "_cli_log_success"
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__calls_dependencies_in_sequence

test_backup_cli_schedule__@vary__checks_disks_are_all_mounted() {
  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _is_disk_mounted_all.mock.assert_called_once_with ""
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__checks_disks_are_all_mounted

test_backup_cli_schedule__@vary__calls_control_lock_with_correct_args() {
  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _control_lock.mock.assert_called_once_with \
    "1(rpi-backup-scheduler.pid) 2(15)"
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__calls_control_lock_with_correct_args

test_backup_cli_schedule__@vary__creates_scheduler_queues() {
  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _backup_scheduler_make_queues.mock.assert_called_once_with ""
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__creates_scheduler_queues

test_backup_cli_schedule__@vary__logs_warning_message() {
  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Scheduling the '${TEST_GROUP_NAME}' group of backup jobs ...)"
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__logs_warning_message

test_backup_cli_schedule__@vary__calls_manifest_all_command_with_correct_args() {
  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _backup_manifest_all_command.mock.assert_called_once_with \
    "1(_backup_manifest_write_jobs_all) 2(${TEST_GROUP_NAME})"
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__calls_manifest_all_command_with_correct_args

test_backup_cli_schedule__@vary__logs_success_message() {
  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Scheduling complete !)"
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__logs_success_message
