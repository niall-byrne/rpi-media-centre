#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create _backup_job_log
  _mock.create _backup_job_message_queue
  _mock.create _cli_log_error

  RPI_BACKUP_QUEUE_NAMES=("queue1" "queue2")
  RPI_BACKUP_QUEUE_FAILED_TASK_EVENT="failed_task"
}

teardown() {
  unset RPI_BACKUP_QUEUE_NAMES
  unset RPI_BACKUP_QUEUE_FAILED_TASK_EVENT
}

@parametrize_with_valid_queues() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_QUEUE_NAME" \
    "valid_queue_1____;queue1" \
    "valid_queue_2____;queue2" \
    "failed_task_queue;failed_task"
}

test_backup_job_validation_queue__@vary__returns_status_code_0() {
  _capture.rc _backup_job_validation_queue "${TEST_QUEUE_NAME}"

  assert_rc "0"
}

@parametrize_with_valid_queues \
  test_backup_job_validation_queue__@vary__returns_status_code_0

test_backup_job_validation_queue__@vary__does_not_log_error() {
  _backup_job_validation_queue "queue1"

  _cli_log_error.mock.assert_not_called
}

@parametrize_with_valid_queues \
  test_backup_job_validation_queue__@vary__does_not_log_error

test_backup_job_validation_queue__@vary__produces_no_output() {
  _capture.output _backup_job_validation_queue "queue1"

  assert_output_null
}

@parametrize_with_valid_queues \
  test_backup_job_validation_queue__@vary__produces_no_output

test_backup_job_validation_queue__invalid_queue______returns_status_code_127() {
  _capture.rc _backup_job_validation_queue "invalid_queue"

  assert_rc "127"
}

test_backup_job_validation_queue__invalid_queue______logs_error() {

  _backup_job_validation_queue "invalid_queue"

  _cli_log_error.mock.assert_called_once_with \
    "1( -- BACKUP JOB: Invalid queue for this job.)"
}

test_backup_job_validation_queue__invalid_queue______logs_error_and_generates_stderr_in_sequence() {
  _mock.sequence.record.start

  _backup_job_validation_queue "invalid_queue"

  _mock.sequence.assert_is \
    "_cli_log_error" \
    "_backup_job_log" \
    "_backup_job_message_queue"
}

test_backup_job_validation_queue__invalid_queue______redirects_stdout_to_stderr() {
  _backup_job_log.mock.set.stdout "backup_job_log"
  _backup_job_message_queue.mock.set.stdout "backup_job_message_queue"

  _capture.stderr _backup_job_validation_queue "invalid_queue"

  assert_output "backup_job_log
backup_job_message_queue"
}

test_backup_job_validation_queue__invalid_queue______generates_no_stdout() {
  _backup_job_log.mock.set.stdout "backup_job_log"
  _backup_job_message_queue.mock.set.stdout "backup_job_message_queue"

  _capture.stdout _backup_job_validation_queue "invalid_queue"

  assert_output_null
}
