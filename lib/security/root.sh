#!/bin/bash

# pictl security root library

set -eo pipefail

__security_root_read_euid() {
  _RPI_SECURITY_EUID="${EUID}"
}

_security_root_require() {
  __security_root_read_euid

  if [[ "${_RPI_SECURITY_EUID}" -ne 0 ]]; then
    _cli_log_error "SECURITY: This script must be run as root."
    return 127
  fi

  if [[ -z "${SUDO_USER}" ]] && [[ -z "${RPI_SVC_USERNAME}" ]]; then
    _cli_log_error "SECURITY: pictl cannot be used as a root process."
    _cli_log_info "Please consider using an administrative user with 'sudo'."
    return 127
  fi
}
