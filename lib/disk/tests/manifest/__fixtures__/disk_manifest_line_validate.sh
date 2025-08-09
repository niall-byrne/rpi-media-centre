#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

_fixture_disk_manifest_mount_point_conditions_valid() {
  stdlib.io.filesystem.assert.is_folder.mock.set.rc "0"
  stdlib.security.path.query.is_secure.mock.set.rc "0"
}

_fixture_disk_manifest_uuid_conditions_valid() {
  fake_disk_1
  blkid.mock.set.stdout "${TEST_MOCK_UUID_1}"
}

@parametrize_with_missing_values() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "RPI_DISK_UUID,RPI_DISK_NAME,RPI_DISK_MOUNT_POINT" \
    "no_uuid___,,MOCK_DISK_NAME,MOCK_DISK_MOUNT_POINT" \
    "no_name___,MOCK_DISK_UUID,,MOCK_DISK_MOUNT_POINT" \
    "no_mp_____,MOCK_DISK_UUID,MOCK_DISK_NAME,," \
    "no_all____,,,,"
}
