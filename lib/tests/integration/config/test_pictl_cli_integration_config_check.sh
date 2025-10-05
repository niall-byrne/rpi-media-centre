#!/bin/bash

setup() {
  _mock.create _config_cli_check
}

test_pictl_cli__integration__config_check__calls_target_function_correctly() {
  _pictl_cli config check

  _config_cli_check.mock.assert_called_once_with ""
}
