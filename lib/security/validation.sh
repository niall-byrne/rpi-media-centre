#!/bin/bash

# pictl security validation library

set -eo pipefail

_security_validation() {
  _security_validation_ids
  _security_validation_names
}

_security_validation_ids() {
  if [[ "${RPI_SVC_GID}" == "0" ]] ||
    [[ "${RPI_SVC_UID}" == "0" ]]; then
    _cli_log_error "SECURITY: invalid configuration!"
    _cli_log_error "Neither the 'RPI_SVC_GID' or 'RPI_SVC_UID' can be zero."
    return 127
  fi

  _security_validation_ids_relationship "RPI_SVC_GID" "RPI_SVC_GROUPNAME" "group"
  _security_validation_ids_relationship "RPI_SVC_UID" "RPI_SVC_USERNAME" "user"
}

_security_validation_ids_relationship() {
  # $1: the name of the optional variable
  # $2: the name of the required variable
  # $3: the name of the associated entity

  stdlib.fn.args.require "3" "0" "${@}"

  if [[ -n "${!1}" ]] &&
    [[ -z "${!2}" ]]; then
    _cli_log_error "SECURITY: invalid configuration!"
    _cli_log_error "The config cannot specify ${1} without a value for ${2}:"
    _cli_log_info " - ${1} may be used with the 'account' command to provision a new ${3}"
    _cli_log_info " - ${2} may be used to specify an existing ${3}"
    return 127
  fi

}

_security_validation_names() {
  if [[ "${RPI_SVC_USERNAME}" == "root" ]] ||
    [[ "${RPI_SVC_GROUPNAME}" == "root" ]]; then
    _cli_log_error "SECURITY: invalid configuration!"
    _cli_log_error "Neither the 'RPI_SVC_GROUPNAME' or 'RPI_SVC_USERNAME' can be root."
    return 127
  fi
}
