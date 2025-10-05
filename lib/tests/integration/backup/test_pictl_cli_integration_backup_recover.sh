#!/bin/bash

setup() {
  _mock.create _backup_cli_recover
}

test_pictl_cli__integration__backup_recover__calls_target_function_correctly() {
  _pictl_cli backup recover target_job

  _backup_cli_recover.mock.assert_called_once_with \
    "1(target_job)"
}
