#!/bin/bash

setup() {
  _mock.create _backup_cli_queue_cli_remove
}

test_pictl_cli__integration__backup_queue_remove_calls__target_function_correctly() {
  _pictl_cli backup queue remove job_name

  _backup_cli_queue_cli_remove.mock.assert_called_once_with \
    "1(job_name)"
}
