#!/bin/bash

# pictl disk manifest load library

set -eo pipefail

_disk_manifest_load() {
  local FILE_LINE
  local RPI_DISK_INDEX
  local RPI_DISK_UUID
  local RPI_DISK_NAME
  local RPI_DISK_CRYPT_GROUP
  local RPI_DISK_MOUNT_POINT

  _cli_log_notice "-- loading ${RPI_MANIFEST_CRYPT} file ... --"

  stdlib.security.path.query.is_secure "${RPI_MANIFEST_CRYPT}" "root" "root" "600"

  while IFS= read -r FILE_LINE; do
    IFS="," read -r \
      RPI_DISK_UUID \
      RPI_DISK_NAME \
      RPI_DISK_CRYPT_GROUP \
      RPI_DISK_MOUNT_POINT \
      <<< "$FILE_LINE"

    # Ignore comments
    if [[ "${FILE_LINE:0:1}" == "#" ]]; then
      continue
    fi

    # Ignore blank lines
    if [[ "${FILE_LINE}" == "" ]]; then
      continue
    fi

    _disk_manifest_line_validate "_disk_manifest_line_invalid"

    for ((RPI_DISK_INDEX = 0; RPI_DISK_INDEX < "${#RPI_DISK_NAME_SET[@]}"; RPI_DISK_INDEX++)); do
      if [[ "${RPI_DISK_NAME_SET["${RPI_DISK_INDEX}"]}" == "${RPI_DISK_NAME}" ]]; then
        _cli_log_error "The disk name '${RPI_DISK_NAME}' is used multiple times, this value must be unique."
        _disk_manifest_line_invalid
      fi
    done

    RPI_DISK_UUID_SET+=("${RPI_DISK_UUID}")
    RPI_DISK_NAME_SET+=("${RPI_DISK_NAME}")
    RPI_DISK_CRYPT_GROUP_SET+=("${RPI_DISK_CRYPT_GROUP}")
    RPI_DISK_MOUNT_POINT_SET+=("${RPI_DISK_MOUNT_POINT}")
    RPI_DISK_CRYPT_PASSWORD_SET+=($'\\0')

  done < "${RPI_MANIFEST_CRYPT}" # KCOV_EXCLUDE_LINE
}
