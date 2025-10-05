#!/bin/bash

# pictl install cli library

set -eo pipefail

_install_cli_account() {
  _install_account
}

_install_cli_pictl() {
  # $@: the install cli args

  _install_pictl_ephemeral_installer "$@"
}
