#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  fake_disk_1
  _mock.create mountpoint
}

test_is_disk_mounted__invalid_mountpoint__calls_mountpoint_as_expected() {
  mountpoint.mock.set.rc "1"

  _capture_logs _capture.rc _is_disk_mounted

  mountpoint.mock.assert_called_once_with "1(${TEST_MOCK_MOUNT_POINT_1})"
  assert_rc "127"
}

test_is_disk_mounted__invalid_mountpoint__logs_correct_message() {
  mountpoint.mock.set.rc "1"

  _capture_logs _is_disk_mounted

  _cli_log_error.mock.assert_called_once_with "1(The disk with UUID '${TEST_MOCK_UUID_1}' is not mounted !)"
}

test_is_disk_mounted__valid_mountpoint__calls_mountpoint_as_expected() {
  mountpoint.mock.set.rc "0"

  _capture_logs _capture.rc _is_disk_mounted

  mountpoint.mock.assert_called_once_with "1(${TEST_MOCK_MOUNT_POINT_1})"
  assert_rc "0"
}

test_is_disk_mounted__valid_mountpoint__logs_nothing() {
  mountpoint.mock.set.rc "0"

  _capture_logs _is_disk_mounted

  _cli_log_error.mock.assert_not_called
}
