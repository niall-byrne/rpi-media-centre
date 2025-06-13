#!/bin/bash

# pictl disk library

set -eo pipefail

_is_disk_encrypted() {
  test -f .rpi-crypt
}

_is_disk_mounted() {
  # $1: Encrypted Disk UUID
  # $2: Encrypted Disk Mapper Name
  # $3: Encrypted Disk Mount Point

  mountpoint "${3}" >> /dev/null 2>&1
}

_is_disk_mounted_all() {
  _disk_all_command "_is_disk_mounted"
}

_disk_all_command() {
  # $1: The command to execute on all disks

  local ENCRYPTED_DISK_INDEX
  local ENCRYPTED_DISK_UUID_SET=()
  local ENCRYPTED_DISK_NAME_SET=()
  local ENCRYPTED_DISK_MOUNT_POINT_SET=()

  if _is_disk_encrypted; then
    _disk_read_crypt_file
    for ((ENCRYPTED_DISK_INDEX = 0; ENCRYPTED_DISK_INDEX < "${#ENCRYPTED_DISK_UUID_SET[@]}"; ENCRYPTED_DISK_INDEX++)); do
      "${1}" "${ENCRYPTED_DISK_UUID_SET[ENCRYPTED_DISK_INDEX]}" \
        "${ENCRYPTED_DISK_NAME_SET[ENCRYPTED_DISK_INDEX]}" \
        "${ENCRYPTED_DISK_MOUNT_POINT_SET[ENCRYPTED_DISK_INDEX]}"
    done
  fi
}

_disk_initialize_mounts() {
  if _is_service_selected "plex"; then
    mkdir -p "${RPI_PLEX_PATH_CONFIG}"
    mkdir -p "${RPI_PLEX_PATH_TRANSCODE}"
    mkdir -p "${RPI_MOUNT_POINT}"/shared/media
  fi

  if _is_service_selected "samba"; then
    mkdir -p "${RPI_SAMBA_PATH_CONFIG}"/{cache,lib}
    mkdir -p "${RPI_MOUNT_POINT}"/shared/{media,transfer}
  fi

  if _is_service_selected "syncthing"; then
    mkdir -p "${RPI_SYNCTHING_PATH_CONFIG}"
    mkdir -p "${RPI_MOUNT_POINT}"/shared/syncthing
  fi
}

_disk_lock() {
  # $1: Encrypted Disk UUID
  # $2: Encrypted Disk Mapper Name
  # $3: Encrypted Disk Mount Point

  if _is_disk_mounted "${@}"; then
    echo "Unmounting disk '${2}' ..."
    sudo umount "/dev/mapper/${2}"

    echo "Sealing disk '${2}' ..."
    sudo cryptsetup close "/dev/mapper/${2}"
  fi
}

_disk_mount_all() {
  _disk_all_command "_disk_unlock"
}

_disk_read_crypt_file() {
  local FILE_LINE
  local ENCRYPTED_DISK_UUID
  local ENCRYPTED_DISK_NAME
  local ENCRYPTED_DISK_MOUNT_POINT

  echo "-- loading .rpi-crypt file ... --"

  _check_permissions .rpi-crypt

  while IFS= read -r FILE_LINE; do
    IFS="," read -r ENCRYPTED_DISK_UUID ENCRYPTED_DISK_NAME ENCRYPTED_DISK_MOUNT_POINT <<< "$FILE_LINE"
    if [[ -z "${ENCRYPTED_DISK_UUID}" ]] && [[ -z "${ENCRYPTED_DISK_NAME}" ]] && [[ -z "${ENCRYPTED_DISK_MOUNT_POINT}" ]]; then
      continue
    fi
    if [[ -z "${ENCRYPTED_DISK_UUID}" ]] || [[ -z "${ENCRYPTED_DISK_NAME}" ]] || [[ -z "${ENCRYPTED_DISK_MOUNT_POINT}" ]]; then
      echo "The .rpi-crypt file is improperly formatted!"
      echo "Each line should be a comma separated series of: ENCRYPTED_DISK_UUID,ENCRYPTED_DISK_NAME,ENCRYPTED_DISK_MOUNT_POINT"
    fi

    ENCRYPTED_DISK_UUID_SET+=("${ENCRYPTED_DISK_UUID}")
    ENCRYPTED_DISK_NAME_SET+=("${ENCRYPTED_DISK_NAME}")
    ENCRYPTED_DISK_MOUNT_POINT_SET+=("${ENCRYPTED_DISK_MOUNT_POINT}")

  done < .rpi-crypt
}

_disk_unlock() {
  # $1: Encrypted Disk UUID
  # $2: Encrypted Disk Mapper Name
  # $3: Encrypted Disk Mount Point

  if ! _is_disk_mounted "${@}"; then
    mkdir -p "${3}"

    echo "Decrypting disk '${2}' ..."
    sudo cryptsetup luksOpen "/dev/disk/by-uuid/${1}" "${2}"

    echo "Checking data on disk '${2}' ..."
    sudo fsck "/dev/mapper/${2}"

    echo "Mounting disk '${2}' ..."
    sudo mount "/dev/mapper/${2}" "${3}" -o noatime,rw,errors=remount-ro
  fi
}

_disk_unmount_all() {
  _disk_all_command "_disk_lock"
}

