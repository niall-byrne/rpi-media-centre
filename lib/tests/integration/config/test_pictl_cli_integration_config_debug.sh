#!/bin/bash

setup() {
  _mock.create _config_cli_debug
}

test_pictl_cli__integration__config_debug__calls_target_function_correctly() {
  _pictl_cli config debug

  _config_cli_debug.mock.assert_called_once_with ""
}
