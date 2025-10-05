#!/bin/bash

setup() {
  _mock.create _backup_cli_manifest_cli_check
}

test_pictl_cli__integration__backup_manifest_check__calls_target_function_correctly() {
  _pictl_cli backup manifest check

  _backup_cli_manifest_cli_check.mock.assert_called_once_with ""
}
