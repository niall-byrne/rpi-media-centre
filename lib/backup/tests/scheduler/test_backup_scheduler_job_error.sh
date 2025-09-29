#!/bin/bash

setup() {
  _mock.create _cli_log_error
  _mock.create _event_script
  _mock.create mock_job

  mock_job.mock.set.keywords "RPI_BACKUP_JOB_STATUS"
}

@parametrize_with_mock_jobs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_JOB_NAME;TEST_QUEUE_NAME" \
    "job1;job1;queue1"
}

# shellcheck disable=SC2034
test_backup_scheduler_job_error__@vary__no_scheduling_error__logs_expected_errors() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  mock_job.mock.set.rc 0

  _backup_scheduler_job_error "${TEST_QUEUE_NAME}" mock_job

  _cli_log_error.mock.assert_calls_are \
    "1(BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - has failed the '${TEST_QUEUE_NAME}' task !)" \
    "1(BACKUP SCHEDULER: This job will be retried tomorrow.)"
}

@parametrize_with_mock_jobs \
  test_backup_scheduler_job_error__@vary__no_scheduling_error__logs_expected_errors

# shellcheck disable=SC2034
test_backup_scheduler_job_error__@vary__no_scheduling_error__calls_mock_job_with_failed_status() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  mock_job.mock.set.rc 0

  _backup_scheduler_job_error "${TEST_QUEUE_NAME}" mock_job

  mock_job.mock.assert_called_once_with \
    "1(${TEST_QUEUE_NAME}) RPI_BACKUP_JOB_STATUS(${RPI_BACKUP_JOB_STATUSES[1]})"
}

@parametrize_with_mock_jobs \
  test_backup_scheduler_job_error__@vary__no_scheduling_error__calls_mock_job_with_failed_status

test_backup_scheduler_job_error__@vary__no_scheduling_error__does_not_generate_scheduler_error_event() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  mock_job.mock.set.rc 0

  _backup_scheduler_job_error "${TEST_QUEUE_NAME}" mock_job

  _event_script.mock.assert_not_called
}

@parametrize_with_mock_jobs \
  test_backup_scheduler_job_error__@vary__no_scheduling_error__does_not_generate_scheduler_error_event

# shellcheck disable=SC2034
test_backup_scheduler_job_error__@vary__scheduling_error_____logs_expected_errors() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  mock_job.mock.set.rc 1

  _backup_scheduler_job_error "${TEST_QUEUE_NAME}" mock_job

  _cli_log_error.mock.assert_calls_are \
    "1(BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - has failed the '${TEST_QUEUE_NAME}' task !)" \
    "1(BACKUP SCHEDULER: Backup job '${RPI_BACKUP_JOB_NAME}' - appears improperly configured !)"
}

@parametrize_with_mock_jobs \
  test_backup_scheduler_job_error__@vary__scheduling_error_____logs_expected_errors

# shellcheck disable=SC2034
test_backup_scheduler_job_error__@vary__scheduling_error_____calls_mock_job_with_failed_status() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  mock_job.mock.set.rc 1

  _backup_scheduler_job_error "${TEST_QUEUE_NAME}" mock_job

  mock_job.mock.assert_called_once_with \
    "1(${TEST_QUEUE_NAME}) RPI_BACKUP_JOB_STATUS(${RPI_BACKUP_JOB_STATUSES[1]})"
}

@parametrize_with_mock_jobs \
  test_backup_scheduler_job_error__@vary__scheduling_error_____calls_mock_job_with_failed_status

test_backup_scheduler_job_error__@vary__scheduling_error_____generates_scheduler_error_event() {
  local RPI_BACKUP_JOB_NAME="${TEST_JOB_NAME}"

  mock_job.mock.set.rc 1

  _backup_scheduler_job_error "${TEST_QUEUE_NAME}" mock_job

  _event_script.mock.assert_called_once_with \
    "1(event-backup-scheduler-error.sh)"
}

@parametrize_with_mock_jobs \
  test_backup_scheduler_job_error__@vary__scheduling_error_____generates_scheduler_error_event
