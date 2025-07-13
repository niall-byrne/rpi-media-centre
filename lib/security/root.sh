#!/bin/bash

# pictl security root library

set -eo pipefail

_security_root_require() {
  if [[ "${EUID}" -ne 0 ]]; then
    {
      echo "-- ERROR --"
      echo "SECURITY: This script must be run as root."
    } >&2
    exit 127
  fi

  if [[ -z "${SUDO_USER}" ]] && [[ -z "${RPI_SVC_USERNAME}" ]]; then
    {
      echo "-- ERROR --"
      echo "SECURITY: pictl cannot be used as a root process."
      echo "Please consider using an administrative user with 'sudo'."
    }
    return 127
  fi
}
