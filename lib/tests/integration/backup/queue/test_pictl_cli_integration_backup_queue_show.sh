#!/bin/bash

setup() {
  _mock.create _backup_cli_queue_cli_show
}

test_pictl_cli__integration__backup_queue_show__calls_target_function_correctly() {
  _pictl_cli backup queue show

  _backup_cli_queue_cli_show.mock.assert_called_once_with ""
}
