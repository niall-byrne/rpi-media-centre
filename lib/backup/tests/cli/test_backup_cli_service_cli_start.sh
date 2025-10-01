#!/bin/bash

setup() {
  _mock.create _backup_scheduler_start
}

test_backup_cli_service_cli_start__starts_the_scheduler() {
  _backup_cli_service_cli_start

  _backup_scheduler_start.mock.assert_called_once_with ""
}
