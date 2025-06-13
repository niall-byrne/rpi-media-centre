#!/bin/bash

# pictl disk library

set -eo pipefail

_is_disk_encrypted() {
  test -f .disk
}

_is_disk_mounted() {
  mountpoint "${RPI_MOUNT_POINT}" >> /dev/null 2>&1
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
  if _is_disk_encrypted; then
    if _is_disk_mounted; then
      echo "Unmounting partition ..."
      sudo umount /dev/mapper/media_centre

      echo "Sealing disk ..."
      sudo cryptsetup close /dev/mapper/media_centre
    fi
  fi
}

_disk_read_uuid() {
  tr -d "\n\r" < .disk
}

_disk_unlock() {
  if _is_disk_encrypted; then
    if ! _is_disk_mounted; then
      ENCRYPTED_DISK_UUID="$(_disk_read_uuid)"

      echo "Decrypting disk ..."
      sudo cryptsetup luksOpen "/dev/disk/by-uuid/${ENCRYPTED_DISK_UUID}" media_centre

      echo "Checking data ..."
      sudo fsck /dev/mapper/media_centre

      echo "Mounting partition ..."
      sudo mount /dev/mapper/media_centre "${RPI_MOUNT_POINT}" -o noatime,rw,errors=remount-ro
    fi
  fi
}
