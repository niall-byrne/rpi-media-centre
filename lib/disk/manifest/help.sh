#!/bin/bash

# pictl disk manifest help library

set -eo pipefail

_disk_manifest_help() {
  _cli_pretty_highlight "Each line should be a comma separated series of:"
  {
    echo " RPI_DISK_UUID        |the \`UUID\` of the disk (find with: sudo blkid)"
    echo " RPI_DISK_NAME        |a unique name for this disk"
    echo " RPI_DISK_CRYPT_GROUP |an optional identifier for disks that share a luks password"
    echo " RPI_DISK_MOUNT_POINT |a valid mount point for this disk on the filesystem"
  } | _cli_pretty_columns_pipe
}
