#!/bin/bash

# pictl filesystem library

set -eo pipefail

_filesystem_check_permissions() {
  # $1: the path to check
  # $2: the permission octal value required

  if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
    {
      echo "The permissions on '${1}' are not secure!"
      echo "Please consider running: chmod ${2} ${1}"
    } >&2
    return 127
  fi
}
