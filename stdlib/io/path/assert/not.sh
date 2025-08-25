#!/bin/bash

# stdlib io path assert not library

builtin set -eo pipefail

stdlib.io.path.assert.not_exists() {
  # $1: the path to check

  local return_code=0

  stdlib.io.path.query.is_exists "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_EXISTS "${1}")"
      return 1
      ;;
    1)
      return 0
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  return "${return_code}"
}
