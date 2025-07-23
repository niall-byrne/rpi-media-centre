#!/bin/bash

# stdlib fn query library

set -eo pipefail

stdlib.fn.query.is_fn() {
  # $1: the function name to query

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  if ! declare -f "${1}" > /dev/null; then
    return 1
  fi
  return 0
}
