#!/bin/bash
# shellcheck disable=SC2034

# pictl testing disk fixtures

set -eo pipefail

fake_crypt_data_1() {
  TEST_MOCK_DISK_NAME_1="mocked_disk1"
  TEST_MOCK_MOUNT_POINT_1="/mnt/mocked/path1"
  TEST_MOCK_UUID_1="$(uuidgen)"
}

fake_crypt_data_2() {
  TEST_MOCK_DISK_NAME_2="mocked_disk2"
  TEST_MOCK_MOUNT_POINT_2="/mnt/mocked/path2"
  TEST_MOCK_UUID_2="$(uuidgen)"
}

fake_crypt_data_3() {
  TEST_MOCK_DISK_NAME_3="mocked_disk3"
  TEST_MOCK_MOUNT_POINT_3="/mnt/mocked/path3"
  TEST_MOCK_UUID_3="$(uuidgen)"
}

fake_disk_1() {
  fake_crypt_data_1
  RPI_DISK_NAME="${TEST_MOCK_DISK_NAME_1}"
  RPI_DISK_MOUNT_POINT="${TEST_MOCK_MOUNT_POINT_1}"
  RPI_DISK_UUID="${TEST_MOCK_UUID_1}"
}

fake_disk_2() {
  fake_crypt_data_2
  RPI_DISK_NAME="${TEST_MOCK_DISK_NAME_2}"
  RPI_DISK_MOUNT_POINT="${TEST_MOCK_MOUNT_POINT_2}"
  RPI_DISK_UUID="${TEST_MOCK_UUID_2}"
}

fake_disk_3() {
  fake_crypt_data_3
  RPI_DISK_NAME="${TEST_MOCK_DISK_NAME_3}"
  RPI_DISK_MOUNT_POINT="${TEST_MOCK_MOUNT_POINT_3}"
  RPI_DISK_UUID="${TEST_MOCK_UUID_3}"
}

fake_manifest_n_entries() {
  # $1: the number of entries to create

  local FAKE_MANIFEST_INDEX

  for ((FAKE_MANIFEST_INDEX = 0; FAKE_MANIFEST_INDEX < "${1}"; FAKE_MANIFEST_INDEX++)); do
    RPI_DISK_UUID_SET+=("UUID${FAKE_MANIFEST_INDEX}")
    RPI_DISK_NAME_SET+=("mocked_disk${FAKE_MANIFEST_INDEX}")
    RPI_DISK_CRYPT_GROUP_SET+=("crypt_group${FAKE_MANIFEST_INDEX}")
    RPI_DISK_MOUNT_POINT_SET+=("/mnt/mocked/path${FAKE_MANIFEST_INDEX}")
    RPI_DISK_CRYPT_PASSWORD_SET+=($'\\0')
  done
}

_create_fake_disk_n_log_entries() {
  # $1: the number of log entries to create

  local FAKE_MANIFEST_INDEX

  for ((FAKE_MANIFEST_INDEX = 0; FAKE_MANIFEST_INDEX < "${1}"; FAKE_MANIFEST_INDEX++)); do
    RPI_DISK_UUID="UUID${FAKE_MANIFEST_INDEX}"
    RPI_DISK_NAME="mocked_disk${FAKE_MANIFEST_INDEX}"
    RPI_DISK_CRYPT_GROUP="crypt_group${FAKE_MANIFEST_INDEX}"
    RPI_DISK_MOUNT_POINT="/mnt/mocked/path${FAKE_MANIFEST_INDEX}"
    _disk_manifest_line_log
  done
}

_create_fake_disk_with_crypt_group() {
  # $1: the disk number to use as a base [1-3]
  # $2: the crypt group to specify

  "fake_disk_${1}"
  RPI_DISK_CRYPT_GROUP="${2}"
}
