#!/bin/bash

# pictl disk cli library

set -eo pipefail

_disk_cli() {
  # $1: the subcommand to execute

  case "${1}" in
    filesystem)
      _disk_cli_status_filesystem
      ;;
    hardware)
      _disk_cli_status_hardware
      ;;
    *)
      _disk_cli_usage_error
      ;;
  esac
}

_disk_cli_status_filesystem() {
  _dependencies_group_disks_cli_filesystem

  echo "-- rpi-media-centre disk filesystem status --"

  lsblk -f
}

_disk_cli_status_hardware() {
  local RPI_DISK_DEVICE

  echo "-- rpi-media-centre disk hardware status --"

  _dependencies_group_disks_cli_hardware

  while read -r RPI_DISK_DEVICE; do

    if [[ -e "/dev/${RPI_DISK_DEVICE}" ]]; then
      hdparm -C "/dev/${RPI_DISK_DEVICE}" || continue
    fi
  done <<< "$(lsblk | grep disk | grep -v "mmc" | cut -d ' ' -f 1)"
}

_disk_cli_usage() {
  echo "-- rpi-media-centre disk manager --"
  echo "Usage:"
  echo -e "\tpictl disk [SUBCOMMAND]"
  echo -e "\t      filesystem             - display filesystem details"
  echo -e "\t      hardware               - display hardware details"
}

_disk_cli_usage_error() {
  {
    _disk_cli_usage
  } >&2
  return 127
}
