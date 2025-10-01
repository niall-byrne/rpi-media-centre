#!/bin/bash

setup() {
  _mock.create _backup_scheduler_queue_make
  _mock.create find
  _mock.create _cli_log_success
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
test_backup_scheduler_queue_remove_all__@vary__creates_backup_queues() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_remove_all

  _backup_scheduler_queue_make.mock.assert_called_once_with ""
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_remove_all__@vary__creates_backup_queues

# shellcheck disable=SC2034
test_backup_scheduler_queue_remove_all__@vary__calls_find_with_delete() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_remove_all

  find.mock.assert_called_once_with \
    "1(${TEST_QUEUE_ROOT}) 2(-type) 3(f) 4(-delete)"
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_remove_all__@vary__calls_find_with_delete

# shellcheck disable=SC2034
test_backup_scheduler_queue_remove_all__@vary__logs_success_message() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_remove_all

  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: All queued backup jobs have been removed !)"
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_remove_all__@vary__logs_success_message

# shellcheck disable=SC2034
test_backup_scheduler_queue_remove_all__@vary__calls_dependencies_in_sequence() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _mock.sequence.record.start

  _backup_scheduler_queue_remove_all

  _mock.sequence.assert_is \
    "_backup_scheduler_queue_make" \
    "find" \
    "_cli_log_success"
}

@parametrize_with_queue_paths \
  test_backup_scheduler_queue_remove_all__@vary__calls_dependencies_in_sequence
