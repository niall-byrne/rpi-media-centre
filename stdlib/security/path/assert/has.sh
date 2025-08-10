#!/bin/bash
# @file has.sh
# @brief A library for making assertions about path ownership and permissions.
# @description
#   This library provides functions to make assertions about path ownership and permissions,
#   such as checking the group, owner, and permissions of a path.

# stdlib security path assert has library

set -eo pipefail

# @description Asserts that a path has the specified group.
# @arg $1 string The path to check.
# @arg $2 string The required group name.
# @exitcode 0 If the path has the specified group.
# @exitcode 1 If the path does not have the specified group.
# @exitcode 126 If wrong or invalid arguments have been passed.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the group is not correct or if the arguments are invalid.
stdlib.security.path.assert.has_group() {
  local return_code=0

  stdlib.security.path.query.has_group "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    1)
      stdlib.logger.error "SECURITY: The group ownership on '${1}' is not secure!"
      stdlib.logger.info "Please consider running: sudo chgrp ${2} ${1}"
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
  esac

  return "${return_code}"
}

# @description Asserts that a path has the specified owner.
# @arg $1 string The path to check.
# @arg $2 string The required user name.
# @exitcode 0 If the path has the specified owner.
# @exitcode 1 If the path does not have the specified owner.
# @exitcode 126 If wrong or invalid arguments have been passed.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the owner is not correct or if the arguments are invalid.
stdlib.security.path.assert.has_owner() {
  local return_code=0

  stdlib.security.path.query.has_owner "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    1)
      stdlib.logger.error "SECURITY: The ownership on '${1}' is not secure!"
      stdlib.logger.info "Please consider running: sudo chown ${2} ${1}"
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
  esac

  return "${return_code}"
}

# @description Asserts that a path has the specified permissions.
# @arg $1 string The path to check.
# @arg $2 string The permission octal value required.
# @exitcode 0 If the path has the specified permissions.
# @exitcode 1 If the path does not have the specified permissions.
# @exitcode 126 If wrong or invalid arguments have been passed.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the permissions are not correct or if the arguments are invalid.
stdlib.security.path.assert.has_permissions() {
  local return_code=0

  stdlib.security.path.query.has_permissions "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    1)
      stdlib.logger.error "SECURITY: The permissions on '${1}' are not secure!"
      stdlib.logger.info "Please consider running: sudo chmod ${2} ${1}"
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
  esac

  return "${return_code}"
}
