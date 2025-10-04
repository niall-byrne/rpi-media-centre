#!/bin/bash

# pictl manifest cli library

set -eo pipefail

_manifest_cli_check_backup() {
  # shellcheck disable=SC2034
  local RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY=()

  _backup_manifest_command_all _backup_manifest_line_log_all
  _cli_log_success "The rpi-media-centre backup manifest file is valid!"
}

_manifest_cli_check_config() {
  _configuration_pictl_check
  _cli_log_success "The rpi-media-centre configuration manifest file has no syntax errors!"
}

_manifest_cli_check_crypt() {
  _disk_manifest_all_command _disk_manifest_line_log_all
  _cli_log_success "The rpi-media-centre crypt manifest file is valid!"
}

_manifest_cli_details_backup() {
  _cli_pretty_title "** Details for the ${RPI_MANIFEST_BACKUP} file **"
  _backup_manifest_help
}

_manifest_cli_details_config() {
  _cli_pretty_title "** Details for the ${RPI_MANIFEST_CONFIG} file **"
  _configuration_pictl_help
}

_manifest_cli_details_crypt() {
  _cli_pretty_title "** Details for the ${RPI_MANIFEST_CRYPT} file **"
  _disk_manifest_help
}

_manifest_cli_edit_backup() {
  if ! stdlib.io.path.query.is_file "${RPI_MANIFEST_BACKUP}"; then
    _io_colours_unload
    {
      echo
      _manifest_cli_details_backup |
        stdlib.string.lines.map.format_pipe "# %s"
    } > "${RPI_MANIFEST_BACKUP}" # KCOV_EXCLUDE_LINE
    stdlib.security.path.secure "${RPI_MANIFEST_BACKUP}" "root" "root" "600"
    _io_colours_load
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_BACKUP}"
  _manifest_cli_check_backup
}

_manifest_cli_edit_config() {
  if ! stdlib.io.path.query.is_file "${RPI_MANIFEST_CONFIG}"; then
    _io_colours_unload
    {
      echo
      _manifest_cli_details_config |
        stdlib.string.lines.map.format_pipe "# %s"
    } > "${RPI_MANIFEST_CONFIG}" # KCOV_EXCLUDE_LINE
    stdlib.security.path.secure "${RPI_MANIFEST_CONFIG}" "root" "root" "600"
    _io_colours_load
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_CONFIG}"
  _manifest_cli_check_config
}

_manifest_cli_edit_crypt() {
  if ! stdlib.io.path.query.is_file "${RPI_MANIFEST_CRYPT}"; then
    _io_colours_unload
    {
      echo
      _manifest_cli_details_crypt |
        stdlib.string.lines.map.format_pipe "# %s"
    } > "${RPI_MANIFEST_CRYPT}" # KCOV_EXCLUDE_LINE
    stdlib.security.path.secure "${RPI_MANIFEST_CRYPT}" "root" "root" "600"
    _io_colours_load
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_CRYPT}"
  _manifest_cli_check_crypt
}
