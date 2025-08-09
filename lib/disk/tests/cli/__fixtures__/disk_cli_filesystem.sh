#!/bin/bash

_fixture_disk_cli_filesystem() {
  _mock.create _dependencies_group_disks_cli_filesystem

  _mock.create lsblk
  lsblk.mock.set.stdout "lsblk output"

  _mock.create _disk_pretty_filesystem_status
  _disk_pretty_filesystem_status.mock.set.pipeable "1"
}
