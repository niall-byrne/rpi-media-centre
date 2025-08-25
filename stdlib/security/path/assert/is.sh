#!/bin/bash

# stdlib security path assert is library

builtin set -eo pipefail

stdlib.security.path.assert.is_secure() {
  # $1: the filesystem path to check
  # $2: the required user name
  # $3: the required group name
  # $4: the permission octal value required

  [[ "${#@}" == "4" ]] || return 127

  stdlib.security.path.assert.has_owner "${1}" "${2}" || return "$?"
  stdlib.security.path.assert.has_group "${1}" "${3}" || return "$?"
  stdlib.security.path.assert.has_permissions "${1}" "${4}" || return "$?"
}
