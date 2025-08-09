#!/bin/bash

setup() {
  _mock.create date
}

@parametrize_with_epochs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_CURRENT_EPOCH,EXPECTED_RC" \
    "too_early___,1753005000,1" \
    "too_late____,1753025000,1" \
    "in_between__,1753015000,0"
}

test_backup_scheduler_is_available__@vary__returns_correct_status_code() {
  date.mock.set.side_effects \
    "echo 1753005600" \
    "echo 1753020000" \
    "echo '${TEST_CURRENT_EPOCH}'"

  _capture.rc _backup_scheduler_is_available

  assert_rc "${EXPECTED_RC}"
}

@parametrize_with_epochs \
  test_backup_scheduler_is_available__@vary__returns_correct_status_code

test_backup_scheduler_is_available__@vary__calls_date_function_as_expected() {
  date.mock.set.stdout "1"
  RPI_BACKUP_SCHEDULER_START_TIME="23:00"
  RPI_BACKUP_SCHEDULER_END_TIME="04:00"

  _backup_scheduler_is_available

  date.mock.assert_count_is "3"
  date.mock.assert_calls_are \
    "-ud ${RPI_BACKUP_SCHEDULER_START_TIME} today +%s" \
    "-ud ${RPI_BACKUP_SCHEDULER_END_TIME} today +%s" \
    "-u +%s"
}

@parametrize_with_epochs \
  test_backup_scheduler_is_available__@vary__calls_date_function_as_expected
