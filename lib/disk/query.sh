#!/bin/bash

# pictl disk query library

set -eo pipefail

_is_disk_encrypted() {
  test -f /etc/rpi/crypt
}

_is_disk_mounted() {
  if ! mountpoint "${RPI_DISK_MOUNT_POINT}" >> /dev/null 2>&1; then
    _cli_log_error "The disk with UUID '${RPI_DISK_UUID}' is not mounted !"
    return 127
  fi
}

_is_disk_mounted_all() {
  _disk_manifest_all_command "_is_disk_mounted"
}
