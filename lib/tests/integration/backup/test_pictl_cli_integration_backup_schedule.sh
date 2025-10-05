#!/bin/bash

setup() {
  _mock.create _backup_cli_schedule
}

test_pictl_cli__integration__backup_schedule__calls_target_function_correctly() {
  _pictl_cli backup schedule target_group

  _backup_cli_schedule.mock.assert_called_once_with \
    "1(target_group)"
}
