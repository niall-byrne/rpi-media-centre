#!/bin/bash

# pictl security path library

set -eo pipefail

_security_path_check() {
  # $1: the filesystem path to check
  # $2: the required user name
  # $3: the required group name
  # $4: the permission octal value required

  if ! _security_path_check_ownership "${1}" "${2}" "${3}"; then
    return 127
  fi
  if ! _security_path_check_permissions "${1}" "${4}"; then
    return 127
  fi
}

_security_path_check_ownership() {
  # $1: the path to check
  # $2: the required user name
  # $3: the required group name

  local RPI_SECURITY_REQUIRED_UID
  local RPI_SECURITY_REQUIRED_GID

  RPI_SECURITY_REQUIRED_UID="$(_security_id_get_uid "${2}")"
  RPI_SECURITY_REQUIRED_GID="$(_security_id_get_gid "${3}")"

  if [[ "$(stat -c "%u" "${1}")" != "${RPI_SECURITY_REQUIRED_UID}" ]]; then
    {
      echo "SECURITY: The permissions on '${1}' are not secure!"
      echo "Please consider running: chown ${2}:${3} ${1}"
    } >&2
    return 127
  fi

  if [[ "$(stat -c "%g" "${1}")" != "${RPI_SECURITY_REQUIRED_GID}" ]]; then
    {
      echo "SECURITY: The permissions on '${1}' are not secure!"
      echo "Please consider running: chgrp ${3} ${1}"
    } >&2
    return 127
  fi
}

_security_path_check_permissions() {
  # $1: the path to check
  # $2: the permission octal value required

  if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
    {
      echo "SECURITY: The permissions on '${1}' are not secure!"
      echo "Please consider running: chmod ${2} ${1}"
    } >&2
    return 127
  fi
}

_security_path_mkdir() {
  # $1: the directory to create
  # $2: the owner name to set
  # $3: the group name to set
  # $4: the permission octal value  to set

  mkdir -p "${1}"
  _security_path_secure "$@"
}

_security_path_secure() {
  # $1: the filesystem path to secure
  # $2: the owner name to set
  # $3: the group name to set
  # $4: the permission octal value to set

  chown "${2}":"${3}" "${1}"
  chmod "${4}" "${1}"
}
