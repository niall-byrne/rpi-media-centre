#!/bin/bash

setup() {
  _mock.create _install_cli_account
}

test_pictl_cli__integration__install_account__calls_target_function_correctly() {
  _pictl_cli install account

  _install_cli_account.mock.assert_called_once_with ""
}
