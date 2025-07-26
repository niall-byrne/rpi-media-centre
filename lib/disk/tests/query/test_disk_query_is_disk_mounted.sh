#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  fake_disk_1
  _mock.create mountpoint
}

test_is_disk_mounted__invalid_mountpoint__calls_mountpoint_as_expected() {
  mountpoint.mock.set.rc "1"

  _capture_logs _capture_rc _is_disk_mounted

  assert_equals "1" "$(mountpoint.mock.get.count)"
  assert_equals "${TEST_MOCK_MOUNT_POINT_1}" "$(mountpoint.mock.get.call "1")"
  assert_equals "127" "${TEST_RC}"
}

test_is_disk_mounted__invalid_mountpoint__logs_correct_message() {
  mountpoint.mock.set.rc "1"

  _capture_logs _is_disk_mounted

  assert_equals "1" "$(_cli_log_error.mock.get.count)"
  assert_equals \
    "The disk with UUID '${TEST_MOCK_UUID_1}' is not mounted !" \
    "$(_cli_log_error.mock.get.call "1")"
}

test_is_disk_mounted__valid_mountpoint__calls_mountpoint_as_expected() {
  mountpoint.mock.set.rc "0"

  _capture_logs _capture_rc _is_disk_mounted

  assert_equals "1" "$(mountpoint.mock.get.count)"
  assert_equals "${TEST_MOCK_MOUNT_POINT_1}" "$(mountpoint.mock.get.call "1")"
  assert_equals "0" "${TEST_RC}"
}

test_is_disk_mounted__valid_mountpoint__logs_nothing() {
  mountpoint.mock.set.rc "0"

  _capture_logs _is_disk_mounted

  assert_equals "0" "$(_cli_log_error.mock.get.count)"
}
