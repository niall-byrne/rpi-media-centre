#!/bin/bash

# pictl configuration library

set -eo pipefail

_configure_pictl() {
  if [[ -f .rpi ]]; then
    echo "-- loading .rpi file ... --"

    if [[ "$(stat -c "%a" .rpi)" != "600" ]]; then
      echo "The permissions on the .rpi file are not secure!"
      echo "Please consider running: chmod 600 .rpi"
      return 127
    fi

    # shellcheck source=/dev/null
    source .rpi
  fi
}

_configure_samba() {
  _service_prompt "Enter Samba Username: " "RPI_SAMBA_CREDENTIALS_USERNAME"
  _service_prompt "Enter Samba Password: " "RPI_SAMBA_CREDENTIALS_PASSWORD" "password"
  _service_prompt "Enter Samba Network CIDR: " "RPI_SAMBA_SUBNET"

  cp -r services/samba/* "${RPI_MOUNT_POINT}"/samba
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
