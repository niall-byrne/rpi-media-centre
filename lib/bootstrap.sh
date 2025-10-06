#!/bin/bash

# pictl bootstrap library

set -eo pipefail

_bootstrap() {
  _bootstrap_configuration "$@"

  _cli_compiler_build_cli

  _pictl_cli "$@"
}

_bootstrap_configuration() {
  # shellcheck disable=SC2034
  local RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY=()

  if [[ "${1}" == "install" ]] && [[ "${2}" == "account" ]]; then
    RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY+=("account")
  fi

  _dependencies_group_cli
  _security_root_require
  _config_pictl
  _io_colours_load

  _config_pictl_validation
}
