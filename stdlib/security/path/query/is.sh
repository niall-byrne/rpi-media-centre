#!/bin/bash

# stdlib security path query is library

builtin set -eo pipefail

stdlib.security.path.query.is_secure() {
  # $1: the filesystem path to check
  # $2: the required user name
  # $3: the required group name
  # $4: the permission octal value required

  [[ "${#@}" == "4" ]] || return 127

  if ! stdlib.security.path.query.has_owner "${1}" "${2}" ||
    ! stdlib.security.path.query.has_group "${1}" "${3}" ||
    ! stdlib.security.path.query.has_permissions "${1}" "${4}"; then
    return 1
  fi
}
