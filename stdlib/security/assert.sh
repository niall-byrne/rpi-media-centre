#!/bin/bash
# @file assert.sh
# @brief A library for making security-related assertions.
# @description
#   This library provides functions to make security-related assertions,
#   such as checking if the current user is the root user.

# stdlib security root library

set -eo pipefail

# @description Asserts that the current user is the root user.
# @exitcode 0 If the current user is root.
# @exitcode 1 If the current user is not root.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the current user is not root or if the arguments are invalid.
stdlib.security.assert.is_root_user() {

  local return_code=0

  stdlib.security.query.is_root_user "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    1)
      stdlib.logger.error "SECURITY: This script must be run as root."
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
  esac

  return "${return_code}"
}
