#!/bin/bash

# stdlib fn query is library

builtin set -eo pipefail

stdlib.fn.query.is_fn() {
  # $1: the function name to query

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  if ! builtin declare -f "${1}" > /dev/null; then
    return 1
  fi
  return 0
}

stdlib.fn.query.is_valid_name() {
  # $1: the string to check for fn compatibility

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  # shellcheck disable=SC1001
  case "${1}" in
    *[!A-Za-z0-9_.@\-]*)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}
