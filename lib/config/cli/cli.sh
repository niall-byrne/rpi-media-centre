#!/bin/bash

# pictl config cli library

set -eo pipefail

_config_cli_check() {
  _config_pictl_check
  _cli_log_success "The rpi-media-centre config file has no syntax errors!"
}

_config_cli_debug() {
  _config_pictl_debug
}

_config_cli_details() {
  _cli_pretty_title "** Details for the ${RPI_MANIFEST_CONFIG} file **"
  _config_pictl_help
}

_config_cli_edit() {
  if ! stdlib.io.path.query.is_file "${RPI_MANIFEST_CONFIG}"; then
    _io_colours_unload
    {
      echo
      _config_cli_details |
        stdlib.string.lines.map.format_pipe "# %s"
    } > "${RPI_MANIFEST_CONFIG}" # KCOV_EXCLUDE_LINE
    stdlib.security.path.secure "${RPI_MANIFEST_CONFIG}" "root" "root" "600"
    _io_colours_load
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_CONFIG}"
  _config_cli_check
}
