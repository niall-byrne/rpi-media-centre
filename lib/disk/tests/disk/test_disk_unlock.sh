#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _mock.create _is_disk_mounted
  _mock.create stdlib.security.path.make.dir
  _mock.create _disk_unlock_with_crypt_group
  _mock.create _disk_unlock_without_crypt_group
  _mock.create fsck
  _mock.create mount
  fake_disk_1
}

@parametrize_vary_crypt_group() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_DISK_CRYPT_GROUP" \
    "___with_crypt_group;mocked_crypt_group;" \
    "without_crypt_group;;"
}

test_disk_lock__already_mounted__does_not_mount() {
  _is_disk_mounted.mock.set.rc "0"

  _disk_unlock

  mount.mock.assert_not_called
}

test_disk_lock__not_mounted__@vary__logs_expected_messages() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  _cli_log_warning.mock.assert_calls_are \
    "1(Decrypting disk '${TEST_MOCK_DISK_NAME_1}' ...)" \
    "1(Checking data on disk '${TEST_MOCK_DISK_NAME_1}' ...)"
  _cli_log_notice.mock.assert_calls_are \
    "1(Mounting disk '${TEST_MOCK_DISK_NAME_1}' ...)"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__logs_expected_messages

test_disk_lock__not_mounted__@vary__secures_disk_mount_point() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  stdlib.security.path.make.dir.mock.assert_called_once_with \
    "1(${RPI_DISK_MOUNT_POINT}) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__secures_disk_mount_point

test_disk_lock__not_mounted__@vary__calls_fsck_on_disk() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  fsck.mock.assert_calls_are \
    "1(/dev/mapper/${TEST_MOCK_DISK_NAME_1})"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__calls_fsck_on_disk

test_disk_lock__not_mounted__@vary__mounts_disk() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  mount.mock.assert_called_once_with \
    "1(/dev/mapper/${TEST_MOCK_DISK_NAME_1}) 2(${TEST_MOCK_MOUNT_POINT_1}) 3(-o) 4(noatime,rw,errors=remount-ro)"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__mounts_disk

test_disk_lock__not_mounted_____with_crypt_group__calls_disk_unlock_with_crypt_group() {
  _is_disk_mounted.mock.set.rc "1"
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP="mocked_crypt_group"

  _capture_logs _disk_unlock

  _disk_unlock_with_crypt_group.mock.assert_called_once_with ""
  _disk_unlock_without_crypt_group.mock.assert_not_called
}

test_disk_lock__not_mounted__without_crypt_group__calls_disk_unlock_without_crypt_group() {
  _is_disk_mounted.mock.set.rc "1"
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP=""

  _capture_logs _disk_unlock

  _disk_unlock_with_crypt_group.mock.assert_not_called
  _disk_unlock_without_crypt_group.mock.assert_called_once_with ""
}
