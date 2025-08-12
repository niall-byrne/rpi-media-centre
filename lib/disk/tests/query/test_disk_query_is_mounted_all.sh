#!/bin/bash

test_is_disk_mounted_all__calls_disk_manifest_call_command_as_expected() {
  _mock.create _disk_manifest_all_command

  _is_disk_mounted_all

  assert_equals "1" "$(_disk_manifest_all_command.mock.get.count)"
  assert_equals "_is_disk_mounted" "$(_disk_manifest_all_command.mock.get.call "1")"
}
