#!/bin/bash

# stdlib fn assert library

builtin set -eo pipefail

stdlib.fn.assert.is_fn() {
  # $1: the function name to query

  local return_code=0

  stdlib.fn.query.is_fn "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_FN "${1}")"
      ;;
  esac

  return "${return_code}"
}

stdlib.fn.assert.is_valid_name() {
  # $1: the function name to query

  local return_code=0

  stdlib.fn.query.is_valid_name "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FUNCTION_NAME_INVALID "${1}")"
      ;;
  esac

  return "${return_code}"
}
