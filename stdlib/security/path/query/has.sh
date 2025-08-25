#!/bin/bash

# stdlib security path query has library

builtin set -eo pipefail

stdlib.security.path.query.has_group() {
  # $1: the path to check
  # $2: the required group name

  local required_gid

  [[ "${#@}" == "2" ]] || return 127
  stdlib.io.path.query.is_exists "${1}" || return 126
  [[ -n "${2}" ]] || return 126

  required_gid="$(stdlib.security.get.gid "${2}")"

  if [[ "$(stat -c "%g" "${1}")" != "${required_gid}" ]]; then
    return 1
  fi
}

stdlib.security.path.query.has_owner() {
  # $1: the path to check
  # $2: the required user name

  local required_uid

  [[ "${#@}" == "2" ]] || return 127
  stdlib.io.path.query.is_exists "${1}" || return 126
  [[ -n "${2}" ]] || return 126

  required_uid="$(stdlib.security.get.uid "${2}")"

  if [[ "$(stat -c "%u" "${1}")" != "${required_uid}" ]]; then
    return 1
  fi
}

stdlib.security.path.query.has_permissions() {
  # $1: the path to check
  # $2: the permission octal value required

  [[ "${#@}" == "2" ]] || return 127
  stdlib.io.path.query.is_exists "${1}" || return 126
  stdlib.string.query.is_octal_permission "${2}" || return 126

  if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
    return 1
  fi
}
