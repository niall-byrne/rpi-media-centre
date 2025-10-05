#!/bin/bash

setup() {
  _mock.create _backup_cli_queue_cli_remove-all
}

test_pictl_cli__integration__backup_queue_remove-all_calls__target_function_correctly() {
  _pictl_cli backup queue remove-all

  _backup_cli_queue_cli_remove-all.mock.assert_called_once_with ""
}
