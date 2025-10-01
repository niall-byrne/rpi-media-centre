#!/bin/bash

setup() {
  _mock.create _backup_scheduler_queue_make
  _mock.create _dependencies_group_backups_cli_queue
  _mock.create tree
}

@parametrize_with_queue_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_QUEUE_ROOT" \
    "path1;/mnt/root" \
    "path2;/var/queue"
}

# shellcheck disable=SC2034
test_backup_scheduler_queue_show__@vary__calls_dependencies_in_sequence() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _mock.sequence.record.start

  _backup_scheduler_queue_show

  _mock.sequence.assert_is \
    "_backup_scheduler_queue_make" \
    "_dependencies_group_backups_cli_queue" \
    "tree"
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_show__@vary__calls_dependencies_in_sequence

# shellcheck disable=SC2034
test_backup_scheduler_queue_show__@vary__creates_backup_queues() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_show

  _backup_scheduler_queue_make.mock.assert_called_once_with ""
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_show__@vary__creates_backup_queues

# shellcheck disable=SC2034
test_backup_scheduler_queue_show__@vary__checks_backup_queue_show_dependencies() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_show

  _dependencies_group_backups_cli_queue.mock.assert_called_once_with ""
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_show__@vary__checks_backup_queue_show_dependencies

# shellcheck disable=SC2034
test_backup_scheduler_queue_show__@vary__calls_tree_with_correct_path() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_show

  tree.mock.assert_called_once_with \
    "1(${TEST_QUEUE_ROOT})"
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_show__@vary__calls_tree_with_correct_path
