#!/bin/bash

# pictl manifest cli library

set -eo pipefail

_manifest_cli() {
  # $1: the subcommand to execute

  case "${1}" in
    check)
      _manifest_cli_check "${2}"
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

_manifest_cli_check_crypt() {
  _disk_manifest_all_command _disk_manifest_line_log_all
  echo "The rpi-media-centre crypt manifest file is valid!"
}

_manifest_cli_help() {
  # $1: the manifest to get help on

  case "${1}" in
    backup)
      _manifest_cli_help_backup
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
  echo "** Details for the .rpi/backup file **"
  _backup_manifest_help
}

_manifest_cli_help_crypt() {
  echo "** Details for the .rpi/crypt file **"
  _disk_manifest_help
}

_manifest_cli_usage() {
  echo "-- rpi-media-centre manifests manager --"
  echo "Usage:"
  echo -e "\tpictl manifest [SUBCOMMAND] [manifest]"
  echo -e "\t      check  (backup|crypt)   - check the specified manifest file for errors"
  echo -e "\t      help   (backup|crypt)   - get details on the specified manifest file format"
}
