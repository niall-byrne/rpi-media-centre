#!/bin/bash

# pictl backup manifest cli library

set -eo pipefail

_disk_cli_manifest_cli_check() {
  _disk_manifest_command_all _disk_manifest_line_log_all
  _cli_log_success "The rpi-media-centre crypt manifest file is valid!"
}

_disk_cli_manifest_cli_details() {
  _cli_pretty_title "** Details for the ${RPI_MANIFEST_CRYPT} file **"
  _disk_manifest_help
}

_disk_cli_manifest_cli_edit() {
  if ! stdlib.io.path.query.is_file "${RPI_MANIFEST_CRYPT}"; then
    _io_colours_unload
    {
      echo
      _disk_cli_manifest_cli_details |
        stdlib.string.lines.map.format_pipe "# %s"
    } > "${RPI_MANIFEST_CRYPT}" # KCOV_EXCLUDE_LINE
    stdlib.security.path.secure "${RPI_MANIFEST_CRYPT}" "root" "root" "600"
    _io_colours_load
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_CRYPT}"
  _disk_cli_manifest_cli_check
}
