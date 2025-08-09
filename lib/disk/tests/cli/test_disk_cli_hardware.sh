#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/cli/__fixtures__/disk_cli_hardware.sh"
_testing.load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/__fakes__/block_devices.sh"

setup() {
  _fixture_disk_cli_hardware
}

test_disk_cli_hardware__calls_correct_dependencies_group() {
  _capture_pretty _disk_cli_hardware

  assert_equals "1" "$(_dependencies_group_disks_cli_hardware.mock.get.count)"
  assert_equals "" "$(_dependencies_group_disks_cli_hardware.mock.get.call "1")"
}

test_disk_cli_hardware__calls_lsblk_and_pipes_correctly() {
  _capture_pretty _disk_cli_hardware

  assert_equals "1" "$(lsblk.mock.get.count)"
  assert_equals "" "$(lsblk.mock.get.call "1")"
}

test_disk_cli_hardware__calls_hdparm_as_expected() {
  _fake_block_devices

  _capture_pretty _disk_cli_hardware

  assert_equals "3" "$(hdparm.mock.get.count)"
  assert_equals "-C /dev/sda" "$(hdparm.mock.get.call "1")"
  assert_equals "-C /dev/sdb" "$(hdparm.mock.get.call "2")"
  assert_equals "-C /dev/sdc" "$(hdparm.mock.get.call "3")"
}

test_disk_cli_hardware__hdparm_succeeds__zero_exit_code() {
  _fake_block_devices
  hdparm.mock.set.rc "0"

  _capture_pretty _capture.rc _disk_cli_hardware

  assert_equals "0" "${TEST_RC}"
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

  assert_equals "3" "$(_disk_pretty_hardware_status.mock.get.count)"
  assert_equals \
    "/dev/sda:
drive state is:  standby
/dev/sdb:
drive state is:  standby
/dev/sdc:
drive state is:  standby" \
    "$(_disk_pretty_hardware_status.mock.get.calls)"
}

test_disk_cli_hardware__outputs_expected_string() {
  _fake_block_devices
  _disk_pretty_hardware_status.mock.set.stdout "mocked pretty hardware status"

  local _BLOCK_DEVICE
  local _BLOCK_DEVICE_COUNTER=0
  local _BLOCK_DEVICE_STATUS

  TEST_OUTPUT="$(_disk_cli_hardware)"

  assert_equals \
    "${THEME_TITLE}-- rpi-media-centre disk hardware status --${THEME_NC}
mocked pretty hardware status
mocked pretty hardware status
mocked pretty hardware status" \
    "${TEST_OUTPUT}"
}
