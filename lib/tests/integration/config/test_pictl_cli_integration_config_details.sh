#!/bin/bash

setup() {
  _mock.create _config_cli_details
}

test_pictl_cli__integration__config_details__calls_target_function_correctly() {
  _pictl_cli config details

  _config_cli_details.mock.assert_called_once_with ""
}
