#!/bin/bash

# stdlib security path make library

builtin set -eo pipefail

stdlib.security.path.make.dir() {
  # $1: the directory to create
  # $2: the owner name to set
  # $3: the group name to set
  # $4: the permission octal value to set

  [[ "${#@}" == "4" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126
  [[ -n "${3}" ]] || return 126
  [[ -n "${4}" ]] || return 126

  mkdir -p "${1}"
  stdlib.security.path.secure "${@}"
}

stdlib.security.path.make.file() {
  # $1: the file to create
  # $2: the owner name to set
  # $3: the group name to set
  # $4: the permission octal value to set

  [[ "${#@}" == "4" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126
  [[ -n "${3}" ]] || return 126
  [[ -n "${4}" ]] || return 126

  touch "${1}"
  stdlib.security.path.secure "${@}"
}
