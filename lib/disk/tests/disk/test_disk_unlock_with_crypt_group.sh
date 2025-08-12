#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/disk/__fixtures__/disk_unlock_with_crypt_group.sh"

setup() {
  _mock.create _io_prompt
  _mock.create cryptsetup
  cryptsetup.mock.set.pipeable 1
}

test_disk_unlock_with_crypt_group__3_disks__3_crypt_groups__calls_io_prompt_3_times() {
  _fixture__3_disks__3_crypt_groups

  _scenario__3_disks__3_crypt_groups__3_entered_passwords

  assert_equals "3" "$(_io_prompt.mock.get.count)"
  assert_equals \
    "Enter the password for disk group 'group1':  RPI_DISK_CRYPT_PASSWORD password
Enter the password for disk group 'group2':  RPI_DISK_CRYPT_PASSWORD password
Enter the password for disk group 'group3':  RPI_DISK_CRYPT_PASSWORD password" \
    "$(_io_prompt.mock.get.calls)"
}

test_disk_unlock_with_crypt_group__3_disks__3_crypt_groups__calls_luks_open_3_times() {
  _fixture__3_disks__3_crypt_groups

  _scenario__3_disks__3_crypt_groups__3_entered_passwords

  assert_equals "3" "$(cryptsetup.mock.get.count)"
  assert_equals \
    "luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_1} ${TEST_MOCK_DISK_NAME_1} password1
luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_2} ${TEST_MOCK_DISK_NAME_2} password2
luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_3} ${TEST_MOCK_DISK_NAME_3} password3" \
    "$(cryptsetup.mock.get.calls)"
}

test_disk_unlock_with_crypt_group__3_disks__2_crypt_groups__calls_io_prompt_2_times() {
  _fixture__3_disks__2_crypt_groups

  _scenario__3_disks__2_crypt_groups__2_entered_passwords

  assert_equals "2" "$(_io_prompt.mock.get.count)"
  assert_equals \
    "Enter the password for disk group 'group1':  RPI_DISK_CRYPT_PASSWORD password
Enter the password for disk group 'group2':  RPI_DISK_CRYPT_PASSWORD password" \
    "$(_io_prompt.mock.get.calls)"
}

test_disk_unlock_with_crypt_group__3_disks__2_crypt_groups__calls_luks_open_3_times() {
  _fixture__3_disks__2_crypt_groups

  _scenario__3_disks__2_crypt_groups__2_entered_passwords

  assert_equals "3" "$(cryptsetup.mock.get.count)"
  assert_equals \
    "luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_1} ${TEST_MOCK_DISK_NAME_1} password1
luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_2} ${TEST_MOCK_DISK_NAME_2} password2
luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_3} ${TEST_MOCK_DISK_NAME_3} password2" \
    "$(cryptsetup.mock.get.calls)"
}

test_disk_unlock_with_crypt_group__3_disks__1_crypt_groups__calls_io_prompt_1_times() {
  _fixture__3_disks__1_crypt_groups

  _scenario__3_disks__1_crypt_groups__1_entered_passwords

  assert_equals "1" "$(_io_prompt.mock.get.count)"
  assert_equals \
    "Enter the password for disk group 'group1':  RPI_DISK_CRYPT_PASSWORD password" \
    "$(_io_prompt.mock.get.calls)"
}

test_disk_unlock_with_crypt_group__3_disks__1_crypt_groups__calls_luks_open_3_times() {
  _fixture__3_disks__1_crypt_groups

  _scenario__3_disks__1_crypt_groups__1_entered_passwords

  assert_equals "3" "$(cryptsetup.mock.get.count)"
  assert_equals \
    "luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_1} ${TEST_MOCK_DISK_NAME_1} password1
luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_2} ${TEST_MOCK_DISK_NAME_2} password1
luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_3} ${TEST_MOCK_DISK_NAME_3} password1" \
    "$(cryptsetup.mock.get.calls)"
}
