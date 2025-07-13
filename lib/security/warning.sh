#!/bin/bash

# pictl security warn library

set -eo pipefail

_security_warning_single_user_mode() {
  _security_defaults_set

  if [[ "${RPI_SVC_USERNAME}" == "${SUDO_USER}" ]] &&
    [[ -z "${RPI_DISABLE_SINGLE_USER_MODE_WARNING_BOOLEAN}" ]]; then
    _cli_log_warning "SECURITY: pictl is running in single user mode"
    _cli_log_warning "  Concurrent user access is not supported."
    echo "Consider appending the following to your /etc/rpi/config file:"
    echo '  RPI_SVC_USERNAME="service_account_username"'
    echo "Please see the documentation for further details or to learn how to silence this warning."
  fi
}

_security_warning_variable_mutated() {
  # $1: name of the variable being checked
  # $2: name of the variable to check against
  # $3: name of the variable responsible

  if [[ -n "${!1}" ]] &&
    [[ "${!1}" != "${!2}" ]]; then
    _cli_log_warning "SECURITY: The configured ${1} value has been overridden due to the value of ${3}."
    echo "Please consider removing the unnecessary ${1} value."
  fi
}
