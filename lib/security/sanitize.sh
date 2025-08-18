#!/bin/bash

# pictl security sanitize library

set -eo pipefail

_security_sanitize() {
  # $1: the value to sanitize

  local _TESTING_SANITIZE_VALUE="${1}"

  echo "${_TESTING_SANITIZE_VALUE//[\[\]\(\)\*\\\/;\ ]/}"
}

stdlib.fn.derive.var "_security_sanitize"
