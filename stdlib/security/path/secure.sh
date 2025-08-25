#!/bin/bash

# stdlib security path secure library

builtin set -eo pipefail

stdlib.security.path.secure() {
  # $1: the filesystem path to secure
  # $2: the owner name to set
  # $3: the group name to set
  # $4: the permission octal value to set

  stdlib.fn.args.require "4" "0" "${@}" || return "$?"

  chown "${2}":"${3}" "${1}"
  chmod "${4}" "${1}"
}
