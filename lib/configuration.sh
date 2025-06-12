#!/bin/bash

# pictl configuration library

set -eo pipefail

_check_permissions() {
  # $1: the file to check

  if [[ "$(stat -c "%a" "${1}")" != "600" ]]; then
    echo "The permissions on the file ${1} are not secure!"
    echo "Please consider running: chmod 600 ${1}"
    return 127
  fi
}

_configure_pictl() {
  if [[ -f .rpi ]]; then
    echo "-- loading .rpi file ... --"

    _check_permissions .rpi

    # shellcheck source=/dev/null
    source .rpi
  fi
}

_configure_samba() {
  if [[ -f .rpi-samba.yml ]]; then
    echo "-- loading .rpi-samba.yml file ... --"
    _check_permissions .rpi-samba.yml
    cp -a .rpi-samba.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  else
    cp -a ./services/samba/config.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  fi

  _io_prompt "Enter Samba Username: " "RPI_SAMBA_CREDENTIALS_USERNAME"
  _io_prompt "Enter Samba Password: " "RPI_SAMBA_CREDENTIALS_PASSWORD" "password"
  _io_prompt "Enter Samba Network CIDR: " "RPI_SAMBA_SUBNET"
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
