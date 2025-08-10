#!/bin/bash
# @file secure.sh
# @brief A library for securing paths.
# @description
#   This library provides a function to secure a path by setting its owner, group, and permissions.

# stdlib security path secure library

set -eo pipefail

# @description Secures a path by setting its owner, group, and permissions.
# @arg $1 string The path to secure.
# @arg $2 string The owner name to set.
# @arg $3 string The group name to set.
# @arg $4 string The permission octal value to set.
# @exitcode ? Propagated from stdlib.fn.args.require, chown, and chmod.
stdlib.security.path.secure() {
  stdlib.fn.args.require "4" "0" "${@}" || return "$?"

  chown "${2}":"${3}" "${1}"
  chmod "${4}" "${1}"
}
