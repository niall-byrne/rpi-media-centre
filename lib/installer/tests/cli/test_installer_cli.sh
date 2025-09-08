#!/bin/bash

test_installer_cli__calls_installer_cli_ephemeral_installer() {
  _mock.create _installer_cli_ephemeral_installer

  _installer_cli "origin/dev"

  _installer_cli_ephemeral_installer.mock.assert_called_once_with "1(origin/dev)"
}
