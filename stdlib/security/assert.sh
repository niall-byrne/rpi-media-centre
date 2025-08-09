#!/bin/bash

# stdlib security root library

set -eo pipefail

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
