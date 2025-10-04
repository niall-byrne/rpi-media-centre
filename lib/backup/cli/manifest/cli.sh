#!/bin/bash

# pictl backup cli manifest cli library

set -eo pipefail

_backup_cli_manifest_cli_check() {
  # shellcheck disable=SC2034
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=()

  _backup_manifest_command_all _backup_manifest_line_log_all
  _cli_log_success "The rpi-media-centre backup manifest file is valid!"
}

_backup_cli_manifest_cli_details() {
  _cli_pretty_title "** Details for the ${RPI_MANIFEST_BACKUP} file **"
  _backup_manifest_help
}

_backup_cli_manifest_cli_edit() {
  if ! stdlib.io.path.query.is_file "${RPI_MANIFEST_BACKUP}"; then
    _io_colours_unload
    {
      echo
      _backup_cli_manifest_cli_details |
        stdlib.string.lines.map.format_pipe "# %s"
    } > "${RPI_MANIFEST_BACKUP}" # KCOV_EXCLUDE_LINE
    stdlib.security.path.secure "${RPI_MANIFEST_BACKUP}" "root" "root" "600"
    _io_colours_load
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_BACKUP}"
  _backup_cli_manifest_cli_check
}
