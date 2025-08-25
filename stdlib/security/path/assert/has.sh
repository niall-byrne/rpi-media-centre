#!/bin/bash

# stdlib security path assert has library

builtin set -eo pipefail

stdlib.security.path.assert.has_group() {
  # $1: the path to check
  # $2: the required group name

  local return_code=0

  stdlib.security.path.query.has_group "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_INSECURE_GROUP_OWNERSHIP "${1}")"
      stdlib.logger.info "$(stdlib.message.get SECURITY_SUGGEST_CHGRP "${2}" "${1}")"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  return "${return_code}"
}

stdlib.security.path.assert.has_owner() {
  # $1: the path to check
  # $2: the required user name

  local return_code=0

  stdlib.security.path.query.has_owner "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_INSECURE_OWNERSHIP "${1}")"
      stdlib.logger.info "$(stdlib.message.get SECURITY_SUGGEST_CHOWN "${2}" "${1}")"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  return "${return_code}"
}

stdlib.security.path.assert.has_permissions() {
  # $1: the path to check
  # $2: the permission octal value required

  local return_code=0

  stdlib.security.path.query.has_permissions "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_INSECURE_PERMISSIONS "${1}")"
      stdlib.logger.info "$(stdlib.message.get SECURITY_SUGGEST_CHMOD "${2}" "${1}")"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  return "${return_code}"
}
