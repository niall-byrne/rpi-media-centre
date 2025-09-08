#!/bin/bash

# pictl shared variable testing fixtures

set -eo pipefail

_fixture_escape_rpi_vars() {
  local RPI_ENV_VAR_LIST
  local RPI_ENV_VAR
  local RPI_ENV_VARS_WHITE_LIST=("RPI_WORKING_DIRECTORY")

  RPI_ENV_VAR_LIST="$(
    declare -p |
      grep '^declare -. RPI_' |
      sed 's/^declare -. //g' |
      cut -d '=' -f 1
  )"

  for RPI_ENV_VAR in ${RPI_ENV_VAR_LIST}; do
    # shellcheck disable=SC2076
    if [[ " ${RPI_ENV_VARS_WHITE_LIST[*]} " =~ " ${RPI_ENV_VAR} " ]]; then
      continue
    fi
    if stdlib.array.query.is_array "${RPI_ENV_VAR}"; then
      continue
    fi
    printf -v "${RPI_ENV_VAR}" '%s' "\${${RPI_ENV_VAR}}"
  done
}
