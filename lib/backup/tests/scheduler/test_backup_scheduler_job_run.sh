#!/bin/bash

setup() {
  _fixture_mock_logs

  _mock.create basename
  _mock.create mock_job
  _mock.create _backup_scheduler_job_promote
  _mock.create _event_script

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
    "TEST_JOB_RC,TEST_JOB_NAME" \
    "job_succeeds,0,mocked_successful_job"
}

@parametrize_with_unsuccessful_job() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_setup_mocks" \
    "TEST_JOB_RC,TEST_JOB_NAME" \
    "job_fails,1,mocked_failed_job"
}

test_backup_scheduler_job_run__@vary__@vary__calls_basename_to_identify_job() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  basename.mock.assert_called_once_with "mock_job"
}

@parametrize.apply \
  test_backup_scheduler_job_run__@vary__@vary__calls_basename_to_identify_job \
  @parametrize_with_successful_job \
  @parametrize_with_unsuccessful_job

test_backup_scheduler_job_run__@vary__starts_the_job() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  mock_job.mock.assert_called_once_with "${TEST_QUEUE1_NAME}"
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__starts_the_job

test_backup_scheduler_job_run__@vary__returns_status_code_0() {
  _capture.rc _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  assert_rc "0"
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__returns_status_code_0

test_backup_scheduler_job_run__@vary__logs_expected_messages() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _cli_log_notice.mock.assert_called_once_with \
    "BACKUP SCHEDULER: Backup job '${TEST_JOB_NAME}' - is starting the '${TEST_QUEUE1_NAME}' task ..."
  _cli_log_success.mock.assert_called_once_with \
    "BACKUP SCHEDULER: Backup job '${TEST_JOB_NAME}' - is completed the '${TEST_QUEUE1_NAME}' task !"
  _cli_log_error.mock.assert_not_called
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__logs_expected_messages

test_backup_scheduler_job_run__@vary__promotes_job() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _backup_scheduler_job_promote.mock.assert_called_once_with \
    "${TEST_QUEUE1_NAME} mock_job ${TEST_JOB_NAME}"
}

@parametrize_with_successful_job \
  test_backup_scheduler_job_run__@vary__promotes_job

test_backup_scheduler_job_run__@vary__logs_expected_error_messages() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _cli_log_notice.mock.assert_called_once_with \
    "BACKUP SCHEDULER: Backup job '${TEST_JOB_NAME}' - is starting the '${TEST_QUEUE1_NAME}' task ..."
  _cli_log_error.mock.assert_calls_are \
    "BACKUP SCHEDULER: Backup job '${TEST_JOB_NAME}' - has failed the '${TEST_QUEUE1_NAME}' task !" \
    "BACKUP SCHEDULER: This job will be retried tomorrow."
}

@parametrize_with_unsuccessful_job \
  test_backup_scheduler_job_run__@vary__logs_expected_error_messages

test_backup_scheduler_job_run__@vary__retries_the_job() {
  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  mock_job.mock.assert_count_is "2"
  mock_job.mock.assert_call_n_is "1" "${TEST_QUEUE1_NAME}"
  mock_job.mock.assert_call_n_is "2" "${RPI_BACKUP_QUEUE_FAILED_TASK_EVENT}"
}

@parametrize_with_unsuccessful_job \
  test_backup_scheduler_job_run__@vary__retries_the_job

test_backup_scheduler_job_run__job_fails_______retry_fails_____calls_event_script() {
  basename.mock.set.stdout "mock_failed_job"
  mock_job.mock.set.side_effects "return 1" "return 1"

  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _event_script.mock.assert_called_once_with \
    "event-backup-scheduler-error.sh"
}

test_backup_scheduler_job_run__job_fails_______retry_fails_____returns_status_code_0() {
  basename.mock.set.stdout "mock_failed_job"
  mock_job.mock.set.side_effects "return 1" "return 1"

  _capture.rc _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  assert_rc "0"
}

test_backup_scheduler_job_run__job_fails_______retry_succeeds__does_not_call_event_script() {
  basename.mock.set.stdout "mock_failed_job"
  mock_job.mock.set.side_effects "return 1" "return 0"

  _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  _event_script.mock.assert_not_called
}

test_backup_scheduler_job_run__job_fails_______retry_succeeds__returns_status_code_0() {
  basename.mock.set.stdout "mock_failed_job"
  mock_job.mock.set.side_effects "return 1" "return 0"

  _capture.rc _backup_scheduler_job_run "${TEST_QUEUE1_NAME}" mock_job

  assert_rc "0"
}
