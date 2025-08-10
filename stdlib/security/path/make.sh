#!/bin/bash
# @file make.sh
# @brief A library for creating files and directories with specific ownership and permissions.
# @description
#   This library provides functions to create files and directories and secure them
#   by setting the owner, group, and permissions.

# stdlib security path make library

set -eo pipefail

# @description Creates a directory and sets its ownership and permissions.
# @arg $1 string The directory to create.
# @arg $2 string The owner name to set.
# @arg $3 string The group name to set.
# @arg $4 string The permission octal value to set.
# @exitcode 126 If any of the arguments are empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.security.path.make.dir() {
  [[ "${#@}" == "4" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126
  [[ -n "${3}" ]] || return 126
  [[ -n "${4}" ]] || return 126

  mkdir -p "${1}"
  stdlib.security.path.secure "${@}"
}

# @description Creates a file and sets its ownership and permissions.
# If the parent directory does not exist, it will be created.
# @arg $1 string The file to create.
# @arg $2 string The owner name to set.
# @arg $3 string The group name to set.
# @arg $4 string The permission octal value to set.
# @exitcode 126 If any of the arguments are empty.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.security.path.make.file() {
  [[ "${#@}" == "4" ]] || return 127
  [[ -n "${1}" ]] || return 126
  [[ -n "${2}" ]] || return 126
  [[ -n "${3}" ]] || return 126
  [[ -n "${4}" ]] || return 126

  mkdir -p "$(dirname "${1}")"
  touch "${1}"
  stdlib.security.path.secure "${@}"
}
