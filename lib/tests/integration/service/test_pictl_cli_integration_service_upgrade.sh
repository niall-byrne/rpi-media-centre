#!/bin/bash

setup() {
  _mock.create _service_cli_upgrade
}

test_pictl_cli__integration__service_upgrade__calls_target_function_correctly() {
  _pictl_cli service upgrade

  _service_cli_upgrade.mock.assert_called_once_with ""
}

