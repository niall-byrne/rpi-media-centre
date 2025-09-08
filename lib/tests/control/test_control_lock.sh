#!/bin/bash

TEST_LOCK_FILE="_test_lock"
TEST_LOCK_PATH="/var/lock/_test_lock"

setup() {
  [[ ! -e "${TEST_LOCK_PATH}" ]] || rm "${TEST_LOCK_PATH}"
  _mock.create _cli_log_error
  _mock.create sleep
}

teardown() {
  [[ ! -e "${TEST_LOCK_PATH}" ]] || rm "${TEST_LOCK_PATH}"
}

_fixture_delayed_lock_removal() {
  sleep.mock.set.subcommand "(( \"\${RPI_CONTROL_WAIT_TIME}\" == 3 )) && rm \"\${TEST_LOCK_PATH}\""
}

@parametrize_with_wait_times() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_WAIT_TIME" \
    "three_seconds;3" \
    "ten_seconds__;10"
}

test_control_lock__lock_file_does_not_exist__creates_lock_file() {
  _control_lock "${TEST_LOCK_FILE}" "10"

  assert_not_null "${BASHPID}"
  assert_equals \
    "${BASHPID}" \
    "$(cat "${TEST_LOCK_PATH}")"
}

test_control_lock__lock_file_does_not_exist__does_not_wait() {
  _control_lock "${TEST_LOCK_FILE}" "10"

  sleep.mock.assert_not_called
}

test_control_lock__lock_file_does_not_exist__returns_status_code_0() {
  _capture.rc _control_lock "${TEST_LOCK_FILE}" "10"

  assert_rc "0"
}

test_control_lock__lock_file_exists__________and_is_not_removed__does_not_overwrite_lock_file() {
  touch "${TEST_LOCK_PATH}"

  _control_lock "${TEST_LOCK_FILE}" "10"

  assert_not_null "${BASHPID}"
  assert_not_equals \
    "${BASHPID}" \
    "$(cat "${TEST_LOCK_PATH}")"
}

test_control_lock__lock_file_exists__________and_is_not_removed__waits_@vary_for_release() {
  local expected_sleep_calls=()

  touch "${TEST_LOCK_PATH}"

  stdlib.array.make.from_string_n expected_sleep_calls "${TEST_WAIT_TIME}" "1(1)"

  _control_lock "${TEST_LOCK_FILE}" "${TEST_WAIT_TIME}"

  sleep.mock.assert_calls_are \
    "${expected_sleep_calls[@]}"
}

@parametrize_with_wait_times \
  test_control_lock__lock_file_exists__________and_is_not_removed__waits_@vary_for_release

test_control_lock__lock_file_exists__________and_is_not_removed__logs_expected_error() {
  touch "${TEST_LOCK_PATH}"

  _control_lock "${TEST_LOCK_FILE}" "10"

  _cli_log_error.mock.assert_calls_are \
    "1(CONTROL: another process has reported it is executing this command.)" \
    "1(If you believe it to be safe you may execute: sudo rm '/var/lock/${TEST_LOCK_FILE}')"
}

test_control_lock__lock_file_exists__________and_is_not_removed__returns_status_code_127() {
  touch "${TEST_LOCK_PATH}"

  _capture.rc _control_lock "${TEST_LOCK_FILE}" "10"

  assert_rc "127"
}

test_control_lock__lock_file_exists__________and_is_removed______overwrites_lock_file() {
  touch "${TEST_LOCK_PATH}"
  _fixture_delayed_lock_removal

  _control_lock "${TEST_LOCK_FILE}" "10"

  assert_not_null "${BASHPID}"
  assert_equals \
    "${BASHPID}" \
    "$(cat "${TEST_LOCK_PATH}")"
}

test_control_lock__lock_file_exists__________and_is_removed______waits_for_four_seconds() {
  local expected_sleep_calls=()

  touch "${TEST_LOCK_PATH}"
  _fixture_delayed_lock_removal
  stdlib.array.make.from_string_n expected_sleep_calls "4" "1(1)"

  _control_lock "${TEST_LOCK_FILE}" "10"

  sleep.mock.assert_calls_are \
    "${expected_sleep_calls[@]}"
}

test_control_lock__lock_file_exists__________and_is_removed______logs_no_error() {
  touch "${TEST_LOCK_PATH}"
  _fixture_delayed_lock_removal

  _control_lock "${TEST_LOCK_FILE}" "10"

  _cli_log_error.mock.assert_not_called
}

test_control_lock__lock_file_exists__________and_is_removed______returns_status_code_0() {
  touch "${TEST_LOCK_PATH}"
  _fixture_delayed_lock_removal

  _capture.rc _control_lock "${TEST_LOCK_FILE}" "10"

  assert_rc "0"
}
