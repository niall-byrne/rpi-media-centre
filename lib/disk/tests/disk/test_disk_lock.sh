#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  _mock.create _is_disk_mounted
  _mock.create umount
  _mock.create cryptsetup
  fake_disk_1
}

test_disk_lock__not_mounted__does_not_unmount() {
  _is_disk_mounted.mock.set.rc "1"

  _disk_lock

  umount.mock.assert_not_called
}

test_disk_lock__mounted__unmounts_disk() {
  _is_disk_mounted.mock.set.rc "0"

  _capture_logs _disk_lock

  umount.mock.assert_called_once_with "1(/dev/mapper/${TEST_MOCK_DISK_NAME_1})"
}

test_disk_lock__mounted__seals_disk() {
  _is_disk_mounted.mock.set.rc "0"

  _capture_logs _disk_lock

  cryptsetup.mock.assert_called_once_with "1(close) 2(/dev/mapper/${TEST_MOCK_DISK_NAME_1})"
}

test_disk_lock__mounted__logs_warning_messages() {
  _is_disk_mounted.mock.set.rc "0"

  _capture_logs _disk_lock

  _cli_log_warning.mock.assert_calls_are \
    "1(Unmounting disk '${TEST_MOCK_DISK_NAME_1}' ...)" \
    "1(Sealing disk '${TEST_MOCK_DISK_NAME_1}' ...)"
}
