#!/bin/bash

# pictl disk manifest library

set -eo pipefail

_disk_manifest_all_command() {
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
      _disk_manifest_all_command_wrapper \
        "${1}" \
        "${RPI_DISK_UUID_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_NAME_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_CRYPT_GROUP_SET[RPI_DISK_INDEX]}" \
        "${RPI_DISK_MOUNT_POINT_SET[RPI_DISK_INDEX]}"
    done
  fi
}

_disk_manifest_all_command_wrapper() {
  local RPI_DISK_MANIFEST_ALL_COMMAND="${1}"
  local RPI_DISK_UUID="${2}"
  local RPI_DISK_NAME="${3}"
  local RPI_DISK_CRYPT_GROUP="${4}"
  local RPI_DISK_MOUNT_POINT="${5}"

  "${RPI_DISK_MANIFEST_ALL_COMMAND}"
}

_disk_manifest_help() {
  _cli_pretty_highlight "Each line should be a comma separated series of:"
  {
    echo " RPI_DISK_UUID        |the \`UUID\` of the disk (find with: sudo blkid)"
    echo " RPI_DISK_NAME        |a unique name for this disk"
    echo " RPI_DISK_CRYPT_GROUP |an optional identifier for disks that share a luks password"
    echo " RPI_DISK_MOUNT_POINT |a valid mount point for this disk on the filesystem"
  } | _cli_pretty_columns
}

_disk_manifest_line_invalid() {
  {
    echo "The /etc/rpi/crypt file is improperly formatted!"
    echo "Input Line: ${FILE_LINE}"
    _disk_manifest_line_log
    _disk_manifest_help
  } >&2
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

  if ! _filesystem_check_is_folder "${RPI_DISK_MOUNT_POINT}" ||
    ! _security_path_check "${RPI_DISK_MOUNT_POINT}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"; then
    "${1}"
    return 127
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

_disk_manifest_load() {
  local FILE_LINE
  local RPI_DISK_INDEX
  local RPI_DISK_UUID
  local RPI_DISK_NAME
  local RPI_DISK_CRYPT_GROUP
  local RPI_DISK_MOUNT_POINT

  _cli_log_notice "-- loading /etc/rpi/crypt file ... --"

  _security_path_check /etc/rpi/crypt "root" "root" "600"

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

  done < /etc/rpi/crypt
}

_disk_manifest_mount_all() {
  _event_script "event-disk-before-mounted.sh"
  _disk_manifest_all_command "_disk_unlock"
  _event_script "event-disk-after-mounted.sh"
}

_disk_manifest_unmount_all() {
  _event_script "event-disk-before-unmounted.sh"
  _disk_manifest_all_command "_disk_lock"
  _event_script "event-disk-after-unmounted.sh"
}
