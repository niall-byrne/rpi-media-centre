#!/bin/bash

# stdlib io filesystem assert library

set -eo pipefail

stdlib.io.filesystem.assert.exists() {
  # $1: the path to check

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

stdlib.io.filesystem.assert.is_file() {
  # $1: the folder to check

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

stdlib.io.filesystem.assert.is_folder() {
  # $1: the folder to check

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

stdlib.io.filesystem.assert.not_exists() {
  # $1: the path to check

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
