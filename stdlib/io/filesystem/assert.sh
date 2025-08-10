#!/bin/bash
# @file assert.sh
# @brief A library for making assertions about the filesystem.
# @description
#   This library provides functions to make assertions about the filesystem,
#   such as checking if a path exists, if it's a file or a folder.

# stdlib io filesystem assert library

set -eo pipefail

# @description Asserts that a path exists on the filesystem.
# @arg $1 string The path to check.
# @exitcode 0 If the path exists.
# @exitcode 1 If the path does not exist.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the path does not exist or if the arguments are invalid.
stdlib.io.filesystem.assert.exists() {
  local return_code=0

  stdlib.io.filesystem.query.exists "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    126 | 127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The path '${1}' does not exist on the filesystem!"
      ;;
  esac

  return "${return_code}"
}

# @description Asserts that a path is a file.
# @arg $1 string The path to check.
# @exitcode 0 If the path is a file.
# @exitcode 1 If the path is not a file.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the path is not a file or if the arguments are invalid.
stdlib.io.filesystem.assert.is_file() {
  local return_code=0

  stdlib.io.filesystem.query.is_file "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    126 | 127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The path '${1}' is not a valid filesystem file!"
      ;;
  esac

  return "${return_code}"
}

# @description Asserts that a path is a folder.
# @arg $1 string The path to check.
# @exitcode 0 If the path is a folder.
# @exitcode 1 If the path is not a folder.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the path is not a folder or if the arguments are invalid.
stdlib.io.filesystem.assert.is_folder() {
  local return_code=0

  stdlib.io.filesystem.query.is_folder "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    126 | 127)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
    *)
      stdlib.logger.error "The path '${1}' is not a valid filesystem folder!"
      ;;
  esac

  return "${return_code}"
}

# @description Asserts that a path does not exist on the filesystem.
# @arg $1 string The path to check.
# @exitcode 0 If the path does not exist.
# @exitcode 1 If the path exists.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stderr Logs an error message if the path exists or if the arguments are invalid.
stdlib.io.filesystem.assert.not_exists() {
  local return_code=0

  stdlib.io.filesystem.query.exists "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "The path '${1}' exists on the filesystem!"
      return 1
      ;;
    1)
      return 0
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
  esac

  return "${return_code}"
}
