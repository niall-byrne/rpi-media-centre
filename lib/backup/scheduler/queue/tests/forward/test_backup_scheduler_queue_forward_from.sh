#!/bin/bash

setup() {
  MOCK_QUEUES=("queue1" "queue2" "queue3" "queue4")
}

@parametrize_with_queue_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_QUEUE_INDEX;TEST_EXPECTED_OUTPUT" \
    "1;0;queue2" \
    "2;1;queue3" \
    "3;2;queue4" \
    "4;3;;"
}

# shellcheck disable=SC2034
test_backup_scheduler_queue_forward_from__current_index_@vary__emits_expected_value() {
  local RPI_BACKUP_QUEUE_NAMES=("${MOCK_QUEUES[@]}")

  _capture.output _backup_scheduler_queue_forward_from "${MOCK_QUEUES[TEST_QUEUE_INDEX]}"

  assert_equals "${TEST_EXPECTED_OUTPUT}" "${TEST_OUTPUT}"
}

@parametrize_with_queue_names \
  test_backup_scheduler_queue_forward_from__current_index_@vary__emits_expected_value
