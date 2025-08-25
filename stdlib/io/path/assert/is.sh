#!/bin/bash

# stdlib io path assert library

builtin set -eo pipefail

stdlib.io.path.assert.is_exists() {
  # $1: the path to check

  local return_code=0

  stdlib.io.path.query.is_exists "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_DOES_NOT_EXIST "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.io.path.assert.is_file() {
  # $1: the folder to check

  local return_code=0

  stdlib.io.path.query.is_file "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_IS_NOT_A_FILE "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.io.path.assert.is_folder() {
  # $1: the folder to check

  local return_code=0

  stdlib.io.path.query.is_folder "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_IS_NOT_A_FOLDER "${1}")"
      ;;
  esac

  return "${return_code}"
}
