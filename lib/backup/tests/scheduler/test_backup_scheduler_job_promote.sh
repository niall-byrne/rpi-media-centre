#!/bin/bash

setup() {
  _fixture_mock_logs
  _mock.create _backup_job_get_next_queue
  _mock.create mv
  _mock.create _backup_scheduler_job_run
  _mock.create rm

  RPI_BACKUP_PATH_QUEUE_ROOT="/queue/root"
  _TEST_QUEUE1_NAME="QUEUE1"
  _TEST_QUEUE1_PATH="${RPI_BACKUP_PATH_QUEUE_ROOT}/QUEUE1"
}

_fixture_setup_backup_job_get_next_queue() {
  _backup_job_get_next_queue.mock.set.stdout "${TEST_NEXT_QUEUE_NAME}"
}

@parametrize_with_finished_job() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_setup_backup_job_get_next_queue" \
    "TEST_NEXT_QUEUE_NAME," \
    "job_is_finished__,,"
}

@parametrize_with_unfinished_job() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_setup_backup_job_get_next_queue" \
    "TEST_NEXT_QUEUE_NAME," \
    "job_is_unfinished,QUEUE2"
}

test_backup_scheduler_job_promote__@vary__@vary__calls_backup_job_get_next_queue() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "backup-job-1"

  _backup_job_get_next_queue.mock.assert_called_once_with "${_TEST_QUEUE1_NAME}"
}

@parametrize_apply \
  test_backup_scheduler_job_promote__@vary__@vary__calls_backup_job_get_next_queue \
  @parametrize_with_finished_job \
  @parametrize_with_unfinished_job

test_backup_scheduler_job_promote__@vary__logs_warning_message() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  _cli_log_warning.mock.assert_called_once_with \
    "BACKUP SCHEDULER: Promoted! New task '${TEST_NEXT_QUEUE_NAME}' for backup job 'job1' ..."
}

@parametrize_with_unfinished_job \
  test_backup_scheduler_job_promote__@vary__logs_warning_message

test_backup_scheduler_job_promote__@vary__moves_job_to_new_queue() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  mv.mock.assert_called_once_with \
    "${_TEST_QUEUE1_PATH}/job1 ${RPI_BACKUP_PATH_QUEUE_ROOT}/${TEST_NEXT_QUEUE_NAME}/job1"
}

@parametrize_with_unfinished_job \
  test_backup_scheduler_job_promote__@vary__moves_job_to_new_queue

test_backup_scheduler_job_promote__@vary__runs_promoted_job() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  _backup_scheduler_job_run.mock.assert_called_once_with \
    "${TEST_NEXT_QUEUE_NAME} ${RPI_BACKUP_PATH_QUEUE_ROOT}/${TEST_NEXT_QUEUE_NAME}/job1"
}

@parametrize_with_unfinished_job \
  test_backup_scheduler_job_promote__@vary__runs_promoted_job

test_backup_scheduler_job_promote__@vary__does_not_remove_the_job() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  rm.mock.assert_not_called
}

@parametrize_with_unfinished_job \
  test_backup_scheduler_job_promote__@vary__does_not_remove_the_job

test_backup_scheduler_job_promote__@vary__does_not_log_messages() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  _cli_log_warning.mock.assert_not_called
}

@parametrize_with_finished_job \
  test_backup_scheduler_job_promote__@vary__does_not_log_messages

test_backup_scheduler_job_promote__@vary__does_not_move_the_job() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  mv.mock.assert_not_called
}

@parametrize_with_finished_job \
  test_backup_scheduler_job_promote__@vary__does_not_move_the_job

test_backup_scheduler_job_promote__@vary__does_not_run_promoted_job() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  _backup_scheduler_job_run.mock.assert_not_called
}

@parametrize_with_finished_job \
  test_backup_scheduler_job_promote__@vary__does_not_run_promoted_job

test_backup_scheduler_job_promote__@vary__removes_the_job_file() {
  _backup_scheduler_job_promote "${_TEST_QUEUE1_NAME}" "${_TEST_QUEUE1_PATH}/job1" "job1"

  rm.mock.assert_called_once_with "${_TEST_QUEUE1_PATH}/job1"
}

@parametrize_with_finished_job \
  test_backup_scheduler_job_promote__@vary__removes_the_job_file
