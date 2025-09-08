#!/bin/bash

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _fixture_mock_logs
  _mock.create date
}

_fixture_setup_date() {
  date.mock.set.side_effects \
    "echo ${START_EPOCH}" \
    "echo ${END_EPOCH}"
}

@parametrize_with_invalid_epoch_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_setup_date" \
    "START_EPOCH;END_EPOCH;EXPECTED_RC" \
    "end_before_start;1753025000;1753025000;127" \
    "end_equals_start;1753025000;1753025000;127"
}

@parametrize_with_valid___epoch_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "@fixture _fixture_setup_date" \
    "START_EPOCH;END_EPOCH;EXPECTED_RC" \
    "start_before_end;1753005000;1753025000;0"
}

test_backup_scheduler_validate_schedule__@vary__@vary__calls_date_correctly() {
  _backup_scheduler_validate_schedule

  date.mock.assert_count_is "2"
  date.mock.assert_calls_are \
    "1(-ud) 2(\${RPI_BACKUP_SCHEDULER_START_TIME} today) 3(+%s)" \
    "1(-ud) 2(\${RPI_BACKUP_SCHEDULER_END_TIME} today) 3(+%s)"
}

@parametrize.apply \
  test_backup_scheduler_validate_schedule__@vary__@vary__calls_date_correctly \
  @parametrize_with_invalid_epoch_combos \
  @parametrize_with_valid___epoch_combos

test_backup_scheduler_validate_schedule__@vary______logs_error_messages() {
  _capture.rc _backup_scheduler_validate_schedule

  assert_rc "${EXPECTED_RC}"
}

@parametrize_with_invalid_epoch_combos \
  test_backup_scheduler_validate_schedule__@vary______logs_error_messages

test_backup_scheduler_validate_schedule__@vary__@vary__returns_expected_status_code() {
  _capture.rc _backup_scheduler_validate_schedule

  assert_rc "${EXPECTED_RC}"
}

@parametrize.apply \
  test_backup_scheduler_validate_schedule__@vary__@vary__returns_expected_status_code \
  @parametrize_with_invalid_epoch_combos \
  @parametrize_with_valid___epoch_combos
