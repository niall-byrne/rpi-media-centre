#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create _backup_scheduler_make_queues
  _mock.create stdlib.io.stdin.confirmation
  _mock.create find
  _mock.create _cli_log_success
}

test_backup_cli_queue_cli_remove_all__user_confirms__logs_warning_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove-all

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Remove *all* queued backup jobs ...)"
}

test_backup_cli_queue_cli_remove_all__user_denies____logs_warning_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove-all

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Remove *all* queued backup jobs ...)"
}

test_backup_cli_queue_cli_remove_all__user_confirms__creates_backup_queues() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove-all

  _backup_scheduler_make_queues.mock.assert_called_once_with ""
}

test_backup_cli_queue_cli_remove_all__user_denies____creates_backup_queues() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove-all

  _backup_scheduler_make_queues.mock.assert_called_once_with ""
}

test_backup_cli_queue_cli_remove_all__user_confirms__calls_find_with_delete() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove-all

  find.mock.assert_called_once_with \
    "1(${RPI_BACKUP_PATH_QUEUE_ROOT}) 2(-type) 3(f) 4(-delete)"
}

test_backup_cli_queue_cli_remove_all__user_denies____does_not_call_find() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove-all

  find.mock.assert_not_called
}

test_backup_cli_queue_cli_remove_all__user_confirms__logs_success_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove-all

  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: All queued backup jobs have been removed !)"
}

test_backup_cli_queue_cli_remove_all__user_denies____does_not_log_success_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove-all

  _cli_log_success.mock.assert_not_called
}

test_backup_cli_queue_cli_remove_all__user_confirms__calls_dependencies_in_sequence() {
  stdlib.io.stdin.confirmation.mock.set.rc 0
  _mock.sequence.record.start

  _backup_cli_queue_cli_remove-all

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_backup_scheduler_make_queues" \
    "stdlib.io.stdin.confirmation" \
    "find" \
    "_cli_log_success"
}

test_backup_cli_queue_cli_remove_all__user_denies____calls_dependencies_in_sequence() {
  stdlib.io.stdin.confirmation.mock.set.rc 1
  _mock.sequence.record.start

  _backup_cli_queue_cli_remove-all

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_backup_scheduler_make_queues" \
    "stdlib.io.stdin.confirmation"
}
