#!/bin/bash
# @file is.sh
# @brief A library for making assertions about path security.
# @description
#   This library provides functions to make assertions about path security,
#   such as checking if a path is secure.

# stdlib security path assert is library

set -eo pipefail

# @description Asserts that a path is secure.
# This is a convenience function that combines checks for owner, group, and permissions.
# @arg $1 string The path to check.
# @arg $2 string The required user name.
# @arg $3 string The required group name.
# @arg $4 string The permission octal value required.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @exitcode ? Propagated from the called assert functions.
# @stderr Logs an error message if any of the security checks fail.
stdlib.security.path.assert.is_secure() {
  [[ "${#@}" == "4" ]] || return 127

  stdlib.security.path.assert.has_owner "${1}" "${2}" || return "$?"
  stdlib.security.path.assert.has_group "${1}" "${3}" || return "$?"
  stdlib.security.path.assert.has_permissions "${1}" "${4}" || return "$?"
}
