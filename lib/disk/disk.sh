#!/bin/bash

# pictl disk library

set -eo pipefail

_disk_initialize_mounts() {
  if _is_service_selected "plex"; then
    mkdir -p "${RPI_PLEX_PATH_CONFIG}"
    mkdir -p "${RPI_PLEX_PATH_TRANSCODE}"
    mkdir -p "${RPI_ROOT}"/shared/media
  fi

  if _is_service_selected "samba"; then
    mkdir -p "${RPI_SAMBA_PATH_CONFIG}"/{cache,lib}
    mkdir -p "${RPI_ROOT}"/shared/{media,transfer}
  fi

  if _is_service_selected "syncthing"; then
    mkdir -p "${RPI_SYNCTHING_PATH_CONFIG}"
    mkdir -p "${RPI_ROOT}"/shared/syncthing
  fi
}

_disk_lock() {
  if _is_disk_mounted "${RPI_DISK_UUID}" "${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}"; then
    echo "Unmounting disk '${RPI_DISK_NAME}' ..."
    sudo umount "/dev/mapper/${RPI_DISK_NAME}"

    echo "Sealing disk '${RPI_DISK_NAME}' ..."
    sudo cryptsetup close "/dev/mapper/${RPI_DISK_NAME}"
  fi
}

_disk_unlock() {
  if _is_disk_mounted "${RPI_DISK_UUID}" "${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}"; then
    mkdir -p "${RPI_DISK_MOUNT_POINT}"

    echo "Decrypting disk '${RPI_DISK_NAME}' ..."
    sudo cryptsetup luksOpen "/dev/disk/by-uuid/${RPI_DISK_UUID}" "${RPI_DISK_NAME}"

    echo "Checking data on disk '${RPI_DISK_NAME}' ..."
    sudo fsck "/dev/mapper/${RPI_DISK_NAME}"

    echo "Mounting disk '${RPI_DISK_NAME}' ..."
    sudo mount "/dev/mapper/${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}" -o noatime,rw,errors=remount-ro
  fi
}
