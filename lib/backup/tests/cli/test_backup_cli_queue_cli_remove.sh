#!/bin/bash

setup() {
  _mock.create _backup_cli_queue_cli_usage_error
  _mock.create _cli_log_warning
  _mock.create _backup_scheduler_make_queues
  _mock.create stdlib.io.stdin.confirmation
  _mock.create find
  _mock.create _cli_log_success
}

@parametrize_with_job_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_NAME" \
    "job1_______;job1" \
    "job2_______;job2"
}

test_backup_cli_queue_cli_remove__user_confirms__no_job_name__calls_usage_error() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove ""

  _backup_cli_queue_cli_usage_error.mock.assert_called_once_with ""
}

test_backup_cli_queue_cli_remove__user_denies____no_job_name__calls_usage_error() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove ""

  _backup_cli_queue_cli_usage_error.mock.assert_called_once_with ""
}

test_backup_cli_queue_cli_remove__user_confirms__@vary__logs_warning_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Remove queued backup jobs matching '${TEST_JOB_NAME}' ...)"
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_confirms__@vary__logs_warning_message

test_backup_cli_queue_cli_remove__user_denies____@vary__logs_warning_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _cli_log_warning.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Remove queued backup jobs matching '${TEST_JOB_NAME}' ...)"
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_denies____@vary__logs_warning_message

test_backup_cli_queue_cli_remove__user_confirms__@vary__creates_backup_queues() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _backup_scheduler_make_queues.mock.assert_called_once_with ""
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_confirms__@vary__creates_backup_queues

test_backup_cli_queue_cli_remove__user_denies____@vary__creates_backup_queues() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _backup_scheduler_make_queues.mock.assert_called_once_with ""
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_denies____@vary__creates_backup_queues

test_backup_cli_queue_cli_remove__user_confirms__@vary__calls_find_with_delete() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  find.mock.assert_called_once_with \
    "1(${RPI_BACKUP_PATH_QUEUE_ROOT}) 2(-type) 3(f) 4(-name) 5(${TEST_JOB_NAME}) 6(-delete)"
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_confirms__@vary__calls_find_with_delete

test_backup_cli_queue_cli_remove__user_denies____@vary__does_not_call_find() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  find.mock.assert_not_called
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_denies____@vary__does_not_call_find

test_backup_cli_queue_cli_remove__user_confirms__@vary__logs_success_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 0

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Queued backup jobs matching '${TEST_JOB_NAME}' have been removed !)"
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_confirms__@vary__logs_success_message

test_backup_cli_queue_cli_remove__user_denies____@vary__does_not_log_success_message() {
  stdlib.io.stdin.confirmation.mock.set.rc 1

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _cli_log_success.mock.assert_not_called
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_denies____@vary__does_not_log_success_message

test_backup_cli_queue_cli_remove__user_confirms__@vary__calls_dependencies_in_sequence() {
  stdlib.io.stdin.confirmation.mock.set.rc 0
  _mock.sequence.record.start

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_backup_scheduler_make_queues" \
    "stdlib.io.stdin.confirmation" \
    "find" \
    "_cli_log_success"
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_confirms__@vary__calls_dependencies_in_sequence

test_backup_cli_queue_cli_remove__user_denies____@vary__calls_dependencies_in_sequence() {
  stdlib.io.stdin.confirmation.mock.set.rc 1
  _mock.sequence.record.start

  _backup_cli_queue_cli_remove "${TEST_JOB_NAME}"

  _mock.sequence.assert_is \
    "_cli_log_warning" \
    "_backup_scheduler_make_queues" \
    "stdlib.io.stdin.confirmation"
}

@parametrize_with_job_names \
  test_backup_cli_queue_cli_remove__user_denies____@vary__calls_dependencies_in_sequence
