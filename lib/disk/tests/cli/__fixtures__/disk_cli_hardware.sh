#!/bin/bash

_fixture_disk_cli_hardware() {
  local LSBLK_DATA

  LSBLK_DATA="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/cli/__fixtures__/lsblk.txt)"

  _mock.create _dependencies_group_disks_cli_hardware

  _mock.create lsblk
  lsblk.mock.set.stdout "${LSBLK_DATA}"

  _mock.create hdparm
  hdparm.mock.set.subcommand "echo -e \"\n\$2:\ndrive state is:  standby\""

  _mock.create _disk_pretty_hardware_status
}
