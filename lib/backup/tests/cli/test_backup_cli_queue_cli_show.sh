#!/bin/bash

setup() {
  _mock.create _backup_scheduler_make_queues
  _mock.create _dependencies_group_backups_cli_queue
  _mock.create tree
}

test_backup_cli_queue_cli_show__calls_dependencies_in_sequence() {
  _mock.sequence.record.start

  _backup_cli_queue_cli_show

  _mock.sequence.assert_is \
    "_backup_scheduler_make_queues" \
    "_dependencies_group_backups_cli_queue" \
    "tree"
}

# shellcheck disable=SC2034
test_backup_cli_queue_cli_show__creates_backup_queues() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="/path/to/queue"

  _backup_cli_queue_cli_show

  _backup_scheduler_make_queues.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_cli_queue_cli_show__checks_backup_queue_show_dependencies() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="/path/to/queue"

  _backup_cli_queue_cli_show

  _dependencies_group_backups_cli_queue.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_cli_queue_cli_show__calls_tree_with_correct_path() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="/path/to/queue"

  _backup_cli_queue_cli_show

  tree.mock.assert_called_once_with \
    "1(/path/to/queue)"
}
