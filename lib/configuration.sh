#!/bin/bash

# pictl configuration library

set -eo pipefail

_configure_backup() {
  # 1: Backup Source
  # 2: Backup Target

  if [[ -z "${RPI_PATH_BACKUP}" ]]; then
    echo "Please configure a value for RPI_PATH_BACKUP in the .rpi/config file."
    return 127
  fi

  echo "Backing up ${2} ..."
  mkdir -p "${RPI_PATH_BACKUP}/${2}"
  echo "  ${1} -> ${RPI_PATH_BACKUP}/${2} ..."
  if [[ -f ${1} ]]; then
    sudo rsync -ah "${1}" "${RPI_PATH_BACKUP}/${2}"
  else
    sudo rsync -ah --delete "${1}/" "${RPI_PATH_BACKUP}/${2}"
  fi

  chmod 700 "${RPI_PATH_BACKUP}/${2}"

  echo "Backup of ${2} is complete!"
}

_configure_pictl() {
  if [[ -f .rpi/config ]]; then
    echo "-- loading .rpi/config file ... --"
    _filesystem_check_permissions .rpi/config "600"
    # shellcheck source=/dev/null
    source .rpi/config
  fi
}

_configure_samba() {
  if [[ -f .rpi/samba.yml ]]; then
    echo "-- loading .rpi/samba.yml file ... --"
    _filesystem_check_permissions .rpi/samba.yml "600"
    cp .rpi/samba.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  else
    cp ./services/samba/config.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  fi

  _service_prompt "Enter Samba Username: " "RPI_SAMBA_CREDENTIALS_USERNAME"
  _service_prompt "Enter Samba Password: " "RPI_SAMBA_CREDENTIALS_PASSWORD" "password"
  _service_prompt "Enter Samba Network CIDR: " "RPI_SAMBA_SUBNET"
}

_configure_syncthing() {
  _service_syncthing_configure_setting RPI_SYNCTHING_CREDENTIALS_USERNAME gui user
  _service_syncthing_configure_setting RPI_SYNCTHING_CREDENTIALS_PASSWORD gui password
}

_service_syncthing_wait() {
  while ! curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health >> /dev/null 2>&1; do
    sleep 1
  done
}

_service_syncthing_configure_setting() {
  # $1 the optional value to use
  # $@ the config key to set

  local VALUE="${1}"

  shift

  if [[ -n "${!VALUE}" ]]; then
    echo "Configuring syncthing '${*}' with environment variable '${VALUE}' ..."
    _service_syncthing_wait
    _docker_compose_exec syncthing syncthing cli config "$@" set "${!VALUE}" >> /dev/null 2>&1
    sleep 1
  fi
}
