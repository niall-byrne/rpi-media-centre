#!/bin/bash

# stdlib security path assert has library

set -eo pipefail

stdlib.security.path.assert.has_group() {
  # $1: the path to check
  # $2: the required group name

  local return_code=0

  stdlib.security.path.query.has_group "${@}" || return_code="$?"

  case "${return_code}" in
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    1)
      stdlib.logger.error "SECURITY: The group ownership on '${1}' is not secure!"
      stdlib.logger.info "Please consider running: sudo chgrp ${2} ${1}"
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
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
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    1)
      stdlib.logger.error "SECURITY: The ownership on '${1}' is not secure!"
      stdlib.logger.info "Please consider running: sudo chown ${2} ${1}"
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
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
    #:nocov:
    # bashcov doesn't report this section correctly
    0) ;;
    #:nocov:
    1)
      stdlib.logger.error "SECURITY: The permissions on '${1}' are not secure!"
      stdlib.logger.info "Please consider running: sudo chmod ${2} ${1}"
      ;;
    *)
      stdlib.logger.error "Invalid arguments provided!"
      ;;
  esac

  return "${return_code}"
}
