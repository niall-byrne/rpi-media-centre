#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

test_is_disk_mounted___file_exists__calls_test_as_expected() {
  _mock.create stdlib.io.path.query.is_file
  stdlib.io.path.query.is_file.mock.set.rc 0

  _capture.rc _is_disk_encrypted

  stdlib.io.path.query.is_file.mock.assert_called_once_with \
    "1(${RPI_MANIFEST_CRYPT})"
  assert_rc "0"
}

test_is_disk_mounted___file_does_not_exist__calls_test_as_expected() {
  _mock.create stdlib.io.path.query.is_file
  stdlib.io.path.query.is_file.mock.set.rc 1

  _capture.rc _is_disk_encrypted

  stdlib.io.path.query.is_file.mock.assert_called_once_with \
    "1(${RPI_MANIFEST_CRYPT})"
  assert_rc "1"
}

test_is_disk_mounted__invalid_mountpoint__calls_mountpoint_as_expected() {
  fake_disk_1
  _mock.create mountpoint
  mountpoint.mock.set.rc "1"

  _capture_logs _capture.rc _is_disk_mounted

  mountpoint.mock.assert_called_once_with "1(${TEST_MOCK_MOUNT_POINT_1})"
  assert_rc "127"
}

test_is_disk_mounted__invalid_mountpoint__logs_correct_message() {
  fake_disk_1
  _mock.create mountpoint
  mountpoint.mock.set.rc "1"

  _capture_logs _is_disk_mounted

  _cli_log_error.mock.assert_called_once_with \
    "1(The disk with UUID '${TEST_MOCK_UUID_1}' is not mounted !)"
}

test_is_disk_mounted__valid_mountpoint__calls_mountpoint_as_expected() {
  fake_disk_1
  _mock.create mountpoint
  mountpoint.mock.set.rc "0"

  _capture_logs _capture.rc _is_disk_mounted

  mountpoint.mock.assert_called_once_with "1(${TEST_MOCK_MOUNT_POINT_1})"
  assert_rc "0"
}

test_is_disk_mounted__valid_mountpoint__logs_nothing() {
  fake_disk_1
  _mock.create mountpoint
  mountpoint.mock.set.rc "0"

  _capture_logs _is_disk_mounted

  _cli_log_error.mock.assert_not_called
}
