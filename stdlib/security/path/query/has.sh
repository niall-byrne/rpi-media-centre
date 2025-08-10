#!/bin/bash
# @file has.sh
# @brief A library for querying path ownership and permissions.
# @description
#   This library provides functions to query path ownership and permissions,
#   such as checking the group, owner, and permissions of a path.

# stdlib security path query has library

set -eo pipefail

# @description Checks if a path has the specified group.
# @arg $1 string The path to check.
# @arg $2 string The required group name.
# @exitcode 0 If the path has the specified group.
# @exitcode 1 If the path does not have the specified group.
# @exitcode 126 If an argument is empty or the path does not exist.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.security.path.query.has_group() {
  local required_gid

  [[ "${#@}" == "2" ]] || return 127
  stdlib.io.filesystem.query.exists "${1}" || return 126
  [[ -n "${2}" ]] || return 126

  required_gid="$(stdlib.security.get.gid "${2}")"

  if [[ "$(stat -c "%g" "${1}")" != "${required_gid}" ]]; then
    return 1
  fi
}

# @description Checks if a path has the specified owner.
# @arg $1 string The path to check.
# @arg $2 string The required user name.
# @exitcode 0 If the path has the specified owner.
# @exitcode 1 If the path does not have the specified owner.
# @exitcode 126 If an argument is empty or the path does not exist.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.security.path.query.has_owner() {
  local required_uid

  [[ "${#@}" == "2" ]] || return 127
  stdlib.io.filesystem.query.exists "${1}" || return 126
  [[ -n "${2}" ]] || return 126

  required_uid="$(stdlib.security.get.uid "${2}")"

  if [[ "$(stat -c "%u" "${1}")" != "${required_uid}" ]]; then
    return 1
  fi
}

# @description Checks if a path has the specified permissions.
# @arg $1 string The path to check.
# @arg $2 string The permission octal value required.
# @exitcode 0 If the path has the specified permissions.
# @exitcode 1 If the path does not have the specified permissions.
# @exitcode 126 If an argument is empty or the path does not exist.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.security.path.query.has_permissions() {
  [[ "${#@}" == "2" ]] || return 127
  stdlib.io.filesystem.query.exists "${1}" || return 126
  [[ -n "${2}" ]] || return 126

  if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
    return 1
  fi
}
