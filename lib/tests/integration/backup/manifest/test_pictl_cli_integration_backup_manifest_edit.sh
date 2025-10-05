#!/bin/bash

setup() {
  _mock.create _backup_cli_manifest_cli_edit
}

test_pictl_cli__integration__backup_manifest_edit__calls_target_function_correctly() {
  _pictl_cli backup manifest edit

  _backup_cli_manifest_cli_edit.mock.assert_called_once_with ""
}
