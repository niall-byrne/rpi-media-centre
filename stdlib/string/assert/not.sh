#!/bin/bash

# stdlib string assert not library

builtin set -eo pipefail

stdlib.string.assert.not_equal() {
  # $1: the comparison value string
  # $2: the string to check

  local return_code=0

  [[ "${1}" != "${2}" ]] || return_code="1"
  [[ -n "${1}" ]] || return_code="126"
  [[ "${#@}" == "2" ]] || return_code="127"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_EQUAL "${1}")"
      ;;
  esac

  return "${return_code}"
}
