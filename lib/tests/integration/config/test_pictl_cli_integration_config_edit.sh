#!/bin/bash

setup() {
  _mock.create _config_cli_edit
}

test_pictl_cli__integration__config_edit__calls_target_function_correctly() {
  _pictl_cli config edit

  _config_cli_edit.mock.assert_called_once_with ""
}
