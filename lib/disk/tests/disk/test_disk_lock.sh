#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  _mock.create _is_disk_mounted
  _mock.create umount
  _mock.create cryptsetup
  fake_disk_1
}

test_disk_lock__not_mounted__does_not_unmount() {
  _is_disk_mounted.mock.set.rc "1"

  _disk_lock

  assert_equals "0" "$(umount.mock.get.count)"
}

test_disk_lock__mounted__unmounts_disk() {
  _is_disk_mounted.mock.set.rc "0"

  _capture_logs _disk_lock

  assert_equals "1" "$(umount.mock.get.count)"
  assert_equals "/dev/mapper/${TEST_MOCK_DISK_NAME_1}" "$(umount.mock.get.call "1")"
}

test_disk_lock__mounted__seals_disk() {
  _is_disk_mounted.mock.set.rc "0"

  _capture_logs _disk_lock

  assert_equals "1" "$(cryptsetup.mock.get.count)"
  assert_equals "close /dev/mapper/${TEST_MOCK_DISK_NAME_1}" "$(cryptsetup.mock.get.call "1")"
}

test_disk_lock__mounted__logs_warning_messages() {
  _is_disk_mounted.mock.set.rc "0"

  _capture_logs _disk_lock

  assert_equals \
    "Unmounting disk '${TEST_MOCK_DISK_NAME_1}' ...
Sealing disk '${TEST_MOCK_DISK_NAME_1}' ..." \
    "$(_cli_log_warning.mock.get.calls)"
}
