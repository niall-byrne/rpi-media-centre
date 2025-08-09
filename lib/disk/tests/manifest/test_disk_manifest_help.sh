#!/bin/bash

setup() {
  _fixture_mock_pretty
  _cli_pretty_columns.mock.set.pipeable "1"
}

test_disk_manifest_help__creates_a_highlighted_line() {
  _disk_manifest_help

  _cli_pretty_highlight.mock.assert_called_once_with \
    "Each line should be a comma separated series of:"
}

test_disk_manifest_help__creates_columned_data() {
  _disk_manifest_help

  _cli_pretty_columns.mock.assert_count_is "1"
  _cli_pretty_columns.mock.assert_call_n_is "1" \
    " RPI_DISK_UUID        |the \`UUID\` of the disk (find with: sudo blkid) RPI_DISK_NAME        |a unique name for this disk RPI_DISK_CRYPT_GROUP |an optional identifier for disks that share a luks password RPI_DISK_MOUNT_POINT |a valid mount point for this disk on the filesystem"
}

test_disk_manifest_help__outputs_expected_data() {
  _cli_pretty_highlight.mock.set.stdout "expected output1"
  _cli_pretty_columns.mock.set.stdout "expected output2"

  _capture.stdout _disk_manifest_help

  assert_output "expected output1"$'\n'"expected output2"
}
