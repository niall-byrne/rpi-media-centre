#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/cli/tests/cli/__fixtures__/disk_cli_hardware.sh"
_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/cli/tests/cli/__fakes__/block_devices.sh"

setup() {
  _fixture_disk_cli_hardware
}

test_disk_cli_hardware__calls_correct_dependencies_group() {
  _capture_pretty _disk_cli_hardware

  _dependencies_group_disks_cli_hardware.mock.assert_called_once_with ""
}

test_disk_cli_hardware__calls_lsblk_and_pipes_correctly() {
  _capture_pretty _disk_cli_hardware

  lsblk.mock.assert_called_once_with ""
}

test_disk_cli_hardware__calls_hdparm_as_expected() {
  _fake_block_devices

  _capture_pretty _disk_cli_hardware

  hdparm.mock.assert_calls_are \
    "1(-C) 2(/dev/sda)" \
    "1(-C) 2(/dev/sdb)" \
    "1(-C) 2(/dev/sdc)"
}

test_disk_cli_hardware__hdparm_succeeds__zero_exit_code() {
  _fake_block_devices
  hdparm.mock.set.rc "0"

  _capture_pretty _capture.rc _disk_cli_hardware

  assert_rc "0"
}

test_disk_cli_hardware__hdparm_fails__zero_exit_code() {
  _fake_block_devices
  hdparm.mock.set.rc "1"

  _capture_pretty _capture.rc _disk_cli_hardware

  assert_rc "0"
}

test_disk_cli_hardware__calls_disk_pretty_hardware_status_as_expected() {
  _fake_block_devices

  local _BLOCK_DEVICE
  local _BLOCK_DEVICE_COUNTER=0
  local _BLOCK_DEVICE_STATUS

  _capture_pretty _disk_cli_hardware

  _disk_pretty_hardware_status.mock.assert_calls_are \
    "1(/dev/sda:
drive state is:  standby)" \
    "1(/dev/sdb:
drive state is:  standby)" \
    "1(/dev/sdc:
drive state is:  standby)"
}

test_disk_cli_hardware__outputs_expected_string() {
  _fake_block_devices
  _disk_pretty_hardware_status.mock.set.stdout "mocked pretty hardware status"

  local _BLOCK_DEVICE
  local _BLOCK_DEVICE_COUNTER=0
  local _BLOCK_DEVICE_STATUS

  _capture.output _disk_cli_hardware

  assert_output \
    "${THEME_TITLE}-- rpi-media-centre disk hardware status --${THEME_NC}
mocked pretty hardware status
mocked pretty hardware status
mocked pretty hardware status"
}
