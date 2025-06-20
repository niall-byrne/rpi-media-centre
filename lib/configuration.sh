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
  _io_prompt "Enter Samba Username: " "RPI_SAMBA_CREDENTIALS_USERNAME"
  _io_prompt "Enter Samba Password: " "RPI_SAMBA_CREDENTIALS_PASSWORD" "password"
  _io_prompt "Enter Samba Network CIDR: " "RPI_SAMBA_SUBNET"

  cp -r services/samba/* "${RPI_MOUNT_POINT}"/samba
}
