#!/bin/bash
# @file is.sh
# @brief A library for querying path security.
# @description
#   This library provides functions to query path security,
#   such as checking if a path is secure.

# stdlib security path query is library

set -eo pipefail

# @description Checks if a path is secure.
# This is a convenience function that combines checks for owner, group, and permissions.
# @arg $1 string The path to check.
# @arg $2 string The required user name.
# @arg $3 string The required group name.
# @arg $4 string The permission octal value required.
# @exitcode 0 If the path is secure.
# @exitcode 1 If the path is not secure.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @exitcode ? Propagated from the called query functions.
stdlib.security.path.query.is_secure() {
  [[ "${#@}" == "4" ]] || return 127

  if ! stdlib.security.path.query.has_owner "${1}" "${2}" ||
    ! stdlib.security.path.query.has_group "${1}" "${3}" ||
    ! stdlib.security.path.query.has_permissions "${1}" "${4}"; then
    return 1
  fi
}
