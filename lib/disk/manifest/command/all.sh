#!/bin/bash

# pictl disk manifest command all library

set -eo pipefail

# shellcheck disable=SC2034
_disk_manifest_command_all() {
  # $1: the command to execute on all disks

  local RPI_DISK_INDEX
  local RPI_DISK_UUID_SET=()
  local RPI_DISK_NAME_SET=()
  local RPI_DISK_CRYPT_GROUP_SET=()
  local RPI_DISK_MOUNT_POINT_SET=()
  local RPI_DISK_CRYPT_PASSWORD_SET=()

  if _is_disk_encrypted; then

    _disk_manifest_load
    _dependencies_group_disks_crypt

    for ((RPI_DISK_INDEX = 0; RPI_DISK_INDEX < "${#RPI_DISK_UUID_SET[@]}"; RPI_DISK_INDEX++)); do
      __disk_manifest_command_all_wrapper "${1}" \
        "${RPI_DISK_UUID_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_NAME_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_CRYPT_GROUP_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_MOUNT_POINT_SET[RPI_DISK_INDEX]}"
    done
  fi
}

# shellcheck disable=SC2034
__disk_manifest_command_all_wrapper() {
  local RPI_DISK_MANIFEST_ALL_COMMAND="${1}"
  local RPI_DISK_UUID="${2}"
  local RPI_DISK_NAME="${3}"
  local RPI_DISK_CRYPT_GROUP="${4}"
  local RPI_DISK_MOUNT_POINT="${5}"

  "${RPI_DISK_MANIFEST_ALL_COMMAND}"
}
