#!/bin/bash

# pictl manifest cli library

set -eo pipefail

_manifest_cli() {
  # $1: the subcommand to execute

  case "${1}" in
    check)
      _manifest_cli_check "${2}"
      ;;
    edit)
      _manifest_cli_edit "${2}"
      ;;
    help)
      _manifest_cli_help "${2}"
      ;;
    *)
      {
        _manifest_cli_usage
      } >&2
      return 127
      ;;
  esac
}

_manifest_cli_check() {
  # $1: the manifest to check

  case "${1}" in
    backup)
      _manifest_cli_check_backup
      ;;
    config)
      _manifest_cli_check_config
      ;;
    crypt)
      _manifest_cli_check_crypt
      ;;
    *)
      {
        _manifest_cli_usage
      } >&2
      return 127
      ;;
  esac
}

_manifest_cli_check_backup() {
  _backup_manifest_all_command _backup_manifest_line_log_all
  echo "The rpi-media-centre backup manifest file is valid!"
}

_manifest_cli_check_config() {
  _configuration_pictl_check
  echo "The rpi-media-centre configuration manifest file has no syntax errors!"
}

_manifest_cli_check_crypt() {
  _disk_manifest_all_command _disk_manifest_line_log_all
  echo "The rpi-media-centre crypt manifest file is valid!"
}

_manifest_cli_edit() {
  # $1: the manifest to edit

  case "${1}" in
    backup)
      _dependencies_requirement_manifest_editor
      _manifest_cli_edit_backup
      ;;
    config)
      _dependencies_requirement_manifest_editor
      _manifest_cli_edit_config
      ;;
    crypt)
      _dependencies_requirement_manifest_editor
      _manifest_cli_edit_crypt
      ;;
    *)
      {
        _manifest_cli_usage
      } >&2
      return 127
      ;;
  esac
}

_manifest_cli_edit_backup() {
  if [[ ! -f /etc/rpi/backup ]]; then
    _manifest_cli_help_backup |
      _io_comment_lines_stdin |
      _io_append_newline_stdin \
        > /etc/rpi/backup
    chmod "600" /etc/rpi/backup
  fi

  "${RPI_MANIFEST_EDITOR}" /etc/rpi/backup
  _manifest_cli_check_backup
}

_manifest_cli_edit_config() {
  if [[ ! -f /etc/rpi/config ]]; then
    _manifest_cli_help_config |
      _io_append_newline_stdin \
        > ./etc/rpi/config
    chmod "600" /etc/rpi/config
  fi

  "${RPI_MANIFEST_EDITOR}" /etc/rpi/config
  _manifest_cli_check_config
}

_manifest_cli_edit_crypt() {
  if [[ ! -f /etc/rpi/crypt ]]; then
    _manifest_cli_help_crypt |
      _io_comment_lines_stdin |
      _io_append_newline_stdin \
        > /etc/rpi/crypt
    chmod "600" /etc/rpi/crypt
  fi

  "${RPI_MANIFEST_EDITOR}" /etc/rpi/crypt
  _manifest_cli_check_crypt
}

_manifest_cli_help() {
  # $1: the manifest to get help on

  case "${1}" in
    backup)
      _manifest_cli_help_backup
      ;;
    config)
      _manifest_cli_help_config
      ;;
    crypt)
      _manifest_cli_help_crypt
      ;;
    *)
      {
        _manifest_cli_usage
      } >&2
      return 127
      ;;
  esac
}

_manifest_cli_help_backup() {
  echo "** Details for the /etc/rpi/backup file **"
  _backup_manifest_help
}

_manifest_cli_help_config() {
  echo "** Details for the /etc/rpi/config file **"
  _configuration_pictl_help
}

_manifest_cli_help_crypt() {
  echo "** Details for the /etc/rpi/crypt file **"
  _disk_manifest_help
}

_manifest_cli_usage() {
  echo "-- rpi-media-centre manifests manager --"
  echo "Usage:"
  echo -e "\tpictl manifest [SUBCOMMAND]"
  echo -e "\t      check  [MANIFEST]      - check the specified manifest file for errors"
  echo -e "\t      edit   [MANIFEST]      - edit the specified manifest file"
  echo -e "\t      help   [MANIFEST]      - get details on the specified manifest file format"
  echo
  echo -e "\tValid Manifest Files:"
  echo -e "\t - backup"
  echo -e "\t - config"
  echo -e "\t - crypt"
}
