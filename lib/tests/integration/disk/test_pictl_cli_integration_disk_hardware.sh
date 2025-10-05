#!/bin/bash

setup() {
  _mock.create _disk_cli_hardware
}

test_pictl_cli__integration__disk_hardware__calls_target_function_correctly() {
  _pictl_cli disk hardware

  _disk_cli_hardware.mock.assert_called_once_with ""
}
