#!/bin/bash

# pictl security root library

set -eo pipefail

_security_root_require() {
  stdlib.security.assert.is_root_user || return 127

  if [[ -z "${SUDO_USER}" ]] && [[ -z "${RPI_SVC_USERNAME}" ]]; then
    _cli_log_error "SECURITY: pictl cannot be used as a root process."
    _cli_log_info "Please consider using an administrative user with 'sudo'."
    return 127
  fi
}
