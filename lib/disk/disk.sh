#!/bin/bash

# pictl disk library

set -eo pipefail

_disk_initialize_mounts() {
  if _is_service_selected "plex"; then
    _security_path_mkdir "${RPI_PLEX_PATH_CONFIG}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"
    _security_path_mkdir "${RPI_PLEX_PATH_TRANSCODE}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"
    _security_path_mkdir "${RPI_ROOT}/shared/media" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "750"
  fi

  if _is_service_selected "samba"; then
    _security_path_mkdir "${RPI_SAMBA_PATH_CONFIG}" "root" "root" "700"
    _security_path_mkdir "${RPI_SAMBA_PATH_CONFIG}/cache" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "755"
    _security_path_mkdir "${RPI_SAMBA_PATH_CONFIG}/lib" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "755"
    _security_path_mkdir "${RPI_ROOT}/shared/media" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "750"
    _security_path_mkdir "${RPI_ROOT}/shared/transfer" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "750"
  fi

  if _is_service_selected "syncthing"; then
    _security_path_mkdir "${RPI_SYNCTHING_PATH_CONFIG}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"
    _security_path_mkdir "${RPI_ROOT}/shared/syncthing" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "750"
  fi
}

_disk_lock() {
  if _is_disk_mounted "${RPI_DISK_UUID}" "${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}"; then
    echo "Unmounting disk '${RPI_DISK_NAME}' ..."
    umount "/dev/mapper/${RPI_DISK_NAME}"

    echo "Sealing disk '${RPI_DISK_NAME}' ..."
    cryptsetup close "/dev/mapper/${RPI_DISK_NAME}"
  fi
}

_disk_unlock() {
  if ! _is_disk_mounted "${RPI_DISK_UUID}" "${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}"; then
    _security_path_mkdir "${RPI_DISK_MOUNT_POINT}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUP}" "700"

    echo "Decrypting disk '${RPI_DISK_NAME}' ..."
    cryptsetup luksOpen "/dev/disk/by-uuid/${RPI_DISK_UUID}" "${RPI_DISK_NAME}"

    echo "Checking data on disk '${RPI_DISK_NAME}' ..."
    fsck "/dev/mapper/${RPI_DISK_NAME}"

    echo "Mounting disk '${RPI_DISK_NAME}' ..."
    mount "/dev/mapper/${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}" -o noatime,rw,errors=remount-ro
  fi
}
