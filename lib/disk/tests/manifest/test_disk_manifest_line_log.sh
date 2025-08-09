#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/crypt_data.sh"

setup() {
  fake_disk_1
  RPI_DISK_CRYPT_GROUP="MOCKED_CRYPT_GROUP"
}

test_disk_manifest_line_log__generates_expected_output() {
  _capture.stdout _disk_manifest_line_log

  assert_output \
    "RPI_DISK_UUID='${TEST_MOCK_UUID_1}'
RPI_DISK_NAME='${TEST_MOCK_DISK_NAME_1}'
RPI_DISK_CRYPT_GROUP='${RPI_DISK_CRYPT_GROUP}'
RPI_DISK_MOUNT_POINT='${TEST_MOCK_MOUNT_POINT_1}'"
}
