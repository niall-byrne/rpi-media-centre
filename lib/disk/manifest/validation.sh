#!/bin/bash

# pictl disk manifest validation library

set -eo pipefail

RPI_DISK_MANIFEST_VALIDATORS_ALL_ARRAY=("configuration" "device" "filesystem")
RPI_DISK_MANIFEST_VALIDATORS_DISABLED_ARRAY=()

_disk_manifest_validation() {
  # shellcheck disable=SC2034
  local disk_manifest_disabled_validators=("${RPI_DISK_MANIFEST_VALIDATORS_DISABLED_ARRAY[@]}")
  local disk_manifest_validator
  local disk_manifest_validators=("${RPI_DISK_MANIFEST_VALIDATORS_ALL_ARRAY[@]}")

  for disk_manifest_validator in "${disk_manifest_validators[@]}"; do
    if ! stdlib.array.query.is_contains "${disk_manifest_validator}" disk_manifest_disabled_validators; then
      {
        "_disk_manifest_validation_${disk_manifest_validator}" || return "$?"
      }
    fi
  done
}

_disk_manifest_validation_configuration() {
  if [[ -z "${RPI_DISK_UUID}" ]] ||
    [[ -z "${RPI_DISK_NAME}" ]] ||
    [[ -z "${RPI_DISK_MOUNT_POINT}" ]]; then
    return 127
  fi
}

_disk_manifest_validation_device() {
  if ! blkid | grep "${RPI_DISK_UUID}" > /dev/null; then
    _cli_log_warning "DISK: UUID '${RPI_DISK_UUID}' could not be found."
  fi
}

_disk_manifest_validation_filesystem() {
  if ! stdlib.io.path.assert.is_folder "${RPI_DISK_MOUNT_POINT}"; then
    return 127
  fi

  if [[ "${RPI_RUNTIME_ENVIRONMENT}" != "service" ]]; then
    if ! stdlib.security.path.query.is_secure "${RPI_DISK_MOUNT_POINT}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"; then
      return 127
    fi
  fi
}
