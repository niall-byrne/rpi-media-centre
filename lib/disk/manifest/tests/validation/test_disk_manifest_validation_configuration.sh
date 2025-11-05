#!/bin/bash

@parametrize_with_missing_values() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_DISK_UUID;TEST_DISK_NAME;TEST_DISK_MOUNT_POINT;TEST_RC" \
    "all_values;MOCK_UUID;MOCK_DISK_NAME;MOCK_MOUNT_POINT;0" \
    "no_uuid___;;MOCK_DISK_NAME;MOCK_DISK_MOUNT_POINT;127" \
    "no_name___;MOCK_DISK_UUID;;MOCK_DISK_MOUNT_POINT;127" \
    "no_mp_____;MOCK_DISK_UUID;MOCK_DISK_NAME;;127" \
    "no_values_;;;;127"
}

# shellcheck disable=SC2034
test_disk_manifest_validation_configuration___@vary__returns_expected_status_code() {
  local RPI_DISK_UUID="${TEST_DISK_UUID}"
  local RPI_DISK_NAME="${TEST_DISK_NAME}"
  local RPI_DISK_MOUNT_POINT="${TEST_DISK_MOUNT_POINT}"

  _capture.rc _disk_manifest_validation_configuration

  assert_rc "${TEST_RC}"
}

@parametrize_with_missing_values \
  test_disk_manifest_validation_configuration___@vary__returns_expected_status_code
