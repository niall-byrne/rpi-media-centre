#!/bin/bash

setup() {
  _mock.create _install_pictl_ephemeral_installer
}

test_install_cli_pictl__calls_install_pictl_ephemeral_installer() {
  _install_cli_pictl "origin/dev"

  _install_pictl_ephemeral_installer.mock.assert_called_once_with \
    "1(origin/dev)"
}
