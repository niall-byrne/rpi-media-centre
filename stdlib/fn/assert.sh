#!/bin/bash

# stdlib fn assert library

set -eo pipefail

stdlib.fn.assert.is_fn() {
  # $1: the function name to query

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
