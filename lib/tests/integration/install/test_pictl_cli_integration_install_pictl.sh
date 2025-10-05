#!/bin/bash

setup() {
  _mock.create _install_cli_pictl
}

test_pictl_cli__integration__install_pictl__calls_target_function_correctly() {
  _pictl_cli install pictl mock_sha

  _install_cli_pictl.mock.assert_called_once_with \
    "1(mock_sha)"
}
