#!/bin/bash

setup() {
  _mock.create _disk_cli_manifest_cli_edit
}

test_pictl_cli__integration__disk_manifest_edit__calls_target_function_correctly() {
  _pictl_cli disk manifest edit

  _disk_cli_manifest_cli_edit.mock.assert_called_once_with ""
}
