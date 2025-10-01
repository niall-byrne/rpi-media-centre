#!/bin/bash

setup() {
  _mock.create _backup_scheduler_queue_make
  _mock.create find
  _mock.create _cli_log_success
}

@parametrize_with_job_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_NAME;TEST_QUEUE_ROOT" \
    "job1;job1;/mnt/root" \
    "job2;job2;/var/queue"
}

# shellcheck disable=SC2034
test_backup_scheduler_queue_remove_name__@vary__creates_backup_queues() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_remove_name "${TEST_JOB_NAME}"

  _backup_scheduler_queue_make.mock.assert_called_once_with ""
}

@parametrize_with_job_names \
  test_backup_scheduler_queue_remove_name__@vary__creates_backup_queues

# shellcheck disable=SC2034
test_backup_scheduler_queue_remove_name__@vary__calls_find_with_delete() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_remove_name "${TEST_JOB_NAME}"

  find.mock.assert_called_once_with \
    "1(${TEST_QUEUE_ROOT}) 2(-type) 3(f) 4(-name) 5(${TEST_JOB_NAME}) 6(-delete)"
}

@parametrize_with_job_names \
  test_backup_scheduler_queue_remove_name__@vary__calls_find_with_delete

# shellcheck disable=SC2034
test_backup_scheduler_queue_remove_name__@vary__logs_success_message() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _backup_scheduler_queue_remove_name "${TEST_JOB_NAME}"

  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Queued backup jobs matching '${TEST_JOB_NAME}' have been removed !)"
}

@parametrize_with_job_names \
  test_backup_scheduler_queue_remove_name__@vary__logs_success_message

# shellcheck disable=SC2034
test_backup_scheduler_queue_remove_name__@vary__calls_dependencies_in_sequence() {
  local RPI_BACKUP_PATH_QUEUE_ROOT="${TEST_QUEUE_ROOT}"

  _mock.sequence.record.start

  _backup_scheduler_queue_remove_name "${TEST_JOB_NAME}"

  _mock.sequence.assert_is \
    "_backup_scheduler_queue_make" \
    "find" \
    "_cli_log_success"
}

@parametrize_with_job_names \
  test_backup_scheduler_queue_remove_name__@vary__calls_dependencies_in_sequence
