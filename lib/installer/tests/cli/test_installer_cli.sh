#!/bin/bash

test_installer_cli__calls_installer_cli_ephemeral_installer() {
  _mock.create _installer_cli_ephemeral_installer

  _installer_cli "origin/dev"

  assert_equals "1" "$(_installer_cli_ephemeral_installer.mock.get.count)"
  assert_equals "origin/dev" "$(_installer_cli_ephemeral_installer.mock.get.call "1")"
}
