#!/bin/bash

# pictl installer cli library

set -eo pipefail

_installer_cli() {
  # $@: the installer cli args

  _installer_cli_ephemeral_installer "$@"
}

_installer_cli_ephemeral_installer() {
  # $@: the installer cli args

  local RPI_EPHEMERAL_INSTALLER

  RPI_EPHEMERAL_INSTALLER="$(mktemp)"

  stdlib.security.path.secure \
    "${RPI_EPHEMERAL_INSTALLER}" \
    "root" \
    "root" \
    700

  cat "${RPI_WORKING_DIRECTORY}/lib/installer/installer.sh" \
    > "${RPI_EPHEMERAL_INSTALLER}"
  echo "_installer $*" >> "${RPI_EPHEMERAL_INSTALLER}"

  RPI_EXIT_CLEANUP_PATHS+=("${RPI_EPHEMERAL_INSTALLER}")

  # shellcheck source=lib/installer/installer.sh
  source "${RPI_EPHEMERAL_INSTALLER}"
}
