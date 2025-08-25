#!/bin/bash

# stdlib security assert user library

builtin set -eo pipefail

stdlib.security.user.assert.is_root() {

  local return_code=0

  stdlib.security.user.query.is_root "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_MUST_BE_RUN_AS_ROOT)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  return "${return_code}"
}
