#!/bin/bash

setup() {
  _mock.create _dependencies_group_backups_cli_queue
  _mock.create _backup_scheduler_queue_show
}

test_backup_cli_queue_cli_show__calls_dependencies_in_sequence() {
  _mock.sequence.record.start

  _backup_cli_queue_cli_show

  _mock.sequence.assert_is \
    "_dependencies_group_backups_cli_queue" \
    "_backup_scheduler_queue_show"
}

# shellcheck disable=SC2034
test_backup_cli_queue_cli_show__checks_backup_queue_show_dependencies() {
  _backup_cli_queue_cli_show

  _dependencies_group_backups_cli_queue.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_cli_queue_cli_show__calls_queue_show() {
  _backup_cli_queue_cli_show

  _backup_scheduler_queue_show.mock.assert_called_once_with ""
}
