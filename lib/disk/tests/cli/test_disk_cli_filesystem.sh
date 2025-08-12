#!/bin/bash

load "${RPI_WORKING_DIRECTORY}/lib/disk/tests/cli/__fixtures__/disk_cli_filesystem.sh"

setup() {
  _fixture_disk_cli_filesystem
}

test_disk_cli_filesystem__calls_correct_dependencies_group() {
  _capture_pretty _capture_rc _disk_cli_filesystem

  assert_equals "1" "$(_dependencies_group_disks_cli_filesystem.mock.get.count)"
  assert_equals "" "$(_dependencies_group_disks_cli_filesystem.mock.get.call "1")"
  assert_rc "0"
}

test_disk_cli_filesystem__calls_lsblk_and_pipes_correctly() {
  _capture_pretty _capture_rc _disk_cli_filesystem

  assert_equals "1" "$(lsblk.mock.get.count)"
  assert_equals "-f" "$(lsblk.mock.get.call "1")"
  assert_equals "1" "$(_disk_pretty_filesystem_status.mock.get.count)"
  assert_equals "lsblk output" "$(_disk_pretty_filesystem_status.mock.get.call "1")"
  assert_rc "0"
}

test_disk_cli_filesystem__outputs_expected_string() {
  _disk_pretty_filesystem_status.mock.set.stdout "mocked filesystem status"

  TEST_OUTPUT="$(_disk_cli_filesystem)"

  assert_equals \
    "${THEME_TITLE}-- rpi-media-centre disk filesystem status --${THEME_NC}
mocked filesystem status" \
    "${TEST_OUTPUT}"
}
