#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  _mock.create cryptsetup
  fake_disk_1
}

test_disk_unlock_without_crypt_group__calls_luks_open() {
  _disk_unlock_without_crypt_group

  assert_equals \
    "luksOpen /dev/disk/by-uuid/${TEST_MOCK_UUID_1} ${TEST_MOCK_DISK_NAME_1}" \
    "$(cryptsetup.mock.get.calls)"
}
