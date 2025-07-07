#!/bin/bash

# pictl disk query library

set -eo pipefail

_is_disk_encrypted() {
  test -f .rpi/crypt
}

_is_disk_mounted() {
  mountpoint "${RPI_DISK_MOUNT_POINT}" >> /dev/null 2>&1
}

_is_disk_mounted_all() {
  _disk_manifest_all_command "_is_disk_mounted"
}
