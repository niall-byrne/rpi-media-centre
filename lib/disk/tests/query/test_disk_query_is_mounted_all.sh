#!/bin/bash

test_is_disk_mounted_all__calls_disk_manifest_call_command_as_expected() {
  _mock.create _disk_manifest_all_command

  _is_disk_mounted_all

  _disk_manifest_all_command.mock.assert_called_once_with "1(_is_disk_mounted)"
}
