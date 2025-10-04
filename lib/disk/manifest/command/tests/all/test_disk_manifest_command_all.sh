#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  _mock.create _is_disk_encrypted
  _mock.create _disk_manifest_load
  _mock.create _dependencies_group_disks_crypt
  _mock.create mocked_disk_all_command
}

test_disk_manifest_command_all__not_encrypted__return_code_0() {
  _is_disk_encrypted.mock.set.rc "1"

  _capture.rc _disk_manifest_command_all mocked_disk_all_command

  assert_rc "0"
}

test_disk_manifest_command_all__not_encrypted__does_not_call_command() {
  _is_disk_encrypted.mock.set.rc "1"

  _disk_manifest_command_all mocked_disk_all_command

  mocked_disk_all_command.mock.assert_not_called
}

test_disk_manifest_command_all______encrypted__loads_manifest() {
  _is_disk_encrypted.mock.set.rc "0"

  _disk_manifest_command_all mocked_disk_all_command

  _disk_manifest_load.mock.assert_called_once_with ""
}

test_disk_manifest_command_all______encrypted__correct_dependency_group() {
  _is_disk_encrypted.mock.set.rc "0"

  _disk_manifest_command_all mocked_disk_all_command

  _dependencies_group_disks_crypt.mock.assert_called_once_with ""
}

test_disk_manifest_command_all______encrypted__@vary__return_code_0() {
  _is_disk_encrypted.mock.set.rc "0"
  _disk_manifest_load.mock.set.subcommand fake_manifest_n_entries "${MANIFEST_ENTRIES}"

  _capture.rc _disk_manifest_command_all mocked_disk_all_command

  assert_rc "0"
}

@parametrize \
  test_disk_manifest_command_all______encrypted__@vary__return_code_0 \
  "MANIFEST_ENTRIES" \
  "2_manifest_entries;2" \
  "3_manifest_entries;3"

test_disk_manifest_command_all______encrypted__2_manifest_entries__calls_command_2_times() {
  _is_disk_encrypted.mock.set.rc "0"
  _disk_manifest_load.mock.set.subcommand fake_manifest_n_entries "2"

  _disk_manifest_command_all mocked_disk_all_command

  mocked_disk_all_command.mock.assert_count_is "2"
  mocked_disk_all_command.mock.assert_call_n_is "1" ""
  mocked_disk_all_command.mock.assert_call_n_is "2" ""
}

test_disk_manifest_command_all______encrypted__2_manifest_entries__sets_environment_2_times() {
  _is_disk_encrypted.mock.set.rc "0"
  _disk_manifest_load.mock.set.subcommand fake_manifest_n_entries "2"

  _capture.stdout _disk_manifest_command_all _disk_manifest_line_log

  assert_equals \
    "RPI_DISK_UUID='UUID0'
RPI_DISK_NAME='mocked_disk0'
RPI_DISK_CRYPT_GROUP='crypt_group0'
RPI_DISK_MOUNT_POINT='/mnt/mocked/path0'
RPI_DISK_UUID='UUID1'
RPI_DISK_NAME='mocked_disk1'
RPI_DISK_CRYPT_GROUP='crypt_group1'
RPI_DISK_MOUNT_POINT='/mnt/mocked/path1'" \
    "${TEST_OUTPUT}"
}

test_disk_manifest_command_all______encrypted__3_manifest_entries__calls_command_3_times() {
  _is_disk_encrypted.mock.set.rc "0"
  _disk_manifest_load.mock.set.subcommand fake_manifest_n_entries "3"

  _disk_manifest_command_all mocked_disk_all_command

  mocked_disk_all_command.mock.assert_count_is "3"
  mocked_disk_all_command.mock.assert_call_n_is "1" ""
  mocked_disk_all_command.mock.assert_call_n_is "2" ""
  mocked_disk_all_command.mock.assert_call_n_is "3" ""
}

test_disk_manifest_command_all______encrypted__3_manifest_entries__sets_environment_3_times() {
  _is_disk_encrypted.mock.set.rc "0"
  _disk_manifest_load.mock.set.subcommand fake_manifest_n_entries "3"

  _capture.stdout _disk_manifest_command_all _disk_manifest_line_log

  assert_equals \
    "RPI_DISK_UUID='UUID0'
RPI_DISK_NAME='mocked_disk0'
RPI_DISK_CRYPT_GROUP='crypt_group0'
RPI_DISK_MOUNT_POINT='/mnt/mocked/path0'
RPI_DISK_UUID='UUID1'
RPI_DISK_NAME='mocked_disk1'
RPI_DISK_CRYPT_GROUP='crypt_group1'
RPI_DISK_MOUNT_POINT='/mnt/mocked/path1'
RPI_DISK_UUID='UUID2'
RPI_DISK_NAME='mocked_disk2'
RPI_DISK_CRYPT_GROUP='crypt_group2'
RPI_DISK_MOUNT_POINT='/mnt/mocked/path2'" \
    "${TEST_OUTPUT}"
}
