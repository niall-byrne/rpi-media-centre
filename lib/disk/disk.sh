#!/bin/bash

# pictl disk library

set -eo pipefail

_disk_initialize_mounts() {
  if _is_service_selected "pihole"; then
    _security_path_mkdir "${RPI_PIHOLE_PATH_CONFIG}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"
    _security_path_mkdir "${RPI_PIHOLE_PATH_DNSMASQ}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUPNAME}" "700"
  fi

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
    _cli_log_warning "Unmounting disk '${RPI_DISK_NAME}' ..."
    umount "/dev/mapper/${RPI_DISK_NAME}"

    _cli_log_warning "Sealing disk '${RPI_DISK_NAME}' ..."
    cryptsetup close "/dev/mapper/${RPI_DISK_NAME}"
  fi
}

_disk_unlock() {
  local RPI_DISK_CRYPT_PASSWORD

  if ! _is_disk_mounted "${RPI_DISK_UUID}" "${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}"; then
    _security_path_mkdir "${RPI_DISK_MOUNT_POINT}" "${RPI_SVC_USERNAME}" "${RPI_SVC_GROUP}" "700"

    _cli_log_warning "Decrypting disk '${RPI_DISK_NAME}' ..."

    if [[ -n "${RPI_DISK_CRYPT_GROUP}" ]]; then
      _disk_unlock_with_crypt_group
    else
      _disk_unlock_without_crypt_group
    fi

    _cli_log_warning "Checking data on disk '${RPI_DISK_NAME}' ..."
    fsck "/dev/mapper/${RPI_DISK_NAME}"

    _cli_log_notice "Mounting disk '${RPI_DISK_NAME}' ..."
    mount "/dev/mapper/${RPI_DISK_NAME}" "${RPI_DISK_MOUNT_POINT}" -o noatime,rw,errors=remount-ro
  fi
}

_disk_unlock_with_crypt_group() {
  local RPI_DISK_INDEX

  for ((RPI_DISK_INDEX = 0; RPI_DISK_INDEX < "${#RPI_DISK_CRYPT_GROUP_SET[@]}"; RPI_DISK_INDEX++)); do
    if [[ "${RPI_DISK_CRYPT_GROUP}" == "${RPI_DISK_CRYPT_GROUP_SET["${RPI_DISK_INDEX}"]}" ]]; then
      RPI_DISK_CRYPT_PASSWORD="${RPI_DISK_CRYPT_PASSWORD_SET["${RPI_DISK_INDEX}"]}"
      break
    fi
  done

  if [[ "${RPI_DISK_CRYPT_PASSWORD}" == $'\\0' ]]; then
    RPI_DISK_CRYPT_PASSWORD=""
    _io_prompt "Enter the password for disk group '${RPI_DISK_CRYPT_GROUP}': " "RPI_DISK_CRYPT_PASSWORD" "password"
    RPI_DISK_CRYPT_PASSWORD_SET["${RPI_DISK_INDEX}"]="${RPI_DISK_CRYPT_PASSWORD}"
  fi

  echo "${RPI_DISK_CRYPT_PASSWORD}" |
    cryptsetup luksOpen "/dev/disk/by-uuid/${RPI_DISK_UUID}" "${RPI_DISK_NAME}"
}

_disk_unlock_without_crypt_group() {
  cryptsetup luksOpen "/dev/disk/by-uuid/${RPI_DISK_UUID}" "${RPI_DISK_NAME}"
}
