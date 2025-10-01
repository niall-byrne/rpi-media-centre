#!/bin/bash

setup() {
  _mock.create _cli_log_warning
  _mock.create stdlib.io.stdin.confirmation
  _mock.create _backup_scheduler_queue_remove_all
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
test_backup_cli_queue_cli_remove_all__@vary__user_confirms__logs_warning_message() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove-all

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Remove *all* queued backup jobs ...)"
}

@parametrize_with_queue_paths \
  test_backup_cli_queue_cli_remove_all__@vary__user_confirms__logs_warning_message

# shellcheck disable=SC2034
test_backup_cli_queue_cli_remove_all__@vary__user_denies__logs_warning_message() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove-all

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Remove *all* queued backup jobs ...)"
}

@parametrize_with_queue_paths \
  test_backup_cli_queue_cli_remove_all__@vary__user_denies__logs_warning_message

# shellcheck disable=SC2034
test_backup_cli_queue_cli_remove_all__@vary__user_confirms__calls_remove_all() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove-all

  _backup_scheduler_queue_remove_all.mock.assert_called_once_with ""
}

@parametrize_with_queue_paths \
  test_backup_cli_queue_cli_remove_all__@vary__user_confirms__calls_remove_all

# shellcheck disable=SC2034
test_backup_cli_queue_cli_remove_all__@vary__user_denies____does_not_call_remove_all() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove-all

  _backup_scheduler_queue_remove_all.mock.assert_not_called
}

@parametrize_with_queue_paths \
  test_backup_cli_queue_cli_remove_all__@vary__user_denies____does_not_call_remove_all

# shellcheck disable=SC2034
test_backup_cli_queue_cli_remove_all__@vary__user_confirms__calls_dependencies_in_sequence() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  stdlib.io.stdin.confirmation.mock.set.rc 0
  _mock.sequence.record.start

  _backup_cli_queue_cli_remove-all

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "stdlib.io.stdin.confirmation" \
    "_backup_scheduler_queue_remove_all"
}

@parametrize_with_queue_paths \
  test_backup_cli_queue_cli_remove_all__@vary__user_confirms__calls_dependencies_in_sequence

# shellcheck disable=SC2034
test_backup_cli_queue_cli_remove_all__@vary__user_denies____calls_dependencies_in_sequence() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  stdlib.io.stdin.confirmation.mock.set.rc 1
  _mock.sequence.record.start

  _backup_cli_queue_cli_remove-all

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "stdlib.io.stdin.confirmation"
}

@parametrize_with_queue_paths \
  test_backup_cli_queue_cli_remove_all__@vary__user_denies____calls_dependencies_in_sequence
