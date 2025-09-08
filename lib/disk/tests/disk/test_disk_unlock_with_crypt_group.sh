#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/disk/__fixtures__/disk_unlock_with_crypt_group.sh"

setup() {
  _mock.create stdlib.io.stdin.prompt
  stdlib.io.stdin.prompt.mock.set.keywords "_STDLIB_PASSWORD_BOOLEAN"

  _mock.create cryptsetup
  cryptsetup.mock.set.pipeable 1
}

test_disk_unlock_with_crypt_group__3_disks__3_crypt_groups__calls_stdlib_io_stdin_prompt_3_times() {
  _fixture__3_disks__3_crypt_groups

  _scenario__3_disks__3_crypt_groups__3_entered_passwords > /dev/null

  stdlib.io.stdin.prompt.mock.assert_calls_are \
    "1(RPI_DISK_CRYPT_PASSWORD) 2(Enter the password for disk group 'group1': ) _STDLIB_PASSWORD_BOOLEAN(1)" \
    "1(RPI_DISK_CRYPT_PASSWORD) 2(Enter the password for disk group 'group2': ) _STDLIB_PASSWORD_BOOLEAN(1)" \
    "1(RPI_DISK_CRYPT_PASSWORD) 2(Enter the password for disk group 'group3': ) _STDLIB_PASSWORD_BOOLEAN(1)"
}

test_disk_unlock_with_crypt_group__3_disks__3_crypt_groups__calls_luks_open_3_times() {
  _fixture__3_disks__3_crypt_groups

  _scenario__3_disks__3_crypt_groups__3_entered_passwords > /dev/null

  cryptsetup.mock.assert_calls_are \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_1}) 3(${TEST_MOCK_DISK_NAME_1}) 4(password1)" \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_2}) 3(${TEST_MOCK_DISK_NAME_2}) 4(password2)" \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_3}) 3(${TEST_MOCK_DISK_NAME_3}) 4(password3)"
}

test_disk_unlock_with_crypt_group__3_disks__2_crypt_groups__calls_stdlib_io_stdin_prompt_2_times() {
  _fixture__3_disks__2_crypt_groups

  _scenario__3_disks__2_crypt_groups__2_entered_passwords > /dev/null

  stdlib.io.stdin.prompt.mock.assert_calls_are \
    "1(RPI_DISK_CRYPT_PASSWORD) 2(Enter the password for disk group 'group1': ) _STDLIB_PASSWORD_BOOLEAN(1)" \
    "1(RPI_DISK_CRYPT_PASSWORD) 2(Enter the password for disk group 'group2': ) _STDLIB_PASSWORD_BOOLEAN(1)"
}

test_disk_unlock_with_crypt_group__3_disks__2_crypt_groups__calls_luks_open_3_times() {
  _fixture__3_disks__2_crypt_groups

  _scenario__3_disks__2_crypt_groups__2_entered_passwords > /dev/null

  cryptsetup.mock.assert_calls_are \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_1}) 3(${TEST_MOCK_DISK_NAME_1}) 4(password1)" \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_2}) 3(${TEST_MOCK_DISK_NAME_2}) 4(password2)" \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_3}) 3(${TEST_MOCK_DISK_NAME_3}) 4(password2)"
}

test_disk_unlock_with_crypt_group__3_disks__1_crypt_groups__calls_stdlib_io_stdin_prompt_1_times() {
  _fixture__3_disks__1_crypt_groups

  _scenario__3_disks__1_crypt_groups__1_entered_passwords > /dev/null

  stdlib.io.stdin.prompt.mock.assert_calls_are \
    "1(RPI_DISK_CRYPT_PASSWORD) 2(Enter the password for disk group 'group1': ) _STDLIB_PASSWORD_BOOLEAN(1)"
}

test_disk_unlock_with_crypt_group__3_disks__1_crypt_groups__calls_luks_open_3_times() {
  _fixture__3_disks__1_crypt_groups

  _scenario__3_disks__1_crypt_groups__1_entered_passwords > /dev/null

  cryptsetup.mock.assert_calls_are \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_1}) 3(${TEST_MOCK_DISK_NAME_1}) 4(password1)" \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_2}) 3(${TEST_MOCK_DISK_NAME_2}) 4(password1)" \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_3}) 3(${TEST_MOCK_DISK_NAME_3}) 4(password1)"
}
