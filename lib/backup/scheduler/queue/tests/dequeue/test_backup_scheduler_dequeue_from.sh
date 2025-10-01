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
  _mock.create _backup_scheduler_execute
}

teardown() {
  _cleanup_mock_backup_jobs
}

test_backup_scheduler_queue_dequeue_all_from__queue_with_0_mock_job_files__does_not_execute_jobs() {
  _fixture_mock_backup_jobs "${_TEST_QUEUE1_NAME}"

  _backup_scheduler_queue_dequeue_all_from "${_TEST_QUEUE1_NAME}"

  _backup_scheduler_execute.mock.assert_not_called
}

test_backup_scheduler_queue_dequeue_all_from__queue_with_0_mock_job_files__does_not_log_messages() {
  _fixture_mock_backup_jobs "${_TEST_QUEUE1_NAME}"

  _backup_scheduler_queue_dequeue_all_from "${_TEST_QUEUE1_NAME}"

  _cli_log_notice.mock.assert_not_called
}

test_backup_scheduler_queue_dequeue_all_from__queue_with_3_mock_job_files__executes_all_jobs() {
  _fixture_mock_backup_jobs "${_TEST_QUEUE1_NAME}" "1" "2" "3"

  _backup_scheduler_queue_dequeue_all_from "${_TEST_QUEUE1_NAME}"

  _backup_scheduler_execute.mock.assert_calls_are \
    "1(${_TEST_QUEUE1_NAME}) 2(${_TEST_QUEUE1_PATH}/job1)" \
    "1(${_TEST_QUEUE1_NAME}) 2(${_TEST_QUEUE1_PATH}/job2)" \
    "1(${_TEST_QUEUE1_NAME}) 2(${_TEST_QUEUE1_PATH}/job3)"
}

test_backup_scheduler_queue_dequeue_all_from__queue_with_3_mock_job_files__logs_message_after_each_job() {
  local expected_calls

  stdlib.array.make.from_string_n \
    expected_calls \
    3 \
    "1(BACKUP SCHEDULER: ==========================================)"

  _fixture_mock_backup_jobs "${_TEST_QUEUE1_NAME}" "1" "2" "3"

  _backup_scheduler_queue_dequeue_all_from "${_TEST_QUEUE1_NAME}"

  _cli_log_notice.mock.assert_calls_are \
    "${expected_calls[@]}"
}
