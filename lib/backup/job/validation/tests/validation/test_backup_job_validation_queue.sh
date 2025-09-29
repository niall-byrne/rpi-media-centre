#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  RPI_BACKUP_QUEUE_NAMES=("queue1" "queue2")
  RPI_BACKUP_FAILED_JOB_QUEUE_NAME="failed_task"
}

teardown_suite() {
  unset RPI_BACKUP_QUEUE_NAMES
  unset RPI_BACKUP_FAILED_JOB_QUEUE_NAME
}

# shellcheck disable=SC2034
setup() {
  _mock.create _backup_job_log
  _mock.create _backup_job_message_queue
  _mock.create _backup_job_validation_error
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
  local RPI_BACKUP_JOB_QUEUE="${TEST_QUEUE_NAME}"

  _capture.rc _backup_job_validation_queue

  assert_rc "0"
}

@parametrize_with_valid_queues \
  test_backup_job_validation_queue__@vary__returns_status_code_0

test_backup_job_validation_queue__@vary__does_not_call_validation_error() {
  local RPI_BACKUP_JOB_QUEUE="${TEST_QUEUE_NAME}"

  _backup_job_validation_queue

  _backup_job_validation_error.mock.assert_not_called
}

@parametrize_with_valid_queues \
  test_backup_job_validation_queue__@vary__does_not_call_validation_error

test_backup_job_validation_queue__@vary__produces_no_output() {
  local RPI_BACKUP_JOB_QUEUE="${TEST_QUEUE_NAME}"

  _capture.output _backup_job_validation_queue

  assert_output_null
}

@parametrize_with_valid_queues \
  test_backup_job_validation_queue__@vary__produces_no_output

test_backup_job_validation_queue__invalid_queue______calls_validation_error() {
  local RPI_BACKUP_JOB_QUEUE="invalid_queue"

  _backup_job_validation_queue

  _backup_job_validation_error.mock.assert_called_once_with \
    "1(Invalid queue for this job.) 2(_backup_job_message_queue)"
}
