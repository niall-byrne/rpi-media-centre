#!/bin/bash

# stdlib fn assert library

builtin set -eo pipefail

stdlib.fn.assert.not_fn() {
  # $1: the function name to assert does not exist

  local return_code=0

  stdlib.fn.query.is_fn "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "$(stdlib.message.get IS_FN "${1}")"
      return 1
      ;;
    1)
      return 0
      ;;
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  return "${return_code}"
}
