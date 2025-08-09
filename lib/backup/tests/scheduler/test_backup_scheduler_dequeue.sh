#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/backup/tests/__fixtures__/queue.sh"

setup_suite() {
  _fixture_mock_backup_queues
  # shellcheck disable=SC2034
  RPI_BACKUP_PATH_QUEUE_ROOT="${_TEST_PATH_QUEUE_ROOT}"
}

teardown_suite() {
  _cleanup_mock_backup_queues
}

setup() {
  _fixture_mock_logs
  _mock.create _backup_scheduler_job_run
}

teardown() {
  _cleanup_mock_backup_jobs
}

test_backup_scheduler_dequeue__3_mock_job_files__calls_backup_scheduler_job_run() {
  _fixture_mock_backup_jobs "${_TEST_QUEUE1_NAME}" "1" "2" "3"

  _backup_scheduler_dequeue "${_TEST_QUEUE1_NAME}"

  _backup_scheduler_job_run.mock.assert_count_is "3"
  _backup_scheduler_job_run.mock.assert_any_call_is "${_TEST_QUEUE1_NAME} ${_TEST_QUEUE1_PATH}/job1"
  _backup_scheduler_job_run.mock.assert_any_call_is "${_TEST_QUEUE1_NAME} ${_TEST_QUEUE1_PATH}/job2"
  _backup_scheduler_job_run.mock.assert_any_call_is "${_TEST_QUEUE1_NAME} ${_TEST_QUEUE1_PATH}/job3"
}

test_backup_scheduler_dequeue__3_mock_job_files__logs_message_after_each_job() {
  local EXPECTED_LOGS_MESSAGE="BACKUP SCHEDULER: =========================================="
  _fixture_mock_backup_jobs "${_TEST_QUEUE1_NAME}" "1" "2" "3"

  _backup_scheduler_dequeue "${_TEST_QUEUE1_NAME}"

  _cli_log_notice.mock.assert_count_is "3"
  _cli_log_notice.mock.assert_calls_are \
    "${EXPECTED_LOGS_MESSAGE}" \
    "${EXPECTED_LOGS_MESSAGE}" \
    "${EXPECTED_LOGS_MESSAGE}"
}
