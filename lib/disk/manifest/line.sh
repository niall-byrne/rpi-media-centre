#!/bin/bash

# pictl disk manifest line library

set -eo pipefail

_disk_manifest_line_invalid() {
  {
    echo "The ${RPI_MANIFEST_CRYPT} file is improperly formatted!"
    echo "Input Line: ${FILE_LINE}"
    _disk_manifest_line_log
    _disk_manifest_help
  } >&2 # KCOV_EXCLUDE_LINE
  return 127
}

_disk_manifest_line_log() {
  echo "RPI_DISK_UUID='${RPI_DISK_UUID}'"
  echo "RPI_DISK_NAME='${RPI_DISK_NAME}'"
  echo "RPI_DISK_CRYPT_GROUP='${RPI_DISK_CRYPT_GROUP}'"
  echo "RPI_DISK_MOUNT_POINT='${RPI_DISK_MOUNT_POINT}'"
}

_disk_manifest_line_log_all() {
  _cli_log_notice "== Start of Disk '${RPI_DISK_NAME}' =="
  _disk_manifest_line_log
  _cli_log_notice "== End of Disk '${RPI_DISK_NAME}' =="
}

_disk_manifest_line_validate() {
  # $1: the help function to call in the event that the line is invalid

  if ! stdlib.io.path.assert.is_folder "${RPI_DISK_MOUNT_POINT}"; then
    "${1}"
    return 127
  fi

  if [[ "${RPI_RUNTIME_ENVIRONMENT}" != "service" ]]; then
    # TODO: investigate a better way of handling service mode for these exceptions
    if ! stdlib.security.path.query.is_secure "${RPI_DISK_MOUNT_POINT}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"; then
      "${1}"
      return 127
    fi
  fi

  if [[ -z "${RPI_DISK_UUID}" ]] ||
    [[ -z "${RPI_DISK_NAME}" ]] ||
    [[ -z "${RPI_DISK_MOUNT_POINT}" ]]; then
    "${1}"
    return 127
  fi

  if ! blkid | grep "${RPI_DISK_UUID}" > /dev/null; then
    _cli_log_warning "DISK: UUID '${RPI_DISK_UUID}' could not be found."
  fi
}
