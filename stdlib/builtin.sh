#!/bin/bash

# stdlib builtin library

builtin set -eo pipefail

_STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=""

stdlib.builtin.overridable() {
  # $1: the command to execute (# noqa)
  # _STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN

  local use_builtin_boolean="${_STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN:-0}"

  if [[ "${use_builtin_boolean}" == "0" ]]; then
    builtin "${@}"
  else
    "${@}"
  fi
}
