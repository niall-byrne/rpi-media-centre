#!/bin/bash

setup() {
  _mock.create _disk_cli_manifest_cli_check
}

test_pictl_cli__integration__disk_manifest_check__calls_target_function_correctly() {
  _pictl_cli disk manifest check

  _disk_cli_manifest_cli_check.mock.assert_called_once_with ""
}
