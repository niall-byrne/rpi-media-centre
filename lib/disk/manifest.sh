#!/bin/bash

# pictl disk manifest library

set -eo pipefail

_disk_manifest_all_command() {
  # $1: The command to execute on all disks

  local RPI_DISK_INDEX
  local RPI_DISK_UUID_SET=()
  local RPI_DISK_NAME_SET=()
  local RPI_DISK_MOUNT_POINT_SET=()

  if _is_disk_encrypted; then
    _disk_manifest_load
    for ((RPI_DISK_INDEX = 0; RPI_DISK_INDEX < "${#RPI_DISK_UUID_SET[@]}"; RPI_DISK_INDEX++)); do

      _disk_manifest_all_command_wrapper \
        "${1}" \
        "${RPI_DISK_UUID_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_NAME_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_MOUNT_POINT_SET[RPI_DISK_INDEX]}"
    done
  fi
}

_disk_manifest_all_command_wrapper() {
  local RPI_DISK_MANIFEST_ALL_COMMAND="${1}"
  local RPI_DISK_UUID="${2}"
  local RPI_DISK_NAME="${3}"
  local RPI_DISK_MOUNT_POINT="${4}"

  "${RPI_DISK_MANIFEST_ALL_COMMAND}"
}

_disk_manifest_help() {
  echo "Each line should be a comma separated series of:"
  echo "  RPI_DISK_UUID                               - the UUID of the disk (find with: sudo blkid)"
  echo "  RPI_DISK_NAME                               - a unique name for this disk"
  echo "  RPI_DISK_MOUNT_POINT                        - a valid mount point for this disk on the filesystem"
}

_disk_manifest_line_invalid() {
  {
    echo "The .rpi/crypt file is improperly formatted!"
    echo "Input Line: ${FILE_LINE}"
    _disk_manifest_line_log
    _disk_manifest_help
  } >&2
  return 127
}

_disk_manifest_line_log() {
  echo "RPI_DISK_UUID='${RPI_DISK_UUID}'"
  echo "RPI_DISK_NAME='${RPI_DISK_NAME}'"
  echo "RPI_DISK_MOUNT_POINT='${RPI_DISK_MOUNT_POINT}'"
}

_disk_manifest_line_log_all() {
  echo "== Start of Disk '${RPI_DISK_NAME}' =="
  _disk_manifest_line_log
  echo "== End of Disk '${RPI_DISK_NAME}' =="
}

_disk_manifest_line_validate() {
  # $1: the help function to call in the event that the line is invalid

  _filesystem_check_is_folder "${RPI_DISK_MOUNT_POINT}"
  _filesystem_check_permissions "${RPI_DISK_MOUNT_POINT}" "700"

  if [[ -z "${RPI_DISK_UUID}" ]] ||
    [[ -z "${RPI_DISK_NAME}" ]] ||
    [[ -z "${RPI_DISK_MOUNT_POINT}" ]]; then
    return 127
  fi

  if ! sudo blkid | grep "${RPI_DISK_UUID}" > /dev/null; then
    echo "DISK: Warning the disk UUID '${RPI_DISK_UUID}' could not be found."
  fi
}

_disk_manifest_load() {
  local FILE_LINE
  local RPI_DISK_UUID
  local RPI_DISK_NAME
  local RPI_DISK_MOUNT_POINT

  echo "-- loading .rpi/crypt file ... --"

  _filesystem_check_permissions .rpi/crypt "600"

  while IFS= read -r FILE_LINE; do
    IFS="," read -r RPI_DISK_UUID RPI_DISK_NAME RPI_DISK_MOUNT_POINT <<< "$FILE_LINE"

    # Ignore comments
    if [[ "${FILE_LINE:0:1}" == "#" ]]; then
      continue
    fi

    # Ignore blank lines
    if [[ "${FILE_LINE}" == "" ]]; then
      continue
    fi

    _disk_manifest_line_validate "_disk_manifest_line_invalid"

    RPI_DISK_UUID_SET+=("${RPI_DISK_UUID}")
    RPI_DISK_NAME_SET+=("${RPI_DISK_NAME}")
    RPI_DISK_MOUNT_POINT_SET+=("${RPI_DISK_MOUNT_POINT}")

  done < .rpi/crypt
}

_disk_manifest_mount_all() {
  _disk_manifest_all_command "_disk_unlock"
  _event_script "event-disk-mounted.sh"
}

_disk_manifest_unmount_all() {
  _disk_manifest_all_command "_disk_lock"
  _event_script "event-disk-unmounted.sh"
}
