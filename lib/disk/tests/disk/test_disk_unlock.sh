#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _mock.create _is_disk_mounted
  _mock.create _security_path_mkdir
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
    "RPI_DISK_CRYPT_GROUP", \
    "___with_crypt_group,mocked_crypt_group," \
    "without_crypt_group,,"
}

test_disk_lock__already_mounted__does_not_mount() {
  _is_disk_mounted.mock.set.rc "0"

  _disk_unlock

  assert_equals "0" "$(mount.mock.get.count)"
}

test_disk_lock__not_mounted__@vary__logs_expected_messages() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  assert_equals "2" "$(_cli_log_warning.mock.get.count)"
  assert_equals "1" "$(_cli_log_notice.mock.get.count)"
  assert_equals \
    "Decrypting disk '${TEST_MOCK_DISK_NAME_1}' ..." \
    "$(_cli_log_warning.mock.get.call "1")"
  assert_equals \
    "Checking data on disk '${TEST_MOCK_DISK_NAME_1}' ..." \
    "$(_cli_log_warning.mock.get.call "2")"
  assert_equals \
    "Mounting disk '${TEST_MOCK_DISK_NAME_1}' ..." \
    "$(_cli_log_notice.mock.get.call "1")"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__logs_expected_messages

test_disk_lock__not_mounted__@vary__secures_disk_mount_point() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  assert_equals "1" "$(_security_path_mkdir.mock.get.count)"
  assert_equals \
    "${RPI_DISK_MOUNT_POINT} ${RPI_SVC_USERNAME}  700" \
    "$(_security_path_mkdir.mock.get.call "1")"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__secures_disk_mount_point

test_disk_lock__not_mounted__@vary__calls_fsck_on_disk() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  assert_equals "1" "$(fsck.mock.get.count)"
  assert_equals \
    "/dev/mapper/${TEST_MOCK_DISK_NAME_1}" \
    "$(fsck.mock.get.call "1")"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__calls_fsck_on_disk

test_disk_lock__not_mounted__@vary__mounts_disk() {
  _is_disk_mounted.mock.set.rc "1"

  _capture_logs _disk_unlock

  assert_equals "1" "$(mount.mock.get.count)"
  assert_equals \
    "/dev/mapper/${TEST_MOCK_DISK_NAME_1} ${TEST_MOCK_MOUNT_POINT_1} -o noatime,rw,errors=remount-ro" \
    "$(mount.mock.get.call "1")"
}

@parametrize_vary_crypt_group \
  test_disk_lock__not_mounted__@vary__mounts_disk

test_disk_lock__not_mounted_____with_crypt_group__calls_disk_unlock_with_crypt_group() {
  _is_disk_mounted.mock.set.rc "1"
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP="mocked_crypt_group"

  _capture_logs _disk_unlock

  assert_equals "1" "$(_disk_unlock_with_crypt_group.mock.get.count)"
  assert_equals "" "$(_disk_unlock_with_crypt_group.mock.get.call "1")"
  assert_equals "0" "$(_disk_unlock_without_crypt_group.mock.get.count)"
}

test_disk_lock__not_mounted__without_crypt_group__calls_disk_unlock_without_crypt_group() {
  _is_disk_mounted.mock.set.rc "1"
  # shellcheck disable=SC2034
  RPI_DISK_CRYPT_GROUP=""

  _capture_logs _disk_unlock

  assert_equals "1" "$(_disk_unlock_without_crypt_group.mock.get.count)"
  assert_equals "" "$(_disk_unlock_without_crypt_group.mock.get.call "1")"
  assert_equals "0" "$(_disk_unlock_with_crypt_group.mock.get.count)"
}
