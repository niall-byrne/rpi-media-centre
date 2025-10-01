#!/bin/bash

setup() {
  _mock.create _backup_cli_usage_error
  _mock.create _backup_scheduler_queue_enqueue
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

test_backup_cli_schedule__@vary__calls_dependencies_in_correct_sequence() {
  _mock.sequence.record.start

  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _mock.sequence.assert_is \
    "_backup_scheduler_queue_enqueue"
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__calls_dependencies_in_correct_sequence

test_backup_cli_schedule__@vary__calls_enqueue_correctly() {
  _backup_cli_schedule "${TEST_GROUP_NAME}"

  _backup_scheduler_queue_enqueue.mock.assert_called_once_with \
    "1(group) 2(${TEST_GROUP_NAME})"
}

@parametrize_with_group_names \
  test_backup_cli_schedule__@vary__calls_enqueue_correctly
