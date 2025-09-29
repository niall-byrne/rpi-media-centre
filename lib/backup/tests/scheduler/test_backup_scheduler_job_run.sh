#!/bin/bash

setup() {
  _fixture_mock_logs

  _mock.create basename
  _mock.create mock_job
  _mock.create _backup_scheduler_job_promote
  _mock.create _backup_scheduler_job_error

  TEST_QUEUE1_NAME="QUEUE1"
}

_fixture_setup_mocks() {
  mock_job.mock.set.rc "${TEST_JOB_RC}"
  basename.mock.set.stdout "${TEST_JOB_NAME}"
}

@parametrize_with_successful_job() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_setup_mocks" \
    "TEST_JOB_RC;TEST_JOB_NAME" \
    "job_succeeds;0;mocked_successful_job"
}

@parametrize_with_unsuccessful_job() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_setup_mocks" \
    "TEST_JOB_RC;TEST_JOB_NAME" \
    "job_fails;1;mocked_failed_job"
}

test_backup_scheduler_job_run__@vary__@vary__calls_basename_to_identify_job() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  basename.mock.assert_called_once_with "1(mock_job)"
}

@parametrize.apply \
  test_backup_scheduler_job_run__@vary__@vary__calls_basename_to_identify_job \
  @parametrize_with_successful_job \
  @parametrize_with_unsuccessful_job

test_backup_scheduler_job_run__@vary__starts_the_job_with_status_ok() {
  mock_job.mock.set.keywords "RPI_BACKUP_JOB_STATUS"

  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  mock_job.mock.assert_called_once_with \
    "1(${TEST_QUEUE1_NAME}) RPI_BACKUP_JOB_STATUS(${RPI_BACKUP_JOB_STATUSES[0]})"
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__starts_the_job_with_status_ok

test_backup_scheduler_job_run__@vary__returns_status_code_0() {
  _capture.rc _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  assert_rc "0"
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__returns_status_code_0

test_backup_scheduler_job_run__@vary__logs_expected_messages() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _cli_log_notice.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Backup job '${TEST_JOB_NAME}' - is starting the '${TEST_QUEUE1_NAME}' task ...)"
  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Backup job '${TEST_JOB_NAME}' - is completed the '${TEST_QUEUE1_NAME}' task !)"
  _cli_log_error.mock.assert_not_called
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__logs_expected_messages

test_backup_scheduler_job_run__@vary__promotes_job() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _backup_scheduler_job_promote.mock.assert_called_once_with \
    "1(${TEST_QUEUE1_NAME}) 2(mock_job) 3(${TEST_JOB_NAME})"
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__promotes_job

test_backup_scheduler_job_run__@vary__does_not_log_success_message() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _cli_log_success.mock.assert_not_called
}

@parametrize_with_unsuccessful_job \
  test_backup_scheduler_job_run__@vary__does_not_log_success_message

test_backup_scheduler_job_run__@vary__calls_scheduler_job_error() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _backup_scheduler_job_error.mock.assert_called_once_with \
    "1(${TEST_QUEUE1_NAME}) 2(mock_job)"
}

@parametrize_with_unsuccessful_job \
  test_backup_scheduler_job_run__@vary__calls_scheduler_job_error

test_backup_scheduler_job_run__@vary__still_returns_status_code_0() {
  _capture.rc _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  assert_rc "0"
}

@parametrize_with_unsuccessful_job \
  test_backup_scheduler_job_run__@vary__still_returns_status_code_0
