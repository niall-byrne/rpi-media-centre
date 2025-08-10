#!/bin/bash
# @file assert.sh
# @brief A library for making assertions about functions.
# @description
#   This library provides functions to make assertions about functions,
#   such as checking if a function exists.

# stdlib fn assert library

set -eo pipefail

# @description Asserts that a function exists.
# @arg $1 string The name of the function to check.
# @exitcode 0 If the function exists.
# @exitcode 1 If the function does not exist.
# @exitcode 126 If the function name is empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the function does not exist or if the arguments are invalid.
stdlib.fn.assert.is_fn() {
  local return_code=0

  stdlib.fn.query.is_fn "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The function '${1}' doesn't exist!"
      ;;
  esac

  return "${return_code}"
}
