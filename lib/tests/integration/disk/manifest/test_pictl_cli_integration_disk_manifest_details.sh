#!/bin/bash

setup() {
  _mock.create _disk_cli_manifest_cli_details
}

test_pictl_cli__integration__disk_manifest_details__calls_target_function_correctly() {
  _pictl_cli disk manifest details

  _disk_cli_manifest_cli_details.mock.assert_called_once_with ""
}
