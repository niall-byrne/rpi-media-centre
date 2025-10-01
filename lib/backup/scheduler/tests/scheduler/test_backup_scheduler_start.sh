#!/bin/bash

setup() {
  _mock.create _backup_scheduler_query_is_available
  _mock.create _event_script
  _mock.create _cli_log_notice
  _mock.create _backup_scheduler_queue_dequeue_all_from
  _mock.create _cli_log_error
}

@parametrize_with_scheduler_times() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_START_TIME;TEST_END_TIME" \
    "10:00-3:00;10:00;3:00"
}

@parametrize_with_queues() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_QUEUES_DEFINITION" \
    "one_queue;queue1" \
    "two_queues;queue1|queue2"
}

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_not_available__@vary__logs_error_message() {
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_START_TIME}"
  local RPI_BACKUP_SCHEDULER_END_TIME="${TEST_END_TIME}"

  _backup_scheduler_query_is_available.mock.set.rc 1

  _backup_scheduler_start

  _cli_log_error.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: The scheduler is available between ${TEST_START_TIME} and ${TEST_END_TIME} daily.)"
}

@parametrize_with_scheduler_times \
  test_backup_scheduler_start__scheduler_not_available__@vary__logs_error_message

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_not_available__@vary__does_not_call_event_script() {
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_START_TIME}"
  local RPI_BACKUP_SCHEDULER_END_TIME="${TEST_END_TIME}"

  _backup_scheduler_query_is_available.mock.set.rc 1

  _backup_scheduler_start

  _event_script.mock.assert_not_called
}

@parametrize_with_scheduler_times \
  test_backup_scheduler_start__scheduler_not_available__@vary__does_not_call_event_script

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_not_available__@vary__does_not_log_notice_messages() {
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_START_TIME}"
  local RPI_BACKUP_SCHEDULER_END_TIME="${TEST_END_TIME}"

  _backup_scheduler_query_is_available.mock.set.rc 1

  _backup_scheduler_start

  _cli_log_notice.mock.assert_not_called
}

@parametrize_with_scheduler_times \
  test_backup_scheduler_start__scheduler_not_available__@vary__does_not_log_notice_messages

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_not_available__@vary__does_not_dequeue_any_jobs() {
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_START_TIME}"
  local RPI_BACKUP_SCHEDULER_END_TIME="${TEST_END_TIME}"

  _backup_scheduler_query_is_available.mock.set.rc 1

  _backup_scheduler_start

  _backup_scheduler_queue_dequeue_all_from.mock.assert_not_called
}

@parametrize_with_scheduler_times \
  test_backup_scheduler_start__scheduler_not_available__@vary__does_not_dequeue_any_jobs

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______no_queues___calls_each_event_script() {
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0

  _backup_scheduler_start

  _event_script.mock.assert_calls_are \
    "1(event-backup-scheduler-before.sh)" \
    "1(event-backup-scheduler-after.sh)"

}

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______@vary__calls_each_event_script() {
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0
  stdlib.array.make.from_string RPI_BACKUP_QUEUE_NAMES "|" "${TEST_QUEUES_DEFINITION}"

  _backup_scheduler_start

  _event_script.mock.assert_calls_are \
    "1(event-backup-scheduler-before.sh)" \
    "1(event-backup-scheduler-after.sh)"

}

@parametrize_with_queues \
  test_backup_scheduler_start__scheduler_available______@vary__calls_each_event_script

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______no_queues___logs_notice_messages() {
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0

  _backup_scheduler_start

  _cli_log_notice.mock.assert_calls_are \
    "1(BACKUP SCHEDULER: Executing all processable backup jobs ...)" \
    "1(BACKUP SCHEDULER: Execution has stopped cleanly.)"

}

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______@vary__logs_notice_messages() {
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0
  stdlib.array.make.from_string RPI_BACKUP_QUEUE_NAMES "|" "${TEST_QUEUES_DEFINITION}"

  _backup_scheduler_start

  _cli_log_notice.mock.assert_calls_are \
    "1(BACKUP SCHEDULER: Executing all processable backup jobs ...)" \
    "1(BACKUP SCHEDULER: Execution has stopped cleanly.)"

}

@parametrize_with_queues \
  test_backup_scheduler_start__scheduler_available______@vary__logs_notice_messages

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______no_queues___does_not_dequeue_any_jobs() {
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0

  _backup_scheduler_start

  _backup_scheduler_queue_dequeue_all_from.mock.assert_not_called
}

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______@vary__dequeues_jobs_from_each_queue() {
  local expected_calls=()
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0
  stdlib.array.make.from_string RPI_BACKUP_QUEUE_NAMES "|" "${TEST_QUEUES_DEFINITION}"
  expected_calls=("${RPI_BACKUP_QUEUE_NAMES[@]}")
  stdlib.array.mutate.reverse expected_calls
  stdlib.array.mutate.format "1(%s)" expected_calls

  _backup_scheduler_start

  _backup_scheduler_queue_dequeue_all_from.mock.assert_calls_are "${expected_calls[@]}"
}

@parametrize_with_queues \
  test_backup_scheduler_start__scheduler_available______@vary__dequeues_jobs_from_each_queue

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______no_queues___calls_events_and_logs_in_sequence() {
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0
  _mock.sequence.record.start

  _backup_scheduler_start

  _mock.sequence.assert_is \
    "_backup_scheduler_query_is_available" \
    "_event_script" \
    "_cli_log_notice" \
    "_cli_log_notice" \
    "_event_script"
}

# shellcheck disable=SC2034
test_backup_scheduler_start__scheduler_available______@vary__calls_events_and_logs_in_sequence() {
  local expected_calls=(
    "_backup_scheduler_query_is_available"
    "_event_script"
    "_cli_log_notice"
    "_cli_log_notice"
    "_event_script"
  )
  local RPI_BACKUP_QUEUE_NAMES=()

  _backup_scheduler_query_is_available.mock.set.rc 0
  stdlib.array.make.from_string RPI_BACKUP_QUEUE_NAMES "|" "${TEST_QUEUES_DEFINITION}"
  for queue_name in "${RPI_BACKUP_QUEUE_NAMES[@]}"; do
    stdlib.array.mutate.insert "_backup_scheduler_queue_dequeue_all_from" 3 expected_calls
  done
  _mock.sequence.record.start

  _backup_scheduler_start

  _mock.sequence.assert_is "${expected_calls[@]}"
}

@parametrize_with_queues \
  test_backup_scheduler_start__scheduler_available______@vary__calls_events_and_logs_in_sequence
