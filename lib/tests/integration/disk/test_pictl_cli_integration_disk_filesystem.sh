#!/bin/bash

setup() {
  _mock.create _disk_cli_filesystem
}

test_pictl_cli__integration__disk_filesystem__calls_target_function_correctly() {
  _pictl_cli disk filesystem

  _disk_cli_filesystem.mock.assert_called_once_with ""
}
