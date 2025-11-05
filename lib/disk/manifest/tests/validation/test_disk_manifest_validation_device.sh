#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  _mock.create blkid

  fake_disk_1
}

test_disk_manifest_validation_device__uuid_valid____return_code_0() {
  blkid.mock.set.stdout "${TEST_MOCK_UUID_1}"

  _capture_logs _capture.rc _disk_manifest_validation_device

  assert_rc "0"
}

test_disk_manifest_validation_device__uuid_valid____logs_no_warning() {
  blkid.mock.set.stdout "${TEST_MOCK_UUID_1}"

  _capture_logs _disk_manifest_validation_device

  _cli_log_warning.mock.assert_not_called
}

test_disk_manifest_validation_device__uuid_invalid__return_code_0() {
  blkid.mock.set.stdout ""

  _capture_logs _capture.rc _disk_manifest_validation_device

  assert_rc "0"
}

test_disk_manifest_validation_device__uuid_invalid__logs_a_warning() {
  blkid.mock.set.stdout ""

  _capture_logs _disk_manifest_validation_device

  _cli_log_warning.mock.assert_called_once_with \
    "1(DISK: UUID '${TEST_MOCK_UUID_1}' could not be found.)"
}
