#!/bin/bash

# pictl disk cli library

set -eo pipefail

_disk_cli_filesystem() {
  _dependencies_group_disks_cli_filesystem

  _cli_pretty_title "-- rpi-media-centre disk filesystem status --"

  lsblk -f |
    _disk_pretty_filesystem_status
}

_disk_cli_hardware() {
  local RPI_DISK_DEVICE
  local RPI_DISK_DETAILS

  _cli_pretty_title "-- rpi-media-centre disk hardware status --"

  _dependencies_group_disks_cli_hardware

  while read -r RPI_DISK_DEVICE; do

    if [[ -n ${RPI_DISK_DEVICE} && -e "/dev/${RPI_DISK_DEVICE}" ]]; then
      RPI_DISK_DETAILS="$(
        hdparm -C "/dev/${RPI_DISK_DEVICE}" |
          awk 'NR > 1'
      )" || continue

      _disk_pretty_hardware_status "${RPI_DISK_DETAILS}"

    fi
  done <<< "$(
    lsblk |
      grep disk |
      grep -v "mmc" |
      cut -d ' ' -f 1
  )"
}
