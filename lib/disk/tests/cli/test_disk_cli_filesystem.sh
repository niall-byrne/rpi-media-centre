#!/bin/bash

setup() {
  _mock.create _dependencies_group_disks_cli_filesystem

  _mock.create lsblk
  lsblk.mock.set.stdout "lsblk output"

  _mock.create _disk_pretty_filesystem_status_pipe
  _disk_pretty_filesystem_status_pipe.mock.set.pipeable "1"
}

test_disk_cli_filesystem__calls_correct_dependencies_group() {
  _capture_pretty _capture.rc _disk_cli_filesystem

  _dependencies_group_disks_cli_filesystem.mock.assert_called_once_with ""
  assert_rc "0"
}

test_disk_cli_filesystem__calls_lsblk_and_pipes_correctly() {
  _capture_pretty _capture.rc _disk_cli_filesystem

  lsblk.mock.assert_called_once_with "1(-f)"
  _disk_pretty_filesystem_status_pipe.mock.assert_called_once_with "1(lsblk output)"
  assert_rc "0"
}

test_disk_cli_filesystem__outputs_expected_string() {
  _disk_pretty_filesystem_status_pipe.mock.set.stdout "mocked filesystem status"

  TEST_OUTPUT="$(_disk_cli_filesystem)"

  assert_equals \
    "${THEME_TITLE}-- rpi-media-centre disk filesystem status --${THEME_NC}
mocked filesystem status" \
    "${TEST_OUTPUT}"
}
