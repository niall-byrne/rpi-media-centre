#!/bin/bash

# pictl security defaults library

set -eo pipefail

_security_defaults_set() {
  _security_defaults_set_username
  _security_defaults_set_uid
  _security_defaults_set_groupname
  _security_defaults_set_gid
  _security_defaults_set_uid_ro
}

_security_defaults_set_gid() {
  local RPI_SVC_NEW_GID

  RPI_SVC_NEW_GID="$(_security_id_get_gid "${RPI_SVC_GROUPNAME}")"

  _security_warning_variable_mutated \
    "RPI_SVC_GID" \
    "RPI_SVC_NEW_GID" \
    "RPI_SVC_GROUPNAME"

  # shellcheck disable=SC2034
  RPI_SVC_GID="${RPI_SVC_NEW_GID}"
}

_security_defaults_set_groupname() {
  if [[ -n "${RPI_SVC_GROUPNAME}" ]]; then
    # Group has been specified, check if it exists.
    if ! getent group "${RPI_SVC_GROUPNAME}" > /dev/null 2>&1; then
      _cli_log_error "SECURITY: The specified group '${RPI_SVC_GROUPNAME}' (RPI_SVC_GROUPNAME) does not exist!"
      _cli_log_info "Please consider using the 'account' command to provision it."
      return 127
    fi
  else
    # No group specified, try to use the primary group of RPI_SVC_USERNAME
    RPI_SVC_GROUPNAME="$(id -gn "${RPI_SVC_USERNAME}")"
  fi
}

_security_defaults_set_username() {
  if [[ -n "${RPI_SVC_USERNAME}" ]]; then
    if ! id "${RPI_SVC_USERNAME}" > /dev/null 2>&1; then
      _cli_log_error "SECURITY: The specified user '${RPI_SVC_USERNAME}' (RPI_SVC_USERNAME) does not exist!"
      _cli_log_info "Please consider using the 'account' command to provision it."
      return 127
    fi
    return 0
  elif [[ -n "${RPI_SVC_GROUPNAME}" ]]; then
    # If a group has been specified, without a username, the config is invalid
    _cli_log_error "SECURITY: invalid configuration!"
    _cli_log_error "The 'RPI_SVC_GROUPNAME' is specified without 'RPI_SVC_USERNAME'."
    return 127
  else
    # Otherwise, fallback to the SUDO_USER for single user mode
    RPI_SVC_USERNAME="${SUDO_USER}"
  fi
}

_security_defaults_set_uid() {
  local RPI_SVC_NEW_UID

  RPI_SVC_NEW_UID="$(_security_id_get_uid "${RPI_SVC_USERNAME}")"

  _security_warning_variable_mutated \
    "RPI_SVC_UID" \
    "RPI_SVC_NEW_UID" \
    "RPI_SVC_USERNAME"

  # shellcheck disable=SC2034
  RPI_SVC_UID="${RPI_SVC_NEW_UID}"
}

_security_defaults_set_uid_ro() {
  RPI_SVC_UID_RO="${RPI_SVC_UID_RO:-"$(_security_id_get_uid_next_available)"}"
}
