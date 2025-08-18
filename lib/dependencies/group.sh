#!/bin/bash

# pictl dependencies group library

set -eo pipefail

_dependencies_group_backups_aws() {
  _dependencies_requirement_awscli
}

_dependencies_group_backups_cli_keyfile() {
  _dependencies_requirement_generic "openssl"
}

_dependencies_group_backups_cli_queue() {
  _dependencies_requirement_generic "tree"
}

_dependencies_group_backups_rsync() {
  _dependencies_requirement_generic "rsync"
}

_dependencies_group_backups_tarball() {
  _dependencies_requirement_generic "tar"
}

_dependencies_group_cli() {
  _dependencies_requirement_generic "sudo"
}

_dependencies_group_containers() {
  _dependencies_requirement_generic "curl"
  _dependencies_requirement_generic "docker"
}

_dependencies_group_disks_cli_filesystem() {
  _dependencies_enforce "lsblk" \
    "The application lsblk" \
    "Please consider running: sudo apt-get install util-linux"
}

_dependencies_group_disks_cli_hardware() {
  _dependencies_requirement_generic "hdparm"

  _dependencies_enforce "lsblk" \
    "The application lsblk" \
    "Please consider running: sudo apt-get install util-linux"
}

_dependencies_group_disks_crypt() {
  _dependencies_requirement_generic "cryptsetup"
}

_dependencies_group_installer() {
  _dependencies_enforce "envsubst" \
    "The application envsubst" \
    "Please consider running: sudo apt-get install gettext-base"

  _dependencies_requirement_generic "git"

  _dependencies_enforce "systemd" \
    "The application systemd" \
    "  - You may be using a different init system, that's ok, but it's not officially supported."$'\n'"  - It's totally feasible to use a generic cron job to run the backup scheduler, but this is something that's hands on right now."
}

_dependencies_group_manifest_cli_editor() {
  _dependencies_requirement_manifest_editor
}
