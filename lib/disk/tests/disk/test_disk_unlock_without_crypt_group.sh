#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  _mock.create cryptsetup
  fake_disk_1
}

test_disk_unlock_without_crypt_group__calls_luks_open() {
  _disk_unlock_without_crypt_group

  cryptsetup.mock.assert_called_once_with \
    "1(luksOpen) 2(/dev/disk/by-uuid/${TEST_MOCK_UUID_1}) 3(${TEST_MOCK_DISK_NAME_1})"
}
