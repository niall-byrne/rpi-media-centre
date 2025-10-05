#!/bin/bash

# pictl install pictl library

set -eo pipefail

_install_pictl_ephemeral_installer() {
  # $@: the install cli args

  local RPI_EPHEMERAL_INSTALLER

  RPI_EPHEMERAL_INSTALLER="$(mktemp)"

  stdlib.security.path.secure "${RPI_EPHEMERAL_INSTALLER}" \
    "root" \
    "root" \
    700

  cat "${RPI_WORKING_DIRECTORY}/lib/install/installer.sh" \
    > "${RPI_EPHEMERAL_INSTALLER}"
  echo "_installer $*" >> "${RPI_EPHEMERAL_INSTALLER}"

  RPI_EXIT_CLEANUP_PATHS+=("${RPI_EPHEMERAL_INSTALLER}")

  # shellcheck source=lib/install/installer.sh
  source "${RPI_EPHEMERAL_INSTALLER}"
}
