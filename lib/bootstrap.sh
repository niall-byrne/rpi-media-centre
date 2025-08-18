#!/bin/bash

# pictl bootstrap library

set -eo pipefail

_bootstrap() {
  _bootstrap_configuration_and_security "$@"

  _cli_bootstrap

  _pictl_cli "$@"
}

_bootstrap_configuration_and_security() {
  _dependencies_group_cli
  _security_root_require
  _configuration_pictl
  _io_colours_load
  _security_validate

  if [[ "${1}" != "account" ]]; then
    _security_defaults_set
    _security_warning_single_user_mode
  fi
}
