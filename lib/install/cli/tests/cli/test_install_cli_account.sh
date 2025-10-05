#!/bin/bash

setup() {
  _mock.create _install_account
}

test_install_cli_account__calls_install_account_ephemeral_install() {
  _install_cli_account

  _install_account.mock.assert_called_once_with ""
}
