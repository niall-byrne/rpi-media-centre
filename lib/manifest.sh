#!/bin/bash

# pictl manifest cli library

set -eo pipefail

_manifest_cli_check_backup() {
  _backup_manifest_all_command _backup_manifest_line_log_all
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
  _cli_pretty_title "** Details for the /etc/rpi/config file **"
  _configuration_pictl_help
}

_manifest_cli_details_crypt() {
  _cli_pretty_title "** Details for the ${RPI_MANIFEST_CRYPT} file **"
  _disk_manifest_help
}

_manifest_cli_edit_backup() {
  if [[ ! -f "${RPI_MANIFEST_BACKUP}" ]]; then
    _manifest_cli_details_backup |
      _io_comment_lines_stdin |
      _io_append_newline_stdin \
        > "${RPI_MANIFEST_BACKUP}"
    chmod "600" "${RPI_MANIFEST_BACKUP}"
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_BACKUP}"
  _manifest_cli_check_backup
}

_manifest_cli_edit_config() {
  if [[ ! -f /etc/rpi/config ]]; then
    _manifest_cli_details_config |
      _io_comment_lines_stdin |
      _io_append_newline_stdin \
        > /etc/rpi/config
    chmod "600" /etc/rpi/config
  fi

  "${RPI_MANIFEST_EDITOR}" /etc/rpi/config
  _manifest_cli_check_config
}

_manifest_cli_edit_crypt() {
  if [[ ! -f "${RPI_MANIFEST_CRYPT}" ]]; then
    _manifest_cli_details_crypt |
      _io_comment_lines_stdin |
      _io_append_newline_stdin \
        > "${RPI_MANIFEST_CRYPT}"
    chmod "600" "${RPI_MANIFEST_CRYPT}"
  fi

  "${RPI_MANIFEST_EDITOR}" "${RPI_MANIFEST_CRYPT}"
  _manifest_cli_check_crypt
}
